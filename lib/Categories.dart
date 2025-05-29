// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_super_parameters, collection_methods_unrelated_type, unnecessary_to_list_in_spreads, prefer_const_declarations

import 'package:baskiti/CategoryPage.dart';
import 'package:baskiti/CustomFooter.dart';
import 'package:baskiti/manufacturer.dart';
import 'package:baskiti/search.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const Categories());
}

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Toutes les catégories', 
      home: const TabsPage(),
    );
  }
}

class TabsPage extends StatelessWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Toutes les catégories & marques',
            style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Catégories'),
              Tab(text: 'Marques'),
            ],
          ),
        ),
        body: 
        const TabBarView(
          children: [
            CategoriesPage(),
            MarquesPage(),
          ],
        ),
         bottomNavigationBar: CustomFooter(),
      ),
    );
  }
}

class MarquesPage extends StatefulWidget {
  const MarquesPage({Key? key}) : super(key: key);

  @override
  _MarquesPageState createState() => _MarquesPageState();
}

class _MarquesPageState extends State<MarquesPage> {
   List<Map<String, dynamic>> manufacturers = [];
  Map<String, List<Map<String, dynamic>>> groupedManufacturers = {};
  bool isLoading = true;

   final List<Map<int, String>> topMarques = [
    {3:'Dolce Gusto'},
    {8:'Dubois'},
    {4 : 'Huggies'},
    {2:'	Nestlé'},
    {6:'	Lipton'},
  ];
  @override
  void initState() {
    super.initState();
    fetchManufacturers();
  }
  // Fonction pour récupérer les fabricants depuis l'API
  Future<void> fetchManufacturers() async {
    final response = await http.get(Uri.parse('https://baskiti.ma/app/marques.php'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      // Trier les fabricants par ordre alphabétique
      manufacturers = List<Map<String, dynamic>>.from(data);
      manufacturers.sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));

      // Grouper les fabricants par la première lettre
      groupedManufacturers = {};
      for (var manufacturer in manufacturers) {
        String firstLetter = manufacturer['name'][0].toUpperCase();
        if (!groupedManufacturers.containsKey(firstLetter)) {
          groupedManufacturers[firstLetter] = [];
        }
        groupedManufacturers[firstLetter]!.add(manufacturer);
      }

      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Erreur lors du chargement des marques');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Top Marques',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE85E24)),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: () {
                      // Liste temporaire pour stocker les widgets
                      List<Widget> children = [];
                      // Parcourir chaque élément de topMarques
                      for (final marque in topMarques) {
                        children.add(
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Manufacturer(
                                    manufacturer: marque.keys.first,
                                    manufacturername: marque.values.first, // Accès à la valeur
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Chip(
                                label: Text(marque.values.first)  , // Affichage du nom
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                          ),
                        );
                      }
                      return children; // Retourne la liste des widgets
                    }(),
                  ),

                ),
                Divider(color: Colors.black, thickness: 1),
                ...groupedManufacturers.keys.map((letter) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête pour chaque lettre
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE85E24),
                      ),
                    ),
                  ),
                  // Liste des fabricants pour chaque lettre avec séparateurs
                  ...List.generate(groupedManufacturers[letter]!.length, (index) {
                    final manufacturer = groupedManufacturers[letter]![index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text(manufacturer['name'],
                          style: TextStyle(
                            fontSize: 12,
                          )
                          ),
                          onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Manufacturer(
                                manufacturer: manufacturer['id'],  manufacturername: manufacturer['name']// Passez l'ID du fabricant
                              ),
                            ),
                          );
                        },
                        ),
                        // Ajout du Divider sauf après le dernier élément
                        if (index != groupedManufacturers[letter]!.length - 1)
                          Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                      ],
                    );
                  }),
                ],
              );
            }).toList(),
         
         ]          ),
  );
}
}

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final TextEditingController _searchController = TextEditingController();
  
  final List<Map<String, String>> categories = const [
    {'title': 'Alimentation', 'image': 'assets/images/cp.jpg'},
    {'title': 'Bébé', 'image': 'assets/images/parfum.jpg'},
    {'title': 'Entretien et maison', 'image': 'assets/images/soinvisage.jpg'},
    {'title': 'Hygiène et Beauté', 'image': 'assets/images/bain.jpg'}, 
    {'title': 'Divers', 'image': 'assets/images/bain.jpg'}, 
  ];

  List<Map<String, String>> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    filteredCategories = categories; // Initialiser avec toutes les catégories
    _searchController.addListener(() {
      filterCategories();
    });
  }

  void filterCategories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCategories = categories.where((category) {
        return category['title']!.toLowerCase().contains(query);
      }).toList();
    });
  } 

  final List<Map<int, String>> topCategories = [
    {22:'Conserves de poissons'},
    {8:'Espace bébé'},
    {4 :'Soins de corps'},
    {3:'Lave ligne'}, 
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 30, // Hauteur du TextField
                  child: TextField(
                        onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Search()),
                            );
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
              ),
              IconButton(
                icon: Icon(Icons.qr_code_scanner),
                onPressed: () async {
                  // Action pour scanner le code-barres (vous pouvez intégrer cela comme précédemment)
                },
              ),
            ],
          ),
        ),
      Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft, // Aligner à gauche
              child: Text(
                'Top Catégories',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE85E24)),
              ),
            ),
          ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: () {
                      // Liste temporaire pour stocker les widgets
                      List<Widget> children = [];
                      // Parcourir chaque élément de topMarques
                      for (final category in topCategories) {
                        children.add(
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryPage(
                                    category: category.keys.first,
                                    categoryname: category.values.first, // Accès à la valeur
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Chip(
                                label: Text(category.values.first)  , // Affichage du nom
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                          ),
                        );
                      }
                      return children; // Retourne la liste des widgets
                    }(),
                  ),

                ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: filteredCategories.length,
            itemBuilder: (context, index) {
              final category = filteredCategories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryDetailPage(
                        title: category['title']!,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    
                    title: Text(category['title']!),
                      
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CategoryDetailPage extends StatefulWidget {
  final String title;

  const CategoryDetailPage({Key? key, required this.title}) : super(key: key);

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> subCategories;
    if (widget.title == 'Alimentation') {
      subCategories = {
        'Alimentation': [
          {'id': 1, 'name': 'Tous les produits'},
          {'id': 3, 'name': 'Farine, semoule, couscous'},
          {'id': 4, 'name': 'Riz, blé et pâtes'},
          {'id': 2, 'name': 'Concentré de tomates'},
          {'id': 22, 'name': 'Sauces'},
          {'id': 22, 'name': 'Conserves de poissons'},
          {'id': 22, 'name': 'Aide culinaire'},
          {'id': 22, 'name': 'Thé et cafés'}, 
          {'id': 22, 'name': 'Miel et confitures'},
          {'id': 22, 'name': 'Biscuiterie et confiserie'},
          {'id': 22, 'name': 'Chips'}, ]
      };
    } else if (widget.title == 'Bébé') {
      subCategories = {
        'Bebe': [
          {'id': 1, 'name': 'Tous les produits'}, ]
      };
    }  else if (widget.title == 'Entretien et maison') {
      subCategories = {
        'Entretien et maison': [
          {'id': 1, 'name': 'Tous les produits'},
          {'id': 1, 'name': 'Lave ligne'},
          {'id': 1, 'name': 'Lave vaisselle'},
          {'id': 1, 'name': 'Eau de Javel'},
          {'id': 1, 'name': 'Nettoyant ménagers'},
          {'id': 1, 'name': 'Savon de toilette'},
          {'id': 1, 'name': 'Papier'}, ]
      };
    } else if (widget.title == 'Hygiène et Beauté') {
      subCategories = {
        'Hygiène et Beauté': [
          {'id': 1, 'name': 'Tous les produits'},
          {'id': 1, 'name': 'Soins du corps'},
          {'id': 1, 'name': 'Soins et colorqtion de cheveux'},]
      };
    } else if (widget.title == 'Divers') {
      subCategories = {
        'Divers': [
          {'id': 1, 'name': 'Piles électriques'},
          {'id': 1, 'name': 'Briquet'}, ]
      };
    } 
     else {
      // Valeurs par défaut ou autre catégorie
      subCategories = {};
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40, // Hauteur du TextField
                    child: TextField(
                        onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Search()),
                            );
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
                ),
                IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: () async {
                    // Lancer le scanner de code-barres
                    var result = await BarcodeScanner.scan();
                    if (result.rawContent.isNotEmpty) {
                      // Si un code-barres a été scanné, le mettre dans le champ de recherche
                      _searchController.text = result.rawContent;
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
      child: ListView(
          children: subCategories.entries.map((entry) {
            if (entry.value.isNotEmpty) {
              // Si la liste des sous-catégories n'est pas vide
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: entry.value.map((subSubCategory) {
                  return ListTile(
                    title: Text(
                      subSubCategory['name'],
                      style: const TextStyle(fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryPage(
                            category: subSubCategory['id'],
                            categoryname: subSubCategory['name'],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
              } else {
                // Si la liste est vide, on affiche directement le titre
                return ListTile(
                  title: Text(
                    entry.key,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(
                          category: 37,
                          categoryname: entry.key,
                        ),
                      ),
                    );
                  },
                );
              }
                  }).toList(),
                ),

          ),
        ],
      ),
      bottomNavigationBar: CustomFooter(),
    );
  }
}