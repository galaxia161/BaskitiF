// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors, avoid_print

import 'package:baskiti/order.dart';
import 'package:baskiti/user.dart';
import 'package:baskiti/usertemp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
class RecapPage extends StatefulWidget {
  @override
  _RecapPageState createState() => _RecapPageState();
}

class _RecapPageState extends State<RecapPage> {
  // Calculer le prix total
  

  

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userTempProvider = Provider.of<UserTempProvider>(context, listen: false); 
    return Scaffold(
      appBar: AppBar(
        title: Text('Ma commande'),
      ),
      body: orderProvider.cartItems.isEmpty
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
                    itemCount: orderProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = orderProvider.cartItems[index];
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
                                  image: NetworkImage( 'https://baskiti.ma/$image'),
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
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                 ),
                 SizedBox(height: 15,),
                 if (orderProvider.modeLivraison == 'domicile') 
                ( userProvider.iduser!=0 ) 
                ?Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Icon(Icons.person, color: Colors.red.shade900),
                              title: Text(userProvider.first_name, style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Divider(),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on, color: Colors.grey[700]),
                                    SizedBox(width: 10),
                                    Expanded(child: Text(userProvider.address_1)),
                                  ],
                                ),
                              ),
                             Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(Icons.phone, color: Colors.grey[700]),
                                    SizedBox(width: 10),
                                    Expanded(child: Text(userProvider.phone_1)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  :Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Icon(Icons.person, color: Colors.red.shade900),
                              title: Text(userTempProvider.first_name, style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Divider(),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on, color: Colors.grey[700]),
                                    SizedBox(width: 10),
                                    Expanded(child: Text(userTempProvider.address_1)),
                                  ],
                                ),
                              ),
                             Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(Icons.phone, color: Colors.grey[700]),
                                    SizedBox(width: 10),
                                    Expanded(child: Text(userTempProvider.phone_1)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                    else 
                     SizedBox(),
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
                        'Total : ${orderProvider.total.toStringAsFixed(2)} MAD',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Livraison : ${orderProvider.livraison.toStringAsFixed(2)} MAD',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                         
                        },
                        child: Text('Valider la commande'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
