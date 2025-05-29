// ignore_for_file: prefer_const_constructors, avoid_print, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables, sort_child_properties_last

import 'dart:convert'; // Pour décoder les réponses JSON
import 'package:baskiti/CustomFooter.dart';
import 'package:baskiti/NavBar.dart';
import 'package:baskiti/manufacturer.dart';
import 'package:baskiti/produit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Pour effectuer des requêtes HTTP

class Search extends StatefulWidget {
  final String? scannedCode; // Code optionnel

  Search({this.scannedCode}); //
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _productResults = [];
  List<dynamic> _brandResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.scannedCode != null) {
      _searchController.text = widget.scannedCode!;
      _performSearch(_searchController.text);
    }
  }

String formatPrice(double price) {
  // Utilisation de NumberFormat pour formater le prix avec deux décimales et une virgule
  final formatter = NumberFormat("#,##0.00", "fr_FR");
   String formattedPrice = formatter.format(price);

  return formattedPrice;
}

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _productResults = [];
        _brandResults = [];
      });
      return;
    }
    
    final productUrl = Uri.parse("https://www.baskiti.ma/app/searchproducts.php?key=$query");
    final brandUrl = Uri.parse("https://www.baskiti.ma/app/searchmarques.php?key=$query");

    try {
      // Fetch products
      final productResponse = await http.get(productUrl);
      final brandResponse = await http.get(brandUrl);

      if (productResponse.statusCode == 200 && brandResponse.statusCode == 200) {
        setState(() {
          _productResults = jsonDecode(productResponse.body);
          _brandResults = jsonDecode(brandResponse.body);
        });
      } else {
        setState(() {
           isLoading = false;
          _productResults = [];
          _brandResults = [];
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        _productResults = [];
        _brandResults = [];
      });
      print("Erreur lors de la recherche : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
     Future<Map<String, dynamic>> fetchProductData(String codbar) async {
    final url = Uri.parse('https://baskiti.ma/app/getproductbycode.php?key=$codbar');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load product data');
    }
  }

  void getProductDetails(String barcode) async {
  try {
    Map<String, dynamic> produit = await fetchProductData(barcode);
    
    // Accès aux éléments du produit
    int productId = produit['id'];  
    if (productId != 0 ) { 
    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailApp(productId: productId),
          ),
        );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucun produit correspond à ce code barre')),
        );
    }
   } catch (e) {
    print('Erreur: $e');
  }
}

  
    return Scaffold(
      drawer: NavBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Barre de recherche
              SizedBox(
                height: 40, // Hauteur totale du TextField
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                         if (value.length > 4) {
                            _performSearch(value); // Appel de recherche seulement si la longueur > 4
                          } else {
                            setState(() {
                              _productResults = [];
                              _brandResults = [];
                            });
                          }
                        },
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Rechercher un produit, une marque',
                          hintStyle: TextStyle(
                            fontSize: 14, // Taille de police pour le texte indicatif (placeholder)
                          ),
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15), // Ajuster le padding vertical
                        ),
                      ),
                    ),
                    SizedBox(width: 8), // Espacement entre le champ de recherche et le bouton
                    
                  ],
                ),
              ),
              SizedBox(height: 15),

              // Résultats Marques
              if (_brandResults.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Marques",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ..._brandResults.map((brand) => ListTile(
                          title: Text(brand['name'] ?? 'Nom indisponible'),
                           onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Manufacturer(manufacturer: brand['id'],manufacturername: brand['name'])),
                            );
                          },
                        )),
                  ],
                ),

                SizedBox(height: 20),


                 // Résultats Produits
              if (_productResults.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Produits",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ..._productResults.map((product) => ListTile(
                         leading: Image.network(
                            product['image'], // Remplacez 'imageUrl' par la clé contenant l'URL de l'image
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover, // Ajuste l'image à la taille spécifiée
                          ),
                          title: Text(product['title']),
                          subtitle: Text("MAD ${formatPrice(double.parse(product['price']))}"),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProductDetailApp(productId: product['id'])),
                            );
                          },
                        )),
                  ],
                ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: CustomFooter(),
    );
  }
}
