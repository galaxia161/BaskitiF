// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, must_be_immutable, unnecessary_null_comparison, use_build_context_synchronously, sort_child_properties_last, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, avoid_print, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:baskiti/cart.dart';
import 'package:baskiti/createaccount.dart';
import 'package:baskiti/panier.dart';
import 'package:baskiti/order.dart';
import 'package:baskiti/recap.dart';
import 'package:baskiti/user.dart';
import 'package:baskiti/usertemp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ConfirmLivraisonPage extends StatefulWidget {
  @override
  _ConfirmLivraisonPageState createState() => _ConfirmLivraisonPageState();
}

class _ConfirmLivraisonPageState extends State<ConfirmLivraisonPage> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

   double calculateTotal(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return cartProvider.calculateTotal();
  }
  
  
  int getFraisLivraison(String? ville) {
   final cartProvider = Provider.of<CartProvider>(context, listen: false);
   final total= cartProvider.calculateTotal();
   int livraison = 0;
   if (total > 800) {
     livraison = 0;
   } 
   else if (total > 600 && (ville=="Tetouan" || ville=="Mdiq" || ville=="Martil" || ville=="Fnideq" )){
      livraison = 0;
   }
   else if (total < 600 && (ville=="Mdiq" || ville=="Martil" || ville=="Fnideq")){
      livraison = 25;
   }
   else if (total < 600 && ville=="Tetouan"){
      livraison = 15;
   }
   else {
    livraison = 45;
   }

  return  livraison;
}

  final List<String> villes = [
    "Sidi Allal Tazi",
    "Sidi Allal Al Bahraoui",
    "Sidi Ali Ban Hamdouche",
    "Sidi Addi",
    "Sid Zouin",
    "Sidi Abdallah Ghiat",
    "Settat",
    "Sefrou",
    "Selouane",
    "Sebt Gzoula",
    "Sebt Jahjouh",
    "Sebt El Maarif",
    "Sale",
    "SEBT EL GUERDANE",
    "Sala El Jadida",
    "Saidia",
    "Safi",
    "Sabaa Aiyoun",
    "Rommani",
    "Rissani",
    "Ribate El Kheir",
    "Ras El Ma",
    "Ras El Ain",
    "Rabat",
    "Ounagha",
    "Oulmes",
    "Ouled Youssef",
    "Ouled Tayeb",
    "Oulad Zbair",
    "Oulad Teima",
    "Oulad MRah",
    "Oulad M Barek",
    "Oulad H Riz Sahel",
    "Oulad Ghadbane",
    "Oulad Frej",
    "Oulad Berhil",
    "Oulad Ayad",
    "Oulad Amrane",
    "Oukaimeden",
    "Oujda",
    "Ouezzane",
    "Oued Zem",
    "Oued Laou",
    "Oued Amlil",
    "Ouarzazate",
    "Oualidia",
    "Nouaceur",
    "Nhima",
    "Nador",
    "Moulay Idriss Zerhoun",
    "Moulay Bousselham",
    "Moulay Ali Cherif",
    "Moqrisset",
    "Mohammadia",
    "Missour",
    "Mirleft",
    "Midelt",
    "Midar",
    "Melloussa",
    "Meknes",
    "Mehdia",
    "Mediouna",
    "Mdiq",
    "Mechra Bel Ksiri",
    "Martil",
    "Marrakech",
    "Madagh",
    "Mrirt",
    "Lqliaa",
    "Lixus",
    "Larache",
    "Lalla Mimouna",
    "Lagouira",
    "Laayoune",
    "Laattaouia",
    "Ksar Sghir",
    "Ksar el Kebir",
    "klaat Megouna",
    "Khouribga",
    "Khenifra",
    "Khenichet",
    "Khemisset",
    "Khemis Zemamra",
    "Khemis Sahel",
    "Khemis Dades",
    "Ketama",
    "Kenitra",
    "Kehf Nsour",
    "Kattara",
    "Kassita",
    "Kasba Tadla",
    "Karia Ba Mohammed",
    "Jorf El Melha",
    "Jorf",
    "Jerada",
    "Jemaa Sahim",
    "Jebha",
    "Itzer",
    "Inseka",
    "Inezgane",
    "Imzouren",
    "Imouzzer Kandar",
    "Immouzer Marmoucha",
    "Imintanoute",
    "Imilili",
    "Imilchil",
    "Ihddaden",
    "Ighrem Nougdal",
    "Ifrane",
    "Harhoura",
    "Haj Kaddour",
    "Hagunia",
    "Had Kourt",
    "Guisser",
    "Guerguerat",
    "Guercif",
    "Guelta Zemmour",
    "Guelmim",
    "Goulmima",
    "Fquih Ben Salah",
    "Fnideq",
    "Figuig",
    "Fes",
    "Farcia",
    "Essaouira",
    "Errachidia",
    "Erfoud",
    "Er Rich",
    "El Ouatia",
    "El Menzel",
    "El Mansouria",
    "El Kelaa des sraghna",
    "El Jadida",
    "El Hanchane",
    "El Hajeb",
    "El Guerdane",
    "El Gara",
    "El Borouj",
    "El Aioun Sidi Mellouk",
    "Driouch",
    "Douar Bel Aguide",
    "Deroua",
    "Demnate",
    "Debdou",
    "Dcheira",
    "Dar Kebdani",
    "Dar Gueddari",
    "Dar Bouaaza",
    "Dakhla",
    "Chichaoua",
    "Chemaia",
    "Chefchaouen",
    "Chalwa",
    "Casablanca",
    "Brikcha",
    "Bradia",
    "Bouznika",
    "Bouskoura",
    "Boumia",
    "Boumalne Dades",
    "Boulemane",
    "Bouknadel",
    "Boujniba",
    "Boujdour",
    "Boujad",
    "Bouizakarne",
    "Bouguedra",
    "Boufakrane",
    "Boudnib",
    "Bouarfa",
    "Bouanane",
    "Bou Craa",
    "Bni Hadifa",
    "Bni Drar",
    "Bni Bouayach",
    "Bir Lehlou",
    "Bir Gandouz",
    "Biougra",
    "Bhalil",
    "Berrechid",
    "Berkane",
    "Beni Tadjit",
    "Beni Mellal",
    "Beni Chiker",
    "Beni Ansar",
    "Benguerir",
    "Ben Yakhlef",
    "Ben Taieb",
    "Ben Slimane",
    "Ben Ahmed",
    "Bab Taza",
    "Bab Berred",
    "Azrou",
    "Azilal",
    "Azemmour",
    "Assahrij",
    "Assa",
    "Asilah",
    "Arfoud",
    "Arbaoua",
    "Aoufous",
    "Amizmiz",
    "Amgala",
    "Amalou Ighriben",
    "Al Hoceima",
    "Al Aaroui",
    "Aklim",
    "Ajdir",
    "Ait Ourir",
    "Ait Melloul",
    "Ait Ishaq",
    "Ait Iaaza",
    "Ait Daoud",
    "Ait Bouhlal",
    "Ait Boubidmane",
    "Ait Benhaddou",
    "Ait Baha",
    "Ain Taoujdate",
    "Ain Jemaa",
    "Ain Harrouda",
    "Ain Erreggada",
    "Ain Dorij",
    "Ain Defali",
    "Ain Bni Mathar",
    "Ain Aouda",
    "Ain Aleuh",
    "Ahfir",
    "Aguelmous",
    "Agourai",
    "Agdz",
    "Agadir",
    "Afourar",
    "Sidi Bennour",
    "Sidi Bettache",
    "Sidi Bibi",
    "Sidi Bou Othmane",
    "Sidi Boubker",
    "Sidi Ifni",
    "Sidi Jaber",
    "Sidi Kacem",
    "Sidi Lyamani",
    "Sidi Oud tazla",
    "Sidi Rahhal",
    "Sidi Slimane",
    "Sidi Smail",
"Sidi Taibi",
"Sidi Yahya el Gharb",
"Skhirat",
"Skhour Rehamna",
"Smara",
"Soualem",
"Souk Sebt Oulad Nemma",
"Souq Larba al Gharb",
"Taddert",
"Tafarsit",
"Tafetachte",
"Tafraout",
"Taghjijt",
"Tahala",
"Tahannaout",
"Tainaste",
"Taliouine",
"Talmest",
"Talssint",
"Tamallalt",
"Tamanar",
"Tamansourt",
"Tameslouht",
"Tamesna",
"Tan Tan",
"Tanger",
"Taounate",
"Taourirte",
"Tarfaya",
"Targuist",
"Taroudant",
"Tata",
"Taza",
"Taznakht",
"Telouet",
"Temara",
"Temsia",
"Tendrara",
"Tetouan",
"Thar Es Souk",
"Tichla",
"Tidass",
"Tifariti",
"Tifelt",
"Tiflet",
"Tighza",
"Timahdite",
"Tinejdad",
"Tinghir",
"Tinmel",
"Tissa",
"Tit Mellil",
"Tiznit",
"Tiztoutine",
"Torres de Alcala",
"Tounfite",
"Youssoufia",
"Zag",
"Zagora",
"Zaio",
"Zaouiat Cheikh",
"Zeghanghane",
"Zemamra"
  ];
  
  String? ville;
   String? modeLivraison = "domicile"; // Déclaration globale dans le State
  String? modePaiement = "livraison"; // Déclaration globale dans le State
  
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    Future<void> _onLogin() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
      return;
    }

    
    try {
    // Préparer les paramètres
    final Map<String, String> parameters = {
      'username': username,
      'password': password,
    };

    // Envoyer la requête POST
    final response = await http.post(
      Uri.parse("https://suenos.ma/index.php?option=com_application&task=connect"),
      body: parameters,
    );
    // Vérifier le statut HTTP
    if (response.statusCode == 200) {
      // Traiter la réponse JSON
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('user_id')) {
        Provider.of<UserProvider>(context, listen: false).setUserData(id: jsonResponse['user_id'],username: jsonResponse['username'],email:jsonResponse['email'],name: jsonResponse['username'],points: jsonResponse['points'], 
        last_name: jsonResponse['last_name'],phone_1: jsonResponse['phone_1'],address_1: jsonResponse['address_1'],city: jsonResponse['city'],first_name: jsonResponse['first_name'],zip: jsonResponse['zip']);
          Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConfirmLivraisonPage()),
                  );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(jsonResponse['error'])),
      );
      return;
       }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Un problème est survenu, veuillez réessayer ultérieurement")),
      );
      return;
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Un problème est survenu de serveur, veuillez réessayer ultérieurement")),
      );
      return;
  }

    

  }
  if (userProvider.iduser == null || userProvider.iduser==0 ) {
 
    final userTempProvider = Provider.of<UserTempProvider>(context, listen: false);
    
    TextEditingController _lastname = TextEditingController(text: userTempProvider.last_name );
    TextEditingController _firstname = TextEditingController(text: userTempProvider.first_name );
    TextEditingController _address_1 = TextEditingController(text: userTempProvider.address_1 );
    TextEditingController _phone_1 = TextEditingController(text: userTempProvider.phone_1 );
    String? actualville = "";
    if  (userTempProvider.city!=""){
      actualville=userTempProvider.city;
    }
    else {
      actualville="Tetouan";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Validation de la commande'),
        leading: IconButton(
        icon: Icon(Icons.arrow_back), // Icône de retour personnalisée
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CartPage()), // Remplace par ta page cible
          );
        },
      ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                    "Avez-vous un compte ? Connectez-vous pour cumuler vos points de fidélité.",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
            SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Connexion",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: "Nom d'utilisateur",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _onLogin,
                      child: Text('Se connecter'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateAccountPage()),
                    );
                      },
                      child: Text("Créer un compte"),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Détails d'expédition si vous voulez passer votre commande sans compte",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _lastname,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                     controller: _firstname,
                    decoration: InputDecoration(
                      labelText: 'Prénom',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                     controller: _address_1,
                    decoration: InputDecoration(
                      labelText: 'Adresse',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: actualville,
                    hint: Text("Choisir une ville"),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                    ),
                    items: villes.map((String ville) {
                      return DropdownMenuItem<String>(
                        value: ville,
                        child: Text(ville),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      ville = newValue;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                     controller: _phone_1,
                    decoration: InputDecoration(
                      labelText: 'Téléphone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                    SizedBox(height: 20),
                    Text(
                      "Mode de livraison",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),SizedBox(height: 10),
                    Column(
                        children: [
                          ListTile(
                            leading: Radio<String>(
                              value: "magasin",
                              groupValue: modeLivraison, // Doit être modeLivraison !
                              onChanged: (String? value) {
                                setState(() {
                                  modeLivraison = value!;
                                  print("Mode de livraison sélectionné : $modeLivraison");
                                });
                              },
                            ),
                            title: Text("Retirer au magasin"),
                          ),
                          ListTile(
                            leading: Radio<String>(
                              value: "domicile",
                              groupValue: modeLivraison, // Doit être modeLivraison !
                              onChanged: (String? value) {
                                setState(() {
                                  modeLivraison = value!;
                                 });
                              },
                            ),
                            title: Text("Livraison à domicile"),
                          ),
                        ],
                      ),
                  SizedBox(height: 20),
              Text(
                "Mode de paiement",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
             Column(
                children: [
                  ListTile(
                    leading: Radio<String>(
                      value: "livraison",
                      groupValue: modePaiement,  
                      onChanged: (String? value) {
                        setState(() {
                          modePaiement = value!;
                         });
                      },
                    ),
                    title: Text("Paiement à la livraison"),
                  ),
                  ListTile(
                    leading: Radio<String>(
                      value: "carte",
                      groupValue: modePaiement, // Doit être modePaiement !
                      onChanged: null, // Désactivé temporairement
                    ),
                    title: Text("Paiement par carte (n'est pas disponible temporairement)"),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final last_name=_lastname.text.trim();
                      final first_name=_firstname.text.trim();
                      final phone_1=_phone_1.text.trim();
                      final address_1=_address_1.text.trim();
                      final String? vcity= ville;
                      if (_formKey.currentState?.validate() ?? false) {
                        userTempProvider.setUserData(last_name: last_name, first_name: first_name, phone_1: phone_1, address_1: address_1, city: vcity);
                        orderProvider.setOrderData(cartItems: cartProvider.getItems(), total: calculateTotal(context), livraison: getFraisLivraison(ville), modeLivraison: modeLivraison.toString(), modePaiement: modePaiement.toString());

                      }
                 

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecapPage()),
                      );
                    },
                    child: Text('Valider'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  else {
  //in case already registered
   
     final userProvider = Provider.of<UserProvider>(context, listen: false);
    TextEditingController _lastname = TextEditingController(text: userProvider.last_name );
    TextEditingController _firstname = TextEditingController(text: userProvider.first_name );
    TextEditingController _address_1 = TextEditingController(text: userProvider.address_1 );
    TextEditingController _phone_1 = TextEditingController(text: userProvider.phone_1 );
  return Scaffold(
  appBar: AppBar(
     title: Text('Validation de la commande'),
    leading: IconButton(
        icon: Icon(Icons.arrow_back), // Icône de retour personnalisée
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CartPage()), // Remplace par ta page cible
          );
        },
      ),
  ),
  body: Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Veuillez confirmer vos informations de livraison.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _lastname,
                      decoration: InputDecoration(
                        labelText: 'Nom',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _firstname,
                      decoration: InputDecoration(
                        labelText: 'Prénom',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _address_1,
                      decoration: InputDecoration(
                        labelText: 'Adresse',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: userProvider.city ,
                      hint: Text("Choisir une ville"),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                      ),
                      items: villes.map((String ville) {
                        return DropdownMenuItem<String>(
                          value: ville,
                          child: Text(ville),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          ville = newValue;
                         });
                       },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _phone_1,
                      decoration: InputDecoration(
                        labelText: 'Téléphone',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Mode de livraison",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        ListTile(
                          leading: Radio<String>(
                            value: "magasin",
                            groupValue: modeLivraison,
                            onChanged: (String? value) {
                              setState(() {
                                modeLivraison = value;
                              });
                            },
                          ),
                          title: Text("Retirer au magasin"),
                        ),
                        ListTile(
                          leading: Radio<String>(
                            value: "domicile",
                            groupValue: modeLivraison,
                            onChanged: (String? value) {
                              setState(() {
                                modeLivraison = value;
                              });
                            },
                          ),
                          title: Text("Livraison à domicile"),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Mode de paiement",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        ListTile(
                          leading: Radio<String>(
                            value: "livraison",
                            groupValue: modePaiement,
                            onChanged: (String? value) {
                              setState(() {
                                modePaiement = value;
                              });
                            },
                          ),
                          title: Text("Paiement à la livraison"),
                        ),
                        ListTile(
                          leading: Radio<String>(
                            value: "carte",
                            groupValue: modePaiement,
                            onChanged: null,
                          ),
                          title: Text("Paiement par carte (n'est pas disponible temporairement)"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
  bottomNavigationBar: Container(
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Total : ${calculateTotal(context).toStringAsFixed(2)} MAD",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          "Frais de livraison : ${getFraisLivraison(userProvider.city)}",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            orderProvider.setOrderData(cartItems: cartProvider.getItems(), total: calculateTotal(context), livraison: getFraisLivraison(ville), modeLivraison: modeLivraison.toString(), modePaiement: modePaiement.toString());

            if (_formKey.currentState?.validate() ?? false) {
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecapPage()),
                      );
            }
          },
          child: Text('Confirmez la commande'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ],
    ),
  ),
);




  }
  }
}
