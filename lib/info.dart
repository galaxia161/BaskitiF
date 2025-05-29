// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api, avoid_print, unused_element, must_be_immutable, unused_field

import 'package:baskiti/CustomFooter.dart';
import 'package:flutter/material.dart';


class ContactPage extends StatelessWidget {
  
 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact & Infos")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Infos
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("À propos de nous", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("Plongez dans notre parfumerie et laissez-vous envoûter par une sélection enchanteresse de fragrances raffinées. Découvrez des créations olfactives uniques, conçues pour éveiller vos sens et exprimer votre style personnel."),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.red),
                        SizedBox(width: 10),
                        Text("+212 6 55 68 74 08"),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.red),
                        SizedBox(width: 10),
                        Text("parfumeriesuenos@gmail.com"),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red),
                        SizedBox(width: 10),
                        Text("Av des FARs Tetouan, Maroc"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            
            ],
        ),
      ),
            bottomNavigationBar: CustomFooter(),

    );
    
  }
}
 

 
