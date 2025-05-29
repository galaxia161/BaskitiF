// ignore_for_file: unused_element, prefer_final_fields, avoid_print, must_be_immutable, use_key_in_widget_constructors, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTempProvider extends ChangeNotifier {
 

  String _last_name ='';
  String _first_name='';
  String _phone_1='';
  String _address_1='';
  String? _city='';

 
  String get last_name => _last_name;
  String get first_name => _first_name;
  String get phone_1 => _phone_1;
  String get address_1 => _address_1;
  String? get city => _city;


 

  UserTempProvider() {
    _loadUserStorage();
  }

  // Mettre à jour les informations de l'utilisateur
  void setUserData({required String last_name ,required String first_name,required String phone_1,required String address_1,required String? city}) {
 
    _last_name= last_name;
    _first_name = first_name;
    _phone_1=phone_1;
    _address_1=address_1;
    _city=city;
    _saveUserToStorage(); // Sauvegarde des données mises à jour
    notifyListeners();
  }

  void clearUserData() {
 
    _last_name= '';
    _first_name = '';
    _phone_1='';
    _address_1='';
    _city='';
    notifyListeners();
  }

  // Sauvegarder l'utilisateur dans SharedPreferences
  Future<void> _saveUserToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = { 
        'last_name': _last_name,
        'first_name' : _first_name,
        'phone_1':_phone_1,
        'address_1':_address_1,
        'city':_city,
          };
      prefs.setString('user_data', jsonEncode(userData));
    } catch (e) {
      print("Erreur lors de la sauvegarde des données utilisateur : $e");
    }
  }

  // Charger l'utilisateur depuis SharedPreferences
  Future<void> _loadUserStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');

      if (userDataString != null) {
        final userData = json.decode(userDataString);
        if (userData is Map<String, dynamic>) { 
          _last_name= userData['last_name'] ?? '';
          _first_name = userData['first_name'] ?? '';
          _phone_1=userData['phone_1'] ?? '';
          _address_1=userData['address_1'] ?? '';
          _city=userData['city'] ?? '';
        }
      } else {
        print("Aucune donnée utilisateur trouvée dans les préférences.");
      }
      notifyListeners();
    } catch (e) {
      print("Erreur lors du chargement des données utilisateur : $e");
    }
  }
}
