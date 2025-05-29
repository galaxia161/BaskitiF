// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors, avoid_print

import 'package:baskiti/confirmlivraison.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'panier.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Calculer le prix total
  double calculateTotal(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return cartProvider.calculateTotal();
  }

  // Augmenter la quantité
  void increaseQuantity(BuildContext context, int index) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.increaseQuantity(index);
  }

  // Diminuer la quantité
  void decreaseQuantity(BuildContext context, int index) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.decreaseQuantity(index);
  }

  // Supprimer un article
  void removeItem(BuildContext context, int index) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.removeItem(index);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Panier'),
      ),
      body: cartProvider.cart.isEmpty
          ? Center(
              child: Text(
                'Votre panier est vide',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cart.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.cart[index];
                      final image=item['file_urls'][0];
                       return Card(
                        margin: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            // Image du produit
                            Container(
                              width: 80,
                              height: 80,
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage( 'https://suenos.ma/$image'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            // Informations sur le produit
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['product_name'],
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Prix : ${item['product_price'].toStringAsFixed(2)} MAD'),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        // Diminuer la quantité
                                        IconButton(
                                          onPressed: () => decreaseQuantity(context, index),
                                          icon: Icon(Icons.remove_circle_outline),
                                        ),
                                        Text(
                                          item['quantity'].toString(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        // Augmenter la quantité
                                        IconButton(
                                          onPressed: () => increaseQuantity(context, index),
                                          icon: Icon(Icons.add_circle_outline),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Bouton pour supprimer l'article
                            IconButton(
                              onPressed: () => removeItem(context, index),
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Section pour le total et le bouton de validation
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Total : ${calculateTotal(context).toStringAsFixed(2)} MAD',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Logique pour passer à la validation
                           Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmLivraisonPage(), // Passez l'ID du produit
                        ),
                      );
                        },
                        child: Text('Valider le panier'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
