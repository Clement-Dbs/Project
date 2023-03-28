import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:project/likeBloc.dart';
import 'package:project/pageGameDetails.dart';

class LikePage extends StatefulWidget {
  const LikePage({Key? key}) : super(key: key);
  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {

  @override
  void initState() {
    super.initState();
    context.read<LikeManagementBloc>().add(FetchLikeEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<LikeManagementBloc>().add(FetchLikeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LikeManagementBloc, LikeManagementState>(
      listener: (context, state) {
        if (state is FetchGameLike) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameDetailPage(game: state.gameFetch),
            ),
          );
        }
      },
      child: Scaffold(
          backgroundColor: const Color(0xFF1a2025),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF1a2025),
            elevation: 8.0,
            title: const Text(
              'Mes Likes',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 25),
            child: BlocBuilder<LikeManagementBloc, LikeManagementState>(
                builder: (context, state){
                  if(state is FetchLikeFull){
                    return ListView.builder(
                      itemCount: state.gamesList.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 80,
                          child: Padding(
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
                                              Expanded(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    'Éditeur: ${state.gamesList[index].developers.length > 1 ? state.gamesList[index].developers[0] : state.gamesList[index].developers.join(", ")}',
                                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 4),
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
                                          BlocProvider.of<LikeManagementBloc>(context).add(
                                            FetchGameLikeEvent(state.gamesList[index].id),
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
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  else if(state is FetchLikeEmpty){
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            child: Icon(
                              Icons.favorite,
                              size: 100, // taille de l'icône
                              color: Colors.white, // couleur de l'icône
                            ),
                          ),
                          Align(
                            child: Container(
                              margin: const EdgeInsets.only(top:20, bottom:15),
                              child: const SizedBox(
                                width: 250,
                                child: Text(
                                  "Vous n'avez pas encore liké de contenu.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            child: Container(
                              child: const SizedBox(
                                width: 250,
                                child: Text(
                                  "Cliquez sur le coeur pour en rajouter.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    );
                  }
                  else{
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
            ),
          )
      ),
    );
  }
}