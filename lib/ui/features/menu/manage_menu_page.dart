import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serv_sync/core/constants/constants.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/ui/features/menu/widgets/custom_checkbox.dart';
import 'package:serv_sync/ui/shared/widgets/buttons/action_button.dart';
import 'package:serv_sync/ui/shared/widgets/loading_spinner/loading_spinner.dart';
import 'package:serv_sync/ui/state_management/cubits/app_cubit.dart';
import 'package:serv_sync/ui/state_management/cubits/menu/manage_menu_cubit.dart';

class ManageMenuPage extends StatefulWidget {
  final String? menuId;
  final MenuItem? menuItem;
  const ManageMenuPage({
    super.key,
    this.menuId,
    this.menuItem,
  });

  @override
  State<ManageMenuPage> createState() => _ManageMenuPageState();
}

class _ManageMenuPageState extends State<ManageMenuPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  late final ManageMenuCubit _cubit;
  @override
  void initState() {
    _cubit = context.read<ManageMenuCubit>();
    _cubit.loadMenu(widget.menuId, widget.menuItem);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = context.select<AppCubit, bool>(
      (cubit) => cubit.state.isLoading,
    );
    var hasError = context.select<AppCubit, bool>(
      (cubit) => cubit.state.error != null,
    );

    if (isLoading || hasError) {
      return LoadingSpinner();
    }

    var menu = context.select<ManageMenuCubit, MenuItem>(
      (cubit) => cubit.state!,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Menu", style: TextStyle(fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                        label: "Menu Name",
                        hintText: "Enter menu name",
                        initialValue: menu.name,
                        validator: _validateName,
                        onSave: (String? value) => _cubit.setName(value!)),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Price",
                      hintText: "Enter price",
                      initialValue:
                          menu.price > 0 ? menu.price.toString() : null,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      onSave: (String? value) => _cubit.setPrice(
                        double.parse(
                          value!,
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(
                            r'^\d*\.?\d*$',
                          ),
                        ), // Allows only numbers & decimals
                      ],
                      validator: _validatePrice,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Extras",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomCheckbox(
                          label: "Paine",
                          enabled: menu.hasBread,
                          onChanged: (bool? value) =>
                              _cubit.setHasBread(value ?? false),
                        ),
                        const SizedBox(width: 20),
                        CustomCheckbox(
                          label: "Mamaliga",
                          enabled: menu.hasPolenta,
                          onChanged: (bool? value) =>
                              _cubit.setHasPolenta(value ?? false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Categorii",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    _buildCategorySelection(menu),
                    const SizedBox(height: 12),
                    Visibility(
                      visible: !_cubit.hasCategorySelected,
                      child: Text(
                        "Selecteaza cel putin o categorie.",
                        style: TextStyle(fontSize: 14, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ActionButton(
              icon: Icons.save,
              label: "Save",
              onPressed: () {
                if (_globalKey.currentState!.validate() ||
                    _cubit.hasCategorySelected) {
                  _globalKey.currentState!.save();
                  _cubit.save().then(
                    (_) {
                      if (widget.menuId != null || widget.menuItem != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          snackBarAnimationStyle: AnimationStyle(
                            duration: Duration(
                              milliseconds: 30,
                            ),
                            reverseDuration: Duration(
                              milliseconds: 30,
                            ),
                          ),
                          SnackBar(
                            content: Text("Meniul a fost salvat cu success"),
                          ),
                        );
                        context.pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          snackBarAnimationStyle: AnimationStyle(
                            duration: Duration(
                              milliseconds: 30,
                            ),
                            reverseDuration: Duration(
                              milliseconds: 30,
                            ),
                          ),
                          SnackBar(
                            content: Text("Meniul a fost adaugat cu success"),
                          ),
                        );
                        _cubit.resetMenu();
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelection(MenuItem menu) {
    return Row(
        spacing: 40,
        children: Constants.categories.keys.map((category) {
          var isSelected = menu.categories.contains(category);
          var categoryName = Constants.categories[category];
          return CustomCheckbox(
            label: categoryName!,
            enabled: isSelected,
            onChanged: (bool? value) =>
                _cubit.setCategories(category, value ?? false),
          );
        }).toList());
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String?)? onSave,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: TextFormField(
          onSaved: onSave,
          initialValue: initialValue,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            border: InputBorder.none,
          ),
          validator: validator,
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '*Required Field';
    } else if (value.length < 3) {
      return 'Name is too short';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return '*Required Field';
    } else if (double.parse(value) <= 0) {
      return 'Pret invalid';
    }
    return null;
  }
}
