// ignore_for_file: prefer_const_constructors, avoid_print, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, unused_element
import 'dart:convert';
import 'package:baskiti/profile.dart';
import 'package:baskiti/user.dart';
import 'package:flutter/material.dart';
 import 'package:http/http.dart' as http;
 import 'package:provider/provider.dart';
 
class CreateAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CreateAccountscreen(),
      ),
    );
  }
}

class CreateAccountscreen extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccountscreen> {
  final _formKey = GlobalKey<FormState>();
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
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController= TextEditingController();
  final _password2Controller= TextEditingController();
  final _nameController = TextEditingController();
  final _nomController= TextEditingController();
  final _prenomController= TextEditingController();
  final _adresseController= TextEditingController();
  final _adresse2Controller= TextEditingController();
  final _mobileController= TextEditingController();

Future<void> _createaccount() async {
  String username = _usernameController.text.trim();
  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();
  String password2 = _password2Controller.text.trim();
  String name = _nameController.text.trim();
  String nom = _nomController.text.trim();
  String prenom = _prenomController.text.trim();
  String adresse = _adresseController.text.trim();
  String adresse2 = _adresse2Controller.text.trim();
  String mobile = _mobileController.text.trim();

  try {
    final Map<String, String> parameters = {
      'username': username,
      'password': password,
      'password2': password2,
      'name': name,
      'nom': nom,
      'email': email,
      'prenom': prenom,
      'adresse': adresse,
      'adresse2': adresse2,
      'mobile': mobile,
    };


    final response = await http.post(
      Uri.parse("https://baskiti.ma/index.php?option=com_application&task=createacount"),
      body: parameters,
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('user_id')) {
        if (!mounted) return;
        Provider.of<UserProvider>(context, listen: false).setUserData(
          id: jsonResponse['user_id'],
          username: jsonResponse['username'],
          email: jsonResponse['email'],
          name: jsonResponse['name'],
          points: 0,
          last_name: jsonResponse['last_name'],phone_1: jsonResponse['phone_1'],address_1: jsonResponse['address_1'],city: jsonResponse['city'],first_name: jsonResponse['first_name'],zip: jsonResponse['zip']);

 

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bienvenue, votre compte a été créé avec succès!")),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfileScreen()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse['error'])),
        );
        return;
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Un problème est survenu, veuillez réessayer ultérieurement")),
      );
      return;
    }
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Un problème est survenu de serveur, veuillez réessayer ultérieurement")),
    );
    return;
  }
}

  
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Container(
        color: Colors.white70,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1
              Text(
                'Informations client',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Nom d'utilisateur",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom d\'utilisateur';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _password2Controller,
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer le mot de passe';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom à afficher',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Section 2
              Text(
                "Détails d'expédition",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _prenomController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _adresseController,
                decoration: InputDecoration(
                  labelText: 'Adresse',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _adresse2Controller,
                decoration: InputDecoration(
                  labelText: 'Complément d\'adresse',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
             DropdownButtonFormField<String>(
            value: ville,
            hint: const Text("Choisir une ville"),
            decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                controller: _mobileController,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
             ElevatedButton(
                  onPressed:_createaccount,
                  child: Text('Créer le compte'),
                ),
            ],
          ),
        ),
      ),
      )
    );
  }
}
