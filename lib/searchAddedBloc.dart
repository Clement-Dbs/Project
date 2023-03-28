import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/gameListBloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class SearchAddedBarState {}
class SearchAddedValidated extends SearchAddedBarState{
  String searchAddedString;
  SearchAddedValidated(this.searchAddedString);
}
class SearchAddedFail extends SearchAddedBarState{}
class SearchAddedListSuccess extends SearchAddedBarState {
  final int numberGame;
  final List<Game> gamesList;
  SearchAddedListSuccess(this.gamesList, this.numberGame);
}
class SearchAddedListSuccessEmpty extends SearchAddedBarState {}
class SearchAddedListError extends SearchAddedBarState {}

abstract class SearchAddedBarEvent{}
class TestSearchAddedEvent extends SearchAddedBarEvent{
  final String searchAddedString;
  TestSearchAddedEvent(this.searchAddedString);
}
class FetchGameSearchAddedEvent extends SearchAddedBarEvent{
  final String searchAddedString;
  FetchGameSearchAddedEvent(this.searchAddedString);
}
class ResetStateEvent extends SearchAddedBarEvent{}


class SearchAddedBarBloc extends Bloc<SearchAddedBarEvent, SearchAddedBarState> {
  SearchAddedBarBloc() : super(_getInitState()) {
    on<TestSearchAddedEvent>(_onTestSearchAdded);
    on<FetchGameSearchAddedEvent>(_onFetchGameSearchAdded);
    on<ResetStateEvent>(_onResetState);
  }
  static SearchAddedBarState _getInitState() {
    final state = SearchAddedFail();
    return state;
  }
}

Future<void> _onResetState(event, emit) async {
  final state = SearchAddedListError();
  emit(state);
}

Future<void> _onTestSearchAdded(event, emit) async {
  String searchAddedStringTest = (event as TestSearchAddedEvent).searchAddedString;
  if(searchAddedStringTest.isNotEmpty){
    final state = SearchAddedValidated(searchAddedStringTest);
    emit(state);
  }
  else{
    final state = SearchAddedFail();
    emit(state);
  }
}

Future<void> _onFetchGameSearchAdded(event, emit) async {
  String searchAdded = (event as FetchGameSearchAddedEvent).searchAddedString;

  final searchAddedResponse = await http.get(Uri.parse(
      'https://store.steampowered.com/api/storesearch/?term=$searchAdded&cc=fr'));
  if (searchAddedResponse.statusCode == 200) {
    final searchAddedJsonResponse = jsonDecode(searchAddedResponse.body);
    final List<dynamic> items = searchAddedJsonResponse['items'];

    final games = <Game>[];
    for (final item in items) {
      final gameId = item['id'].toString();
      final gameResponse = await http.get(Uri.parse(
          'https://store.steampowered.com/api/appdetails/?appids=$gameId&cc=fr'));
      if (gameResponse.statusCode == 200) {
        final gameJsonResponse = jsonDecode(gameResponse.body);
        final gameData = gameJsonResponse[gameId]['data'];
        if (gameData != null) {
          final game = Game(
            id: gameData['steam_appid'] as int,
            name: gameData['name'] as String,
            description: gameData['short_description'] as String,
            imageUrl: gameData['header_image'] as String,
            longDescription: gameData['detailed_description'] as String,
            firstScreenshotUrl: gameData['screenshots'] != null &&
                gameData['screenshots'].isNotEmpty
                ? gameData['screenshots'][0]['path_thumbnail'] as String
                : '',
            firstBundlePrice: gameData['package_groups'] != null &&
                gameData['package_groups'].isNotEmpty
                ? ((gameData['package_groups'][0]['subs'][0]['price_in_cents_with_discount'] as int) / 100)
                .toStringAsFixed(2) + ' €'
                : '0.00 €',
            developers: gameData['developers'] != null
                ? (gameData['developers'] as List<dynamic>)
                .map((e) => e as String)
                .toList()
                : [],
          );
          games.add(game);
        }
      }
    }
    if(games.isNotEmpty){
      final state = SearchAddedListSuccess(games, games.length);
      emit(state);
    }
    else if(games.isEmpty){
      final state = SearchAddedListSuccessEmpty();
      emit(state);
    }
  } else {
    final state = SearchAddedListError();
    emit(state);
  }
}