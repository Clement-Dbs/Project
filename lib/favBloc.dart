import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/gameListBloc.dart';

class GameFav {
  final int id;
  final String name;
  final String imageUrl;
  final String firstBundlePrice;
  final List<String> developers;

  GameFav({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.firstBundlePrice,
    required this.developers,
  });
}

abstract class FavManagementState {}
class FetchFavFull extends FavManagementState {
  final List<GameFav> gamesList;
  FetchFavFull(this.gamesList);
}
class FetchFavEmpty extends FavManagementState {}
class ErrorFetchFav extends FavManagementState {}
class PostFav extends FavManagementState {}
class PostFavAlready extends FavManagementState {}
class ErrorFav extends FavManagementState {}
class InitStateFav extends FavManagementState {}
class FetchGameFav extends FavManagementState {
  final Game gameFetch;
  FetchGameFav(this.gameFetch);
}
class FetchGameFavNormal extends FavManagementState {}
class DeleteSuccess extends FavManagementState {}
class DeleteError extends FavManagementState {}

abstract class FavManagementEvent {}
class FetchFavEvent extends FavManagementEvent {}
class ResetStateEventFav extends FavManagementEvent {}
class PostFavEvent extends FavManagementEvent {
  final int id;
  PostFavEvent(this.id);
}
class DeleteFavEvent extends FavManagementEvent {
  final int id;
  DeleteFavEvent(this.id);
}
class FetchGameFavEvent extends FavManagementEvent {
  final int id;
  FetchGameFavEvent(this.id);
}

class FavManagementBloc extends Bloc<FavManagementEvent, FavManagementState> {
  FavManagementBloc() : super(_getInitState()) {
    on<FetchFavEvent>(_onFetchFav);
    on<ResetStateEventFav>(_onResetStateFav);
    on<PostFavEvent>(_onPostFav);
    on<DeleteFavEvent>(_onDeleteFav);
    on<FetchGameFavEvent>(_onFetchGameFav);
  }

  static FavManagementState _getInitState() {
    final state = InitStateFav();
    return state;
  }
}

Future<void> _onResetStateFav(event, emit) async {
  final state = InitStateFav();
  emit(state);
}

Future<void> _onFetchFav(event, emit) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  final gamesList = <GameFav>[];

  if (currentUser != null) {
    final FavsCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .collection("Favs");

    final FavsSnapshot = await FavsCollection.get();
    final Favs = FavsSnapshot.docs.map((doc) => doc.get("postId").toInt()).toList();

    for (var id in Favs) {
      final response = await http.get(Uri.parse(
          'https://store.steampowered.com/api/appdetails?appids=$id&cc=fr'));
      if (response.statusCode == 200) {
        final gameJsonResponse = jsonDecode(response.body);
        String idToS = id.toString();
        final gameData = gameJsonResponse['$idToS']['data'];
        if (gameData != null) {
          final game = GameFav(
            id: gameData['steam_appid'] as int,
            name: gameData['name'] as String,
            imageUrl: gameData['header_image'] as String,
            firstBundlePrice: gameData['package_groups'] != null &&
                gameData['package_groups'].isNotEmpty
                ? ((gameData['package_groups'][0]['subs'][0]['price_in_cents_with_discount'] as int) /
                100)
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
    final state = gamesList.isEmpty ? FetchFavEmpty() : FetchFavFull(gamesList);
    emit(state);

  } else {
    final state = ErrorFetchFav();
    emit(state);
  }
}

Future<void> _onPostFav(event, emit) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final uid = user.uid;
    final postId = (event as PostFavEvent).id;

    // Vérifier si une entrée avec le même postId existe déjà
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Favs')
        .where('postId', isEqualTo: postId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final state = PostFavAlready();
      emit(state);
    }
    else{
      // Aucune entrée avec ce postId, ajouter une nouvelle entrée
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('Favs')
          .add({
        'postId': postId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      final state = PostFav();
      emit(state);
    }
  } else {
    final state = ErrorFav();
    emit(state);
  }
}

Future<void> _onDeleteFav(event, emit) async {
  int id = (event as DeleteFavEvent).id;
  final user = FirebaseAuth.instance.currentUser;

  if(user != null){
    CollectionReference likesRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('Favs');
    QuerySnapshot snapshot = await likesRef.where('postId', isEqualTo: id).get();
    snapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
    final state = DeleteSuccess();
    emit(state);
  }
  else{
    final state = DeleteError();
    emit(state);
  }
}

Future<void> _onFetchGameFav(event, emit) async {
  int id = (event as FetchGameFavEvent).id;

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
      final state = FetchGameFav(game);
      emit(state);
    }
  }
  else {
    final state = FetchGameFavNormal();
    emit(state);
  }
}