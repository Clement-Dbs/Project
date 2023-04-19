
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:project/gameListBloc.dart';
import 'package:project/navigatorBloc.dart';
import 'package:project/pageGameDetails.dart';
import 'package:project/searchBloc.dart';
import 'package:project/pageSearch.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;


class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final TextEditingController searchStringController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MostPlayedGameListBloc>().add(FetchMostPlayedGameListEvent());
    searchStringController.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    searchStringController.clear();
  }

  @override
  void dispose() {
    searchStringController.dispose();
    super.dispose();

    
    /*http.Response response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var results = jsonResponse['items'];
      var firstResult = results[0];
      var tinyImageUrl = firstResult['tiny_image'];
      return tinyImageUrl;
    } else {
      throw Exception('Failed to load data');
    }*/
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
            fontSize: 24.0,
          ),
        ),
        leading: BlocListener<UserBloc, CState>(
          listener: (context, state) {
            if (state is Deconnexion) {
              Navigator.pushReplacementNamed(context, '/');
            }
          },
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                context.read<UserBloc>().add(
                  DisconnectUserEvent(),
                );
              },
            )
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/likes');
                },
              ),
              const SizedBox(width: 14),
              IconButton(
                // ignore: prefer_const_constructors
                icon: Icon(
                  Icons.star_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/favorites');
                },
              ),
              const SizedBox(width: 14),
            ],
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
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
                          width: 400,
                          child: BlocListener<SearchBarBloc, SearchBarState>(
                            listener: (context, state){
                              if(state is SearchValidated){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchPage(searchString: state.searchString),
                                  ),
                                );
                              }
                            },
                            child: TextFormField(
                              controller: searchStringController,
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
                                  onPressed: () {
                                    context.read<SearchBarBloc>().add(TestSearchEvent(searchStringController.value.text));
                                  },
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
                                      fontSize: 14.0,
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
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Container(
                  child: BlocBuilder<MostPlayedGameListBloc, MostPlayedGameListState>(
                    builder: (context, state) {
                      if (state is Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is Success) {
                        return ListView.separated(
                          itemCount: state.gamesList.length,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
                                child:Card(
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 300,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(state.gamesList[index].firstScreenshotUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          state.gamesList[index].name,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          state.gamesList[index].description,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF636af6)),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => GameDetailPage(game: state.gamesList[index]),
                                                            ),
                                                          );
                                                        },
                                                        child: Text('En savoir plus'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
                                child: SizedBox(
                                  height: 80,
                                  child: LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
                                                child: ClipRRect(
                                                  child: Image.network(
                                                    state.gamesList[index].imageUrl,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                          ),
                                          Expanded(
                                            child: Container(
                                              color: Color(0xFF1E2125),
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    state.gamesList[index].name,
                                                    style: TextStyle(fontSize: 15, color: Colors.white),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 4),Expanded(
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        'Éditeur: ${state.gamesList[index].developers.length > 1 ? state.gamesList[index].developers[0] : state.gamesList[index].developers.join(", ")}',
                                                        style: TextStyle(fontSize: 12, color: Colors.white),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),

                                                  Text(
                                                    'Prix: ' + state.gamesList[index].firstBundlePrice.toString(),
                                                    style: TextStyle(fontSize: 13, color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => GameDetailPage(game: state.gamesList[index]),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              color: Color(0xFF636af6),
                                              child: Center(
                                                child: Text(
                                                  'En savoir\nplus',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 13, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return Container(
                                margin: EdgeInsets.all(16.0),
                                child: Text(
                                  'Les meilleurs ventes',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                            return Divider();
                          },
                        );
                      } else if (state is ErrorFetch) {
                        return Center(
                          child: Text('Erreur: Impossible de récupérer la liste des jeux les plus joués.'),
                        );
                      } else {
                        return Center(
                          child: Text('Erreur: Impossible de récupérer la liste des jeux les plus joués.'),
                        );
                      }
                    },
                  ),
                ),
              ),
            ]
            ),
          ),

      ),
    );
  }
  }
