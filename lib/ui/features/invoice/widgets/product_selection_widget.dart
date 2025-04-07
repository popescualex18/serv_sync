import 'package:flutter/material.dart';

class ProductSelectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  const ProductSelectionWidget({super.key, required this.products,});

  @override
  State<ProductSelectionWidget> createState() => _ProductSelectionWidgetState();
}

class _ProductSelectionWidgetState extends State<ProductSelectionWidget> {
  Map<String, dynamic>? _selectedProduct;

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Alege un produs:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),

            DropdownButton<Map<String, dynamic>>(
              value: _selectedProduct,
              hint: Text('Selectează un produs'),
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  _selectedProduct = value;
                });
                if (value != null) {
                  _showQuantityDialog(context, value);
                }
              },
              items: widget.products.map((product) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: product,
                  child: Text('${product['name']} - \$${product['price']}'),
                );
              }).toList(),
            ),
          ],
        ),
      );
  }

  // Function to show a popup for quantity and mentions
  void _showQuantityDialog(BuildContext context, Map<String, dynamic> product) {
    TextEditingController quantityController = TextEditingController();
    TextEditingController mentionController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalii produs'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Quantity input with validation
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Cantitate'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduceți cantitatea';
                    }
                    int? quantity = int.tryParse(value);
                    if (quantity == null || quantity <= 0) {
                      return 'Cantitatea trebuie să fie un număr valid';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // Mentions input (optional)
                TextFormField(
                  controller: mentionController,
                  decoration: InputDecoration(labelText: 'Mențiuni (opțional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Anulează'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addToCart(product, int.parse(quantityController.text), mentionController.text);
                  Navigator.pop(context);
                }
              },
              child: Text('Adaugă în coș'),
            ),
          ],
        );
      },
    );
  }

  // Function to handle adding to cart
  void _addToCart(Map<String, dynamic> product, int quantity, String mention) {
    print("Produs adăugat: ${product['name']}, Cantitate: $quantity, Mențiuni: $mention");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['name']} a fost adăugat în coș!')),
    );
  }
}
