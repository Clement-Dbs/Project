import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class MostPlayedGameListState {}
class Loading extends MostPlayedGameListState {}
class Success extends MostPlayedGameListState {
  final List<Game> gamesList;
  Success(this.gamesList);
}
class ErrorFetch extends MostPlayedGameListState {}

abstract class MostPlayedGameListEvent {}

class FetchMostPlayedGameListEvent extends MostPlayedGameListEvent {}

class MostPlayedGameListBloc
    extends Bloc<MostPlayedGameListEvent, MostPlayedGameListState> {
  MostPlayedGameListBloc() : super(_getInitState()) {
    on<FetchMostPlayedGameListEvent>(_onFetchList);
  }

  static MostPlayedGameListState _getInitState() {
    MostPlayedGameListState state = Loading();
    return state;
  }
}

Future<void> _onFetchList(event, emit) async {
  final response = await http.get(Uri.parse(
      'https://api.steampowered.com/ISteamChartsService/GetMostPlayedGames/v1/'));
  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final gameIds = jsonResponse['response']['ranks']
        .map<int>((game) => game['appid'] as int)
        .toList();

    final gamesList = <Game>[];
    for (final id in gameIds) {
      final gameResponse = await http.get(Uri.parse(
          'https://store.steampowered.com/api/appdetails?appids=$id&cc=fr'));
      if (gameResponse.statusCode == 200) {
        final gameJsonResponse = jsonDecode(gameResponse.body);
        String idToS = id.toString();
        final gameData = gameJsonResponse['$idToS']['data'];
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
          gamesList.add(game);
        }
      }
    }
    final state = Success(gamesList);
    emit(state);
  } else {
    final state = ErrorFetch();
    emit(state);
  }
}

class Game {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final String longDescription;
  final String firstScreenshotUrl;
  final String firstBundlePrice;
  final List<String> developers;

  Game({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.longDescription,
    required this.firstScreenshotUrl,
    required this.firstBundlePrice,
    required this.developers,
  });
}