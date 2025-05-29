// ignore_for_file: unused_element, prefer_final_fields, unused_field, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];
  double _total = 0.0;
  int _livraison = 0;
  String _modeLivraison = "domicile"; // Valeur par défaut
  String _modePaiement = "livraison"; // Valeur par défaut

  List<Map<String, dynamic>> get cartItems => _cartItems;
  double get total => _total;
  int get livraison => _livraison;
  String get modeLivraison => _modeLivraison;
  String get modePaiement => _modePaiement;

  OrderProvider() {
    _loadOrderFromStorage();
  }

  // Mettre à jour les informations de l'utilisateur
  void setOrderData({required List<Map<String, dynamic>> cartItems, required double total, required int livraison,required String modeLivraison,required String modePaiement}) {
    _cartItems = cartItems;
    _total = total;
    _livraison = livraison;
    _modeLivraison = modeLivraison;
    _modePaiement=modePaiement;
     
    _saveOrderToStorage(); // Sauvegarde des données mises à jour
    notifyListeners();
  }


  /// 🔄 **Sauvegarder les données dans SharedPreferences**
  Future<void> _saveOrderToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cartItems', jsonEncode(_cartItems));
    prefs.setDouble('total', _total);
    prefs.setInt('livraison', _livraison);
    prefs.setString('modeLivraison', _modeLivraison);
    prefs.setString('modePaiement', _modePaiement);
  }

  /// 🔄 **Charger les données depuis SharedPreferences**
  Future<void> _loadOrderFromStorage() async {
    final prefs = await SharedPreferences.getInstance();

    _cartItems = (prefs.getString('cartItems') != null)
        ? List<Map<String, dynamic>>.from(jsonDecode(prefs.getString('cartItems')!))
        : [];

    _total = prefs.getDouble('total') ?? 0.0;
    _livraison = prefs.getInt('livraison') ?? 0;
    _modeLivraison = prefs.getString('modeLivraison') ?? "domicile";
    _modePaiement = prefs.getString('modePaiement') ?? "livraison";

    notifyListeners();
  }
}
