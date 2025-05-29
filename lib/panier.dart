// ignore_for_file: unused_element, prefer_final_fields, unused_field, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cart => _cartItems;


  CartProvider() {
    _loadCartFromStorage();
  }

  List<Map<String, dynamic>>  getItems()  {
    _loadCartFromStorage();
    return _cartItems;
  }

  
  // Ajouter un produit au panier
  void addItem(Map<String, dynamic> item) {
    _cartItems.add(item);
    _saveCartToStorage();
    notifyListeners();
  }

  // Calculer le prix total
  double calculateTotal() {
    return _cartItems.fold(0.0, (total, item) => total + (item['product_price'] * item['quantity']));
  }

  // Augmenter la quantité
  void increaseQuantity(int index) {
    _cartItems[index]['quantity']++;
    _saveCartToStorage();
    notifyListeners();
  }

  // Diminuer la quantité
  void decreaseQuantity(int index) {
    if (_cartItems[index]['quantity'] > 1) {
      _cartItems[index]['quantity']--;
      _saveCartToStorage();
      notifyListeners();
    }
  }

  // Supprimer un article
  void removeItem(int index) {
    _cartItems.removeAt(index);
    _saveCartToStorage();
    notifyListeners();
  }

  // Sauvegarder le panier dans SharedPreferences
  Future<void> _saveCartToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', jsonEncode(_cartItems)); 


  }

  // Charger le panier depuis SharedPreferences
  Future<void> _loadCartFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartData = prefs.getString('cart');
    if (cartData != null) {
      _cartItems = List<Map<String, dynamic>>.from(jsonDecode(cartData));
      notifyListeners();
    }
  }
}
