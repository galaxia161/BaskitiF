// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'panier.dart';
import 'package:share_plus/share_plus.dart';
 
class ProductDetailApp extends StatelessWidget {
  final int productId;

  ProductDetailApp({required this.productId});

  @override
  Widget build(BuildContext context) {
    return ProductDetailScreen(productId: productId);
  }
}

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  ProductDetailScreen({required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Map<String, dynamic>> productData;
  Map<String, dynamic>? productDataLoaded;


 String formatPrice(double price) {
  // Utilisation de NumberFormat pour formater le prix avec deux décimales et une virgule
  final formatter = NumberFormat("#,##0.00", "fr_FR");
   String formattedPrice = formatter.format(price);

  return formattedPrice;
}

  @override
  void initState() {
    super.initState();
    productData = fetchProductData(widget.productId);
  }

  Future<Map<String, dynamic>> fetchProductData(int productId) async {
    final url = Uri.parse('https://baskiti.ma/app/getproduit.php?productid=$productId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load product data');
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar( 
      centerTitle: true,
      actions: [
        IconButton(icon: Icon(Icons.favorite_border, color: Colors.black), onPressed: () {}),
        IconButton(icon: Icon(Icons.share, color: Colors.black),
        onPressed: () {
           print('productDataLoaded: $productDataLoaded'); // Vérifier la valeur

            if (productDataLoaded != null) {
               final String productName = productDataLoaded!['product_name'] ?? 'Produit';
              final String productUrl = '${productDataLoaded!['slug']}-detail';

              Share.share(
                'Découvrez ce produit : $productName\n$productUrl',
                subject: 'Produit à découvrir !',
              );
            }  
        }
      
         ),
      ],
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pop(); // Permet de revenir à l'écran précédent
        },
      ),
    ),
    body: Padding (
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FutureBuilder<Map<String, dynamic>>(
        future: productData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            productDataLoaded = snapshot.data!;
            final productImages = List<String>.from(data['file_urls'] ?? []);
            final productName = data['product_name'] ?? 'No name';
            final productPrice = double.parse(data['product_price']);
            final productDescription = data['product_s_desc'] ?? '';
            final productDescriptionL = data['product_desc'] ?? '';
            final productstock = data['stock'];
            data['quantity'] = 1;
            data['product_price'] = double.parse(data['product_price']);

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Carrousel pour les images
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 250.0,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                          ),
                          items: productImages.map((imageUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {
                                    // Ouvre l'image en plein écran
                                    showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop(); // Ferme le dialogue en cliquant sur l'image
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.network(
                                              'https://baskiti.ma/$imageUrl',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      'https://baskiti.ma/$imageUrl',
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),

                        SizedBox(height: 16),
                        Text(
                          productName,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "MAD ${formatPrice(productPrice)}",
                          style: TextStyle(fontSize: 20, color: Color(0xFFE85E24), fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                       
                        DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              TabBar(
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.grey,
                                tabs: [
                                  Tab(text: 'Informations'),
                                  Tab(text: 'Plus de détails'),
                                ],
                              ),
                              Container(
                                height: 250,
                                child: TabBarView(
                                  children: [
                                    SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(productDescription, style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: Text(productDescriptionL, style: TextStyle(fontSize: 16)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.white,
                  child: ElevatedButton(
                    onPressed: productstock > 0
                        ? () {
                            Provider.of<CartProvider>(context, listen: false).addItem(data);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$productName ajouté au panier')),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        productstock > 0 ? 'Ajouter au panier' : 'Épuisé',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No product data found.'));
          }
        },
      ),
    ),
  );
}
}