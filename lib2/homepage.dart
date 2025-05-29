// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, sized_box_for_whitespace, sort_child_properties_last

import 'package:baskiti/CategoryPage.dart';
import 'package:baskiti/CustomAppBar.dart';
import 'package:baskiti/CustomFooter.dart';
import 'package:baskiti/produit.dart';
 import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// Modèle pour les stories
class Story {
  final String id;
  final String imageUrl;
  final String title;
  final bool isViewed;

  Story({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.isViewed = false,
  });
}

// Modèle pour les marques
class Brand {
  final String id;
  final String name;
  final String logoUrl;

  Brand({
    required this.id,
    required this.name,
    required this.logoUrl,
  });
}

// Modèle pour les catégories
class Category {
  final int id;
  final String name;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

// Widget pour afficher une story individuelle
class StoryCircle extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;

  const StoryCircle({
    Key? key,
    required this.story,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: story.isViewed
                  ? LinearGradient(
                      colors: [Colors.grey, Colors.grey.shade300],
                    )
                  : LinearGradient(
                      colors: [
                        Color(0xFFE85E24),
                        Color(0xFFFF6B35),
                        Color(0xFFFFD23F),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            ),
            child: Container(
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Container(
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(story.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: 70,
            child: Text(
              story.title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget pour afficher un logo de marque
class BrandCircle extends StatelessWidget {
  final Brand brand;
  final VoidCallback onTap;

  const BrandCircle({
    Key? key,
    required this.brand,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  brand.logoUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: 65,
            child: Text(
              brand.name,
              style: TextStyle(
                fontSize: 10,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget pour afficher une catégorie individuelle
class CategoryItem extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryItem({
    Key? key,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Image.asset(
                    category.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget pour afficher les marques sur 3 lignes avec scroll horizontal
class BrandsSection extends StatelessWidget {
  final List<Brand> brands;
  final Function(Brand) onBrandTap;

  const BrandsSection({
    Key? key,
    required this.brands,
    required this.onBrandTap,
  }) : super(key: key);

  // Fonction pour organiser les marques en colonnes
  List<List<Brand>> _organizeInColumns(List<Brand> brands, int rowsPerColumn) {
    List<List<Brand>> columns = [];
    
    for (int i = 0; i < brands.length; i += rowsPerColumn) {
      int end = (i + rowsPerColumn < brands.length) ? i + rowsPerColumn : brands.length;
      columns.add(brands.sublist(i, end));
    }
    
    return columns;
  }

  @override
  Widget build(BuildContext context) {
    List<List<Brand>> brandColumns = _organizeInColumns(brands, 3);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Nos marques",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00253d),
                ),
              ),
              Text(
                'Voir plus',
                style: TextStyle(color: Color(0xFFE85E24)),
                
              ),
            ],
          ),
        ),
          // Marques organisées en 3 lignes avec scroll horizontal
          Container(
            height: 240, // Hauteur pour 3 lignes (80px * 3)
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: brandColumns.length,
              itemBuilder: (context, columnIndex) {
                return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Column(
                    children: brandColumns[columnIndex].map((brand) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: BrandCircle(
                          brand: brand,
                          onTap: () => onBrandTap(brand),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

// Widget pour afficher les catégories horizontalement
class CategoriesSection extends StatelessWidget {
  final List<Category> categories;
  final Function(Category) onCategoryTap;

  const CategoriesSection({
    Key? key,
    required this.categories,
    required this.onCategoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Catégories",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00253d),
                  ),
                ),
                Text(
                  'Voir plus',
                  style: TextStyle(color: Color(0xFFE85E24)),
                ),
              ],
            ),
          ),
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return CategoryItem(
                  category: categories[index],
                  onTap: () => onCategoryTap(categories[index]),
                );
              },
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

// Widget pour afficher les stories horizontalement
class StoriesWidget extends StatelessWidget {
  final List<Story> stories;
  final Function(Story) onStoryTap;

  const StoriesWidget({
    Key? key,
    required this.stories,
    required this.onStoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 12),
            child: StoryCircle(
              story: stories[index],
              onTap: () => onStoryTap(stories[index]),
            ),
          );
        },
      ),
    );
  }
}

// Page pour afficher la story en plein écran
class StoryViewPage extends StatefulWidget {
  final Story story;

  const StoryViewPage({Key? key, required this.story}) : super(key: key);

  @override
  _StoryViewPageState createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Stack(
          children: [
            // Image de la story
            Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.story.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Barre de progression en haut
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                },
              ),
            ),
            // Bouton fermer
            Positioned(
              top: 50,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<String> carouselImages = [
    'assets/sliders/slider1.png',
    'assets/sliders/slider2.jpg',
    'assets/sliders/slider3.jpg',
  ];

  // Liste des stories
  final List<Story> stories = [
    Story(
      id: '1',
      imageUrl: 'assets/images/story1.png',
      title: 'Promo',
    ),
    Story(
      id: '2',
      imageUrl: 'assets/images/story1.png',
      title: 'Nouveau',
    ),
    Story(
      id: '3',
      imageUrl: 'assets/images/story1.png',
      title: 'Tendance',
    ),
  ];

  // Liste des marques (remplacez par vos logos de marques)
  final List<Brand> brands = [
    Brand(id: '1', name: 'Coca Cola', logoUrl: 'assets/images/aicha.png'),
    Brand(id: '2', name: 'Nestlé', logoUrl: 'assets/images/chakour.png'),
    Brand(id: '3', name: 'cristal', logoUrl: 'assets/images/cristal.png'),
    Brand(id: '4', name: 'Unilever', logoUrl: 'assets/images/dari.png'),
    Brand(id: '5', name: 'L\'Oréal', logoUrl: 'assets/images/hala.png'),
    Brand(id: '6', name: 'Samsung', logoUrl: 'assets/images/sultan.png'),
    Brand(id: '7', name: 'Apple', logoUrl: 'assets/images/elnass.png'), 
       Brand(id: '1', name: 'Coca Cola', logoUrl: 'assets/images/aicha.png'),
    Brand(id: '2', name: 'Nestlé', logoUrl: 'assets/images/chakour.png'),
    Brand(id: '3', name: 'cristal', logoUrl: 'assets/images/cristal.png'),
    Brand(id: '4', name: 'Unilever', logoUrl: 'assets/images/dari.png'),
    Brand(id: '5', name: 'L\'Oréal', logoUrl: 'assets/images/hala.png'),
    Brand(id: '6', name: 'Samsung', logoUrl: 'assets/images/sultan.png'),
    Brand(id: '7', name: 'Apple', logoUrl: 'assets/images/elnass.png'), 
       Brand(id: '1', name: 'Coca Cola', logoUrl: 'assets/images/aicha.png'),
    Brand(id: '2', name: 'Nestlé', logoUrl: 'assets/images/chakour.png'),
    Brand(id: '3', name: 'cristal', logoUrl: 'assets/images/cristal.png'),
    Brand(id: '4', name: 'Unilever', logoUrl: 'assets/images/dari.png'),
    Brand(id: '5', name: 'L\'Oréal', logoUrl: 'assets/images/hala.png'),
    Brand(id: '6', name: 'Samsung', logoUrl: 'assets/images/sultan.png'),
    Brand(id: '7', name: 'Apple', logoUrl: 'assets/images/elnass.png'), 

  ];

  // Liste des catégories
  final List<Category> categories = [
    Category(id: 1, name: 'Alimentaire', imageUrl: 'assets/images/alimentation.png'),
    Category(id: 1, name: 'Boissons', imageUrl: 'assets/images/boissons.png'),
    Category(id: 1, name: 'Hygiène', imageUrl: 'assets/images/hygiene.png'),
    Category(id: 1, name: 'Beauté', imageUrl: 'assets/images/beaute.png'),
    Category(id: 1, name: 'Bébé', imageUrl: 'assets/images/bebe.png'),
    Category(id: 1, name: 'Entretien', imageUrl: 'assets/images/entretien.png'),
    Category(id: 1, name: 'Maison', imageUrl: 'assets/images/maison.png'),
  ];

  
  void _onStoryTap(BuildContext context, Story story) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryViewPage(story: story),
      ),
    );
  }

  void _onBrandTap(BuildContext context, Brand brand) {
    // Navigation vers la page des produits de la marque
    print('Marque cliquée: ${brand.name}');
    // Vous pouvez naviguer vers une page de filtrage par marque
  }

  void _onCategoryTap(BuildContext context, Category category) {
    // Navigation vers CategoryPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryPage(
          category: category.id,
          categoryname: category.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stories section en haut
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre "Offres spéciales" avec icône de feu
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 12, bottom: 8),
                    child: Row(
                      children: [
                       Text(
                          'Offres spéciales',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00253d),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.local_fire_department,
                          color: Color(0xFFE85E24),
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                  // Stories widget
                  StoriesWidget(
                    stories: stories,
                    onStoryTap: (story) => _onStoryTap(context, story),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            
            // Barre de recherche
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Recherche...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            // Section des marques
            BrandsSection(
              brands: brands,
              onBrandTap: (brand) => _onBrandTap(context, brand),
            ),

            SizedBox(height: 10),

            // Section des catégories
            CategoriesSection(
              categories: categories,
              onCategoryTap: (category) => _onCategoryTap(context, category),
            ),

            SizedBox(height: 10),
            
            // Sections de produits
            ProductSection(title: 'Nouveautés', products: [
              {'name': 'MOLFIX Couches 36 Maxi 4U', 'price': '44.00 dh', 'image': 'assets/images/prod1.png'},
              {'name': 'MOLFIX Couches 22 Xlarge 4U', 'price': '44.00 dh', 'image': 'assets/images/prod1.png'},
              {'name': 'MOLFIX Couches 36 Maxi 4U', 'price': '44.00 dh', 'image': 'assets/images/prod1.png'},
              {'name': 'MOLFIX Couches 36 Maxi 4U', 'price': '44.00 dh', 'image': 'assets/images/prod1.png'},
              {'name': 'MOLFIX Couches 22 Xlarge 4U', 'price': '44.00 dh', 'image': 'assets/images/prod1.png'},
              {'name': 'MOLFIX Couches 36 Maxi 4U', 'price': '44.00 dh', 'image': 'assets/images/prod1.png'},
            ]),
            ProductSection(title: 'Top Vendu', products: [
              {'name': 'DARI Couscous', 'price': '15.00 dh', 'image': 'assets/images/prod1.png'},
              {'name': 'DURACELL Piles', 'price': '20.00 dh', 'image': 'assets/images/prod2.png'},
              {'name': 'MOLFIX Couches 36 Maxi 4U', 'price': '44.00 dh', 'image': 'assets/images/prod1.png'},
              {'name': 'MOLFIX Couches 36 Maxi 4U', 'price': '44.00 dh', 'image': 'assets/images/prod1.png'},
              {'name': 'MOLFIX Couches 22 Xlarge 4U', 'price': '44.00 dh', 'image': 'assets/images/prod1.png'},
              {'name': 'MOLFIX Couches 36 Maxi 4U', 'price': '44.00 dh', 'image': 'assets/images/prod1.png'},
            ]),
            SizedBox(height: 20), 
          ],
        ),
      ),
      bottomNavigationBar: CustomFooter(),
    );
  }
}

class ProductSection extends StatelessWidget {
  final String title;
  final List<Map<String, String>> products;

  ProductSection({required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00253d),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailApp(productId: 24),
                    ),
                  );
                },
                child:
              Stack(
                children: [
                  Container(
                    width: 140,
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Image.asset(
                            product['image']!,
                            height: 80,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product['name']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            product['price']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 150,
                    right: 15,
                    child: GestureDetector(
                      onTap: () {
                        // Action lors du clic sur le bouton +
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Color(0xFFE85E24),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ));
            },
          ),
        ),
      ],
    );
  }
}