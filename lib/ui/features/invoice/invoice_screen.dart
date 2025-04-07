import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:serv_sync/ui/features/invoice/widgets/product_selection_widget.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final List<Map<String, dynamic>> _products = [
    {'name': 'Burger', 'price': 5.0},
    {'name': 'Pizza', 'price': 8.0},
    {'name': 'Pasta', 'price': 7.0},
    {'name': 'Coke', 'price': 2.0},
  ];

  final List<Map<String, dynamic>> _cart = [];

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      _cart.add(product);
    });
  }

  double get _totalPrice => _cart.fold(0, (sum, item) => sum + item['price']);

  Future<void> _printInvoice() async {
    final fontData = await rootBundle
        .load("assets/fonts/Roboto-Italic-VariableFont_wdth,wght.ttf");
    final ttf = pw.Font.ttf(fontData);
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Restaurant Invoice',
                  style: pw.TextStyle(fontSize: 24, font: ttf)),
              pw.SizedBox(height: 10),
              pw.Text(
                'Customer: ${_customerController.text}',
                style: pw.TextStyle(font: ttf),
              ),
              pw.Text(
                'Address: ${_addressController.text}',
                style: pw.TextStyle(
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(font: ttf),
                cellStyle: pw.TextStyle(font: ttf),
                context: context,
                headers: ['Item', 'Price'],
                data: _cart
                    .map((item) => [item['name'], '${item['price']}'])
                    .toList(),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Total: $_totalPrice',
                  style: pw.TextStyle(fontSize: 18, font: ttf)),
            ],
          );
        },
      ),
    );
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output!.path}/invoice.pdf");
    await file.writeAsBytes(await pdf.save());
    print("Saved to ${file.path}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restaurant Invoice')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
                controller: _customerController,
                decoration: InputDecoration(labelText: 'Customer Name')),
            TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Delivery Address')),
            SizedBox(height: 20),
            Expanded(child: ProductSelectionWidget(products: _products)),
            Divider(),
            Text('Cart',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: _cart
                    .map((product) => ListTile(
                        title:
                            Text('${product['name']} - \$${product['price']}')))
                    .toList(),
              ),
            ),
            SizedBox(height: 10),
            Text('Total: \$$_totalPrice',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async => _printInvoice(),
                child: Text('Print Invoice')),
          ],
        ),
      ),
    );
  }
}
