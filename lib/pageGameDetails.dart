import 'package:flutter/material.dart';
import 'package:project/gameListBloc.dart';
import 'package:project/likeBloc.dart';
import 'package:project/favBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class GameDetailPage extends StatefulWidget {
  final Game game;
  const GameDetailPage({Key? key, required this.game}) : super(key: key);

  @override
  _GameDetailState createState() => _GameDetailState();
}

class _GameDetailState extends State<GameDetailPage> {
  _GameDetailState();
  var htmlData = '';

  @override
  void initState() {
    htmlData = widget.game.longDescription;
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
          'Détail du jeu',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/menu');
            },
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
                  BlocProvider.of<LikeManagementBloc>(context).add(
                    PostLikeEvent(widget.game.id),
                  );
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
                  BlocProvider.of<FavManagementBloc>(context).add(
                      PostFavEvent(widget.game.id),
                  );
                },
              ),
              const SizedBox(width: 14),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<LikeManagementBloc, LikeManagementState>(
                builder: (context, state){
                  if(state is PostLike && state is! InitStateLike){
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Like ajouté'),
                              content: Text("Le jeu a bien été ajouté à votre liste de like\nSi vous voulez le supprimer, cliquez à nouveau sur l'icone"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    BlocProvider.of<LikeManagementBloc>(context).add(
                                      ResetStateEvent(),
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          }
                      );
                    });
                  }
                  else if(state is PostLikeAlready && state is! InitStateLike){
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Like a déjà été ajouté'),
                              content: Text('Voulez vous le supprimer ?'),
                              actions: <Widget>[
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        BlocProvider.of<LikeManagementBloc>(context).add(
                                          ResetStateEvent(),
                                        );
                                        BlocProvider.of<LikeManagementBloc>(context).add(
                                          DeleteLikeEvent(widget.game.id)
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text('Oui'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        BlocProvider.of<LikeManagementBloc>(context).add(
                                          ResetStateEvent(),
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text('Non'),
                                    ),
                                  ],
                                )
                              ],
                            );
                          }
                      );
                    });
                  }
                  else if(state is ErrorLike && state is! InitStateLike){
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Erreur'),
                              content: Text("Ajout du Like n'a pas fonctionné"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          }
                      );
                    });
                  }
                  else if(state is InitStateLike){
                    return SizedBox.shrink();
                  }
                  return SizedBox.shrink();
                }
            ),
            BlocBuilder<FavManagementBloc, FavManagementState>(
                builder: (context, state){
                  if(state is PostFav && state is! InitStateFav){
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Favoris ajouté'),
                              content: Text("Le jeu a bien été ajouté à votre liste de favoris\nSi vous voulez le supprimer, cliquez à nouveau sur l'icone"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    BlocProvider.of<FavManagementBloc>(context).add(
                                      ResetStateEventFav(),
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          }
                      );
                    });
                  }
                  else if(state is PostFavAlready && state is! InitStateFav){
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Ce favoris a déjà été ajouté'),
                              content: Text('Voulez vous le supprimer ?'),
                              actions: <Widget>[
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        BlocProvider.of<FavManagementBloc>(context).add(
                                          ResetStateEventFav(),
                                        );
                                        BlocProvider.of<FavManagementBloc>(context).add(
                                            DeleteFavEvent(widget.game.id)
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text('Oui'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        BlocProvider.of<FavManagementBloc>(context).add(
                                          ResetStateEventFav(),
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text('Non'),
                                    ),
                                  ],
                                )
                              ],
                            );
                          }
                      );
                    });
                  }
                  else if(state is ErrorFav && state is! InitStateFav){
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Erreur'),
                              content: Text("Ajout du favoris n'a pas fonctionné"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          }
                      );
                    });
                  }
                  else if(state is InitStateFav){
                    return SizedBox.shrink();
                  }
                  return SizedBox.shrink();
                }
            ),
            Stack(
              children: [
                Container(
                  height: 400.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.game.firstScreenshotUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 120,
                    color: Color(0xFF1E2125),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                            child: ClipRRect(
                              child: Image.network(
                                widget.game.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ),
                        Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.game.name,
                                    style: TextStyle(fontSize: 15, color: Colors.white),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Éditeur: ${widget.game.developers.join(", ")}',
                                      style: TextStyle(fontSize: 13, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 16),
              child: Html(
                  data: htmlData,
                style: {
                  "body": Style(
                    color: Colors.white,
                  ),
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}