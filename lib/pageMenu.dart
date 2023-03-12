import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  String? imageUrl;
  String apiUrl = 'https://store.steampowered.com/api/storesearch/?term=Destiny2:%20Lightfall&cc=EN&l=en';

  Future<String> getTinyImage() async {
    http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var results = jsonResponse['items'];
      var firstResult = results[0];
      var tinyImageUrl = firstResult['tiny_image'];
      return tinyImageUrl;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> loadData() async {
    String url = await getTinyImage();
    setState(() {
      imageUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a2025),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1a2025),
        elevation: 8.0,
        title: const Text(
          'Accueil',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  //Fonctionnement des likes
                },
              ),
              SizedBox(width: 14),
              IconButton(
                icon: Icon(
                  Icons.star_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  //Fonctionnement wishlist
                },
              ),
              SizedBox(width: 14),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top:0),
                    child: SizedBox(
                      height: 40.0,
                      width: 300,
                      child: TextFormField(
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: Color(0xFF636af6),
                              size: 18,
                            ),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {},
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          filled: true,
                          fillColor: const Color(0xFF1e262c),
                          label: const Padding(
                            padding: EdgeInsets.only(left:5),
                            child: Text(
                              "Rechercher un jeu...",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w300,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF1e262c), width: 1),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF1e262c), width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
            child: SizedBox(
              height: 170,
              child: Container(
                child: imageUrl == null ? CircularProgressIndicator() : Image.network(imageUrl!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//http://store.steampowered.com/api/appdetails?appids=id_du_jeu&cc=FR&l=fr