import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Exactement le même fonctionnement pour les favoris donc il suffira de copier le tout
abstract class LikeManagementState {}
class FetchLikeFull extends LikeManagementState {} //ce state sera pour afficher les likes si la liste n'est pas vide dans le BlocBuilder
class FetchLikeEmpty extends LikeManagementState {} //ce state sera pour afficher la page vide si pas de like dans le BlocBuilder
class ErrorFetchLike extends LikeManagementState {}
class PostLike extends LikeManagementState {}
class ErrorLike extends LikeManagementState {}

abstract class LikeManagementEvent {}
class FetchLikeEvent extends LikeManagementEvent {}
class PostLikeEvent extends LikeManagementEvent {
  final int id;
  PostLikeEvent(this.id);
}

class LikeManagementBloc extends Bloc<LikeManagementEvent, LikeManagementState> {
  LikeManagementBloc() : super(_getInitState()) {
    on<FetchLikeEvent>(_onFetchLike);
    on<PostLikeEvent>(_onPostLike);
  }

  static LikeManagementState _getInitState() {
    LikeManagementState state = FetchLikeEmpty();
    return state;
  }
}

Future<void> _onFetchLike(event, emit) async {

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
      // Une entrée avec ce postId existe déjà, ne rien faire
      return;
    }

    // Aucune entrée avec ce postId, ajouter une nouvelle entrée
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('likes')
        .add({
      'postId': postId,
      'createdAt': FieldValue.serverTimestamp(),
    });
    LikeManagementState state = PostLike();
    emit(state);
  } else {
    LikeManagementState state = ErrorLike();
    emit(state);
  }
}