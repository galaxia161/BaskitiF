// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:baskiti/cart.dart';
import 'package:baskiti/panier.dart';
import 'package:baskiti/produit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class CategoryPage extends StatefulWidget {
  final int? category; // Paramètre optionnel pour la catégorie
  final String? categoryname;

  CategoryPage({this.category,this.categoryname}); // Constructeur avec paramètre

  @override
  _ManufacturerState createState() => _ManufacturerState();
}

class _ManufacturerState extends State<CategoryPage> {
  List<dynamic> products = []; // Liste pour stocker les produits récupérés
  bool isLoading = true; // Indicateur de chargement
  bool hasError = false; // Indicateur d'erreur

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  String formatPrice(double price) {
  // Utilisation de NumberFormat pour formater le prix avec deux décimales et une virgule
  final formatter = NumberFormat("#,##0.00", "fr_FR");
   String formattedPrice = formatter.format(price);

  return formattedPrice;
}

  Future<void> fetchProducts() async {
    try {
      // Ajout du paramètre dans l'URL
      final url = widget.category != null
          ? 'https://baskiti.ma/app/productsbycategory.php?category=${widget.category}'
          : 'https://baskiti.ma/app/productsbycategory.php';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          products = data; // Charger les produits
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true; // Erreur de l'API
          isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur : $e');
      setState(() {
        hasError = true; // Erreur réseau ou autre
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
         final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "La catégorie ${widget.categoryname}",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart_outlined),
                Positioned(
                  right: 0,
                  child: cartProvider.cart.isEmpty
                  ? CircleAvatar(
                    radius: 8,
                    backgroundColor: Color(0xFFE85E24),
                    child: Text(
                      '0',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                   )
                  :
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: Color(0xFFE85E24),
                    child: Text(
                      cartProvider.cart.length.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                   ),
                ),
              ],
            ),
            onPressed: () {
               Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Indicateur de chargement
          : hasError
              ? Center(child: Text("Erreur lors du chargement des produits")) // Erreur
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 colonnes
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: products.length,
                 itemBuilder: (context, index) {
                  final product = products[index];
                  final Map<String, dynamic>  data={};
                  final productName=product['title'];
                  data['file_urls']=  [];
                  data['file_urls'].add(product['image']?.replaceAll('https://baskiti.ma/', ''));
                  data['quantity']=1; 
                  data['product_price']=double.parse(product['price']);  
                  data['product_name']=product['title'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailApp(productId: product['id']), // Passez l'ID du produit
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                  child: Image.network(
                                    product['image'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['title'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "MAD ${formatPrice(double.parse(product['price']))}",
                                          style: TextStyle(
                                            color: Color(0xFFE85E24),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        product['stock'] > 0
                        ?
                        Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                              onTap: () {
                                Provider.of<CartProvider>(context, listen: false)
                                  .addItem(data);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$productName ajouté au panier')),
                              );
                              },
                              borderRadius: BorderRadius.circular(50), // Bordure arrondie pour correspondre au cercle
                              child: CircleAvatar(
                                backgroundColor: Color(0xFFE85E24),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        )
                      : Positioned(
                          top: 4,
                          right: 2,
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey, // Fond grisé
                                borderRadius: BorderRadius.circular(12), // Coins arrondis
                              ),
                              child: Text(
                                'Épuisé',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        )
                      ],
                    ),
                  );
                },

                  ),
                ),
    );
  }
}
 