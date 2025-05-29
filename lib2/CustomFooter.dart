// ignore_for_file: file_names, prefer_const_constructors, sized_box_for_whitespace, use_key_in_widget_constructors, unrelated_type_equality_checks, unnecessary_null_comparison

import 'package:baskiti/Categories.dart';
import 'package:baskiti/Store.dart';
import 'package:baskiti/cart.dart';
import 'package:baskiti/homepage.dart';
import 'package:flutter/material.dart';
 
class CustomFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return SizedBox(
      height: 60, // Augmenter la hauteur pour accueillir le contenu
       child: Scaffold(
  bottomNavigationBar: BottomAppBar(
    color: Color(0xFFE85E24),
    shape: CircularNotchedRectangle(), // Ajoute une découpe pour le FAB
    notchMargin:5.0, // Marge entre le bouton et la découpe
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
        IconButton(
                icon: Icon(Icons.grid_view, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Categories()),
                  );
                },
            ),
        IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                },
              ),// Espace pour le bouton flottant
         IconButton(
                icon: Icon(Icons.store, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Store()),
                  );
                },
              ),
            
            
          
      ],
    ),
  ),
 )
    );
    
  }
}
