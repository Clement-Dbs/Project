import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/gameListBloc.dart';

class GameLike {
  final int id;
  final String name;
  final String imageUrl;
  final String firstBundlePrice;
  final List<String> developers;

  GameLike({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.firstBundlePrice,
    required this.developers,
  });
}

abstract class LikeManagementState {}
class FetchLikeFull extends LikeManagementState {
  final List<GameLike> gamesList;
  FetchLikeFull(this.gamesList);
}
class FetchLikeEmpty extends LikeManagementState {}
class ErrorFetchLike extends LikeManagementState {}
class PostLike extends LikeManagementState {}
class PostLikeAlready extends LikeManagementState {}
class ErrorLike extends LikeManagementState {}
class InitStateLike extends LikeManagementState {}
class FetchGameLike extends LikeManagementState {
  final Game gameFetch;
  FetchGameLike(this.gameFetch);
}
class FetchGameLikeNormal extends LikeManagementState {}

abstract class LikeManagementEvent {}
class FetchLikeEvent extends LikeManagementEvent {}
class ResetStateEvent extends LikeManagementEvent {}
class PostLikeEvent extends LikeManagementEvent {
  final int id;
  PostLikeEvent(this.id);
}
class DeleteLikeEvent extends LikeManagementEvent {}
class FetchGameLikeEvent extends LikeManagementEvent {
  final int id;
  FetchGameLikeEvent(this.id);
}

class LikeManagementBloc extends Bloc<LikeManagementEvent, LikeManagementState> {
  LikeManagementBloc() : super(_getInitState()) {
    on<FetchLikeEvent>(_onFetchLike);
    on<ResetStateEvent>(_onResetStateLike);
    on<PostLikeEvent>(_onPostLike);
    on<DeleteLikeEvent>(_onDeleteLike);
    on<FetchGameLikeEvent>(_onFetchGameLike);
  }

  static LikeManagementState _getInitState() {
    final state = InitStateLike();
    return state;
  }
}

Future<void> _onResetStateLike(event, emit) async {
  final state = InitStateLike();
  emit(state);
}

Future<void> _onFetchLike(event, emit) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  final gamesList = <GameLike>[];

  if (currentUser != null) {
    final likesCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .collection("likes");

    final likesSnapshot = await likesCollection.get();
    final likes = likesSnapshot.docs.map((doc) => doc.get("postId").toInt()).toList();

    for (var id in likes) {
      final response = await http.get(Uri.parse(
          'https://store.steampowered.com/api/appdetails?appids=$id&cc=fr'));
      if (response.statusCode == 200) {
        final gameJsonResponse = jsonDecode(response.body);
        String idToS = id.toString();
        final gameData = gameJsonResponse['$idToS']['data'];
        if (gameData != null) {
          final game = GameLike(
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
    final state = gamesList.isEmpty ? FetchLikeEmpty() : FetchLikeFull(gamesList);
    emit(state);

  } else {
    final state = ErrorFetchLike();
    emit(state);
  }
}

Future<void> _onPostLike(event, emit) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final uid = user.uid;
    final postId = (event as PostLikeEvent).id;

    // Vérifier si une entrée avec le même postId existe déjà
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('likes')
        .where('postId', isEqualTo: postId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final state = PostLikeAlready();
      emit(state);
    }
    else{
      // Aucune entrée avec ce postId, ajouter une nouvelle entrée
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('likes')
          .add({
        'postId': postId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      final state = PostLike();
      emit(state);
    }
  } else {
    final state = ErrorLike();
    emit(state);
  }
}

Future<void> _onDeleteLike(event, emit) async {
  final state = InitStateLike();
  emit(state);
}

Future<void> _onFetchGameLike(event, emit) async {
  int id = (event as FetchGameLikeEvent).id;

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
      final state = FetchGameLike(game);
      emit(state);
    }
  }
  else {
    final state = FetchGameLikeNormal();
    emit(state);
  }
}