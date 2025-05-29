// ignore_for_file: use_super_parameters, prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables

import 'package:baskiti/CustomFooter.dart';
import 'package:baskiti/HomePage.dart';
import 'package:baskiti/NavBar.dart';
import 'package:baskiti/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:baskiti/user.dart';
import 'package:provider/provider.dart';

 
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      return Scaffold(
      drawer: NavBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
     child: Padding(
        padding: const EdgeInsets.all(25.0),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.red.shade100,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Text(
                      'Bienvenue, ${userProvider.name} !',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      userProvider.email,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Options
            ProfileOption(
              icon: Icons.edit,
              title: 'Modifier le profil',
              onTap: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
              },
            ),
            ProfileOption(
              icon: Icons.shopping_cart,
              title: 'Voir mes achats',
              onTap: () {
                print("Navigating to Orders...");
              },
            ),
            ProfileOption(
              icon: Icons.star,
              title: 'Consulter le système de points de fidélité',
              onTap: () {
                
              },
            ),
            ProfileOption(
              icon: Icons.logout_rounded,
              title: 'Déconnecter',
              onTap: () {
                Provider.of<UserProvider>(context, listen: false).clearUserData();
                 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
              },
            ),
             const SizedBox(height: 20),
            Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Nous sommes ravis de vous voir 😊.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Vous avez accumulé ${userProvider.points} points de fidélité !",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Continuez à profiter de nos services pour gagner encore plus !",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    )
          ],
        ),
      )),
   bottomNavigationBar: CustomFooter(),

    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileOption({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
              color: Colors.red.shade900,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        
      ),
    );
  }
}
