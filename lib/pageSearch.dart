import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/searchAddedBloc.dart';
import 'package:project/pageGameDetails.dart';

class SearchPage extends StatefulWidget {
  final String searchString;
  const SearchPage({Key? key, required this.searchString}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchStringController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SearchAddedBarBloc>().add(ResetStateEvent());
    context.read<SearchAddedBarBloc>().add(FetchGameSearchAddedEvent(widget.searchString));
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<SearchAddedBarBloc>().add(ResetStateEvent());
    context.read<SearchAddedBarBloc>().add(FetchGameSearchAddedEvent(widget.searchString));
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
          'Recherche',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top:0),
                    child: SizedBox(
                      height: 40.0,
                      width: 400,
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
                                if(searchStringController.value.text.isNotEmpty){
                                  context.read<SearchAddedBarBloc>().add(ResetStateEvent());
                                  context.read<SearchAddedBarBloc>().add(FetchGameSearchAddedEvent(searchStringController.value.text));
                                }
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
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 191,
              margin: EdgeInsets.only(top: 12),
              child: BlocBuilder<SearchAddedBarBloc, SearchAddedBarState>(
                  builder: (context, state){
                    if(state is SearchAddedListSuccess){
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                'Résultats de recherche : ' + state.numberGame.toString(),
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                              child: ListView.builder(
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
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ),
                        ],
                      );
                    }
                    else if(state is SearchAddedListSuccessEmpty){
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 175,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                child: Container(
                                  margin: const EdgeInsets.only(top:20, bottom:15),
                                  child: const SizedBox(
                                    width: 250,
                                    child: Text(
                                      "Aucun Jeu trouvé",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
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
          ],
        )
      ),
    );
  }
}