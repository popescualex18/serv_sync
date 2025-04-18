import 'dart:ui' as ui;
import 'package:cross_scroll/cross_scroll.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/main.dart';
import 'package:serv_sync/ui/state_management/cubits/daily_menu_overview_cubit/daily_menu_overview_cubit.dart';
import 'utils/file_saver_desktop.dart'
    if (dart.library.html) 'utils/file_saver_web.dart';

class DailyMenuOverviewPage extends StatefulWidget {
  const DailyMenuOverviewPage({super.key});

  @override
  State<DailyMenuOverviewPage> createState() => _DailyMenuOverviewPageState();
}

class _DailyMenuOverviewPageState extends State<DailyMenuOverviewPage> {
  final GlobalKey _exportKey = GlobalKey();
  ValueNotifier<bool> exportInProgress = ValueNotifier<bool>(false);
  late double minWidth = MediaQuery.of(context).size.width;
  double exportWidth = 2300;
  final _titleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.brown[900],
    fontFamily: 'Serif',
  );

  final _menuCategoryStyle = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.w600,
    color: Colors.brown[700],
    fontFamily: 'Serif',
  );

  final _itemStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
    fontFamily: 'Serif',
  );

  final _priceStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: Colors.brown[800],
    fontFamily: 'Serif',
  );

  Future<void> _captureAndSaveMenu() async {
    try {
      exportInProgress.value = true;

      await Future.delayed(
          Duration(milliseconds: 300)); // Give time for UI update
      RenderRepaintBoundary boundary = _exportKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 2.0);

      // Convert to PNG with a solid background color
      final Uint8List pngBytes =
          await _convertToPngWithBackground(image, Colors.white);
      var dateTimeNow = DateTime.now();
      final fileName =
          "Meniul zilei ${dateTimeNow.day}/${dateTimeNow.month}/${dateTimeNow.year}.png";
      saveImage(pngBytes, fileName, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      exportInProgress.value = false;
    }
  }

  Future<Uint8List> _convertToPngWithBackground(
      ui.Image image, Color bgColor) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = bgColor;

    canvas.drawRect(
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        paint);
    canvas.drawImage(image, Offset.zero, Paint());

    final newImage =
        await recorder.endRecording().toImage(image.width, image.height);
    final byteData = await newImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    minWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text(
          'Meniul Zilei',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.brown[900],
          ),
        ),
        backgroundColor: Colors.brown[100],
        elevation: 2,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: Colors.brown[800]),
            onPressed: _captureAndSaveMenu,
          ),
        ],
      ),
      body: FutureBuilder(
        future: locator.get<DailyMenuOverviewCubit>().fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
              ),
            );
          }
          final menuItems = locator.get<DailyMenuOverviewCubit>().state;
          if (menuItems.isEmpty) {
            return Center(
              child: Text("Nu exista meniuri,"),
            );
          }

          return ValueListenableBuilder<bool>(
            valueListenable: exportInProgress,
            builder: (context, isExport, child) {
              return Stack(
                children: [
                  Visibility(
                    visible: exportInProgress.value,
                    child: CrossScroll(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: exportWidth,
                          minHeight: MediaQuery.of(context)
                              .size
                              .height, // Ensures scrolling
                        ),
                        child: Center(
                          child: SizedBox(
                            width: exportWidth,
                            child: RepaintBoundary(
                              key: _exportKey,
                              child: Container(
                                width: exportWidth,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.brown[800]!, width: 3),
                                ),
                                margin: EdgeInsets.all(10),
                                child: _menuOverviewWidget(1600, menuItems),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  CrossScroll(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: minWidth,
                        minHeight: MediaQuery.of(context)
                            .size
                            .height, // Ensures scrolling
                      ),
                      child: Center(
                        child: SizedBox(
                          width: minWidth,
                          child: Container(
                            width: minWidth,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.brown[800]!, width: 3),
                            ),
                            margin: EdgeInsets.all(10),
                            child: _menuOverviewWidget(1600, menuItems),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isExport,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey.withValues(alpha: 0.9),
                      child: Center(
                        child: Text(
                          "Se descarca...",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _menuOverviewWidget(
      double screenHeight, Map<int, List<MenuItem>> menuItems) {
    final double availableHeight = screenHeight * 0.85;
    var date = DateTime.now();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Header
          Text(
            "La Neagtovo",
            style: _titleStyle.copyWith(fontSize: 40),
            textAlign: TextAlign.center,
          ),
          Text(
            "${date.day}/${date.month}/${date.year}",
            style: _menuCategoryStyle.copyWith(fontSize: 22),
          ),

          Divider(thickness: 2, color: Colors.brown[900]),
          SizedBox(height: 10),

          // Food Categories
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    buildBorderedCategory(
                        "Ciorbe / Supe", menuItems[2]!, availableHeight * 0.23,
                        icon: Icons.soup_kitchen),
                    buildBorderedCategory(
                        "Salate", menuItems[4]!, availableHeight * 0.55,
                        icon: Icons.rice_bowl),
                    buildBorderedCategory(
                        "Diverse", menuItems[6]!, availableHeight * 0.26,
                        icon: Icons.bakery_dining),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    buildBorderedCategory(
                      "Meniul Zilei",
                      menuItems[0]!,
                      availableHeight * 0.2,
                      isDailyMenu: true,
                    ),
                    buildBorderedCategory(
                      "Meniuri La Alegere",
                      menuItems[1]!,
                      availableHeight * 0.8,
                      icon: Icons.remove,
                      addLogo: true,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    buildBorderedCategory(
                        "Carne", menuItems[5]!, availableHeight * 0.5,
                        icon: Icons.kebab_dining),
                    buildBorderedCategory(
                        "Garnituri", menuItems[3]!, availableHeight * 0.5,
                        icon: Icons.remove),
                  ],
                ),
              ),
            ],
          ),
          Divider(thickness: 2, color: Colors.brown[900]),

          // Contact Information
          SizedBox(height: 15),
          Text(
            "Comenzile Se Preiau Până La 11:30",
            style: _menuCategoryStyle,
          ),
          Text(
            "📞 0735 232 211 | 0773 964 460",
            style: _itemStyle,
          ),
          Text(
            "📍 Str. Emil Racoviță Nr. 53, Craiova",
            style: _itemStyle,
          ),
        ],
      ),
    );
  }

  Widget buildBorderedCategory(
      String categoryName, List<MenuItem> items, double height,
      {bool isDailyMenu = false, IconData? icon, bool addLogo = false}) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 8, horizontal: 8), // Adjust spacing between sections
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.brown[800]!, width: 2), // Adds a nice border
        borderRadius:
            BorderRadius.circular(10), // Rounded corners for a premium look
        color: Colors.white, // Background color inside the border
        boxShadow: [
          BoxShadow(
            color: Colors.brown[300]!.withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(2, 3), // Slight shadow for a lifted look
          ),
        ],
      ),
      child: isDailyMenu
          ? buildDailyMenuCategoryCard(
              categoryName,
              items,
              height,
            )
          : buildCategoryCard(categoryName, items, height, icon!,
              addLogo: addLogo),
    );
  }

  Widget buildCategoryCard(
      String categoryName, List<MenuItem> items, double height, IconData icon,
      {bool addLogo = false}) {
    return SizedBox(
      height: height,
      child: Column(
        children: [
          Text(categoryName.toUpperCase(),
              style: _menuCategoryStyle, textAlign: TextAlign.center),
          Divider(color: Colors.brown[700]),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(
                color: Colors.brown.withValues(alpha: 0.7),
                thickness: 0.4,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final isInDailyMenu = locator
                    .get<DailyMenuOverviewCubit>()
                    .state[0]!
                    .any((item) => item.id! == items[index].id);
                return ListTile(
                  title: Text(
                    _capitalizeFirstLetter(items[index].name, isInDailyMenu,
                        items[index].hasBread, items[index].hasPolenta),
                    style: _itemStyle,
                  ),
                  trailing:
                      Text("${items[index].price} LEI", style: _priceStyle),
                );
              },
            ),
          ),
          Visibility(
            visible: addLogo,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/company_logo.png',
                width: double.infinity,
                fit: BoxFit.contain,
                height: 250,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDailyMenuCategoryCard(
      String categoryName, List<MenuItem> items, double height) {
    return SizedBox(
      height: height,
      child: Column(
        children: [
          Text("${categoryName.toUpperCase()} - 22 LEI",
              style: _menuCategoryStyle, textAlign: TextAlign.center),
          Divider(color: Colors.brown[700]),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(
                color: Colors.brown.withValues(alpha: 0.7),
                thickness: 0.4,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) => Text(
                  _capitalizeFirstLetter(
                    items[index].name,
                    false,
                    false,
                    false,
                  ),
                  textAlign: TextAlign.center,
                  style: _itemStyle),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalizeFirstLetter(
    String text,
    bool isInDailyMenu,
    bool hasBread,
    bool hasPolenta,
  ) {
    if (text.isEmpty) return text;
    if (isInDailyMenu) {
      if (hasBread) {
        return "${text[0].toUpperCase()}${text.substring(1)} si painica";
      }
      if (hasPolenta) {
        return "${text[0].toUpperCase()}${text.substring(1)} cu painica";
      }
    }
    return text[0].toUpperCase() + text.substring(1);
  }
}
