import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CState {}
class Registration extends CState {}
class RegistrationError extends CState{}
class RegistrationEmailError extends CState{}
class RegistrationPassError extends CState{
  String? errorMessage;
  RegistrationPassError(this.errorMessage);
}
class Connexion extends CState {
  User? user = FirebaseAuth.instance.currentUser;
  Connexion(this.user);
}
class Deconnexion extends CState {}
class Error extends CState{}

abstract class UserEvent{}
class ConnectUserEvent extends UserEvent {
  final String email;
  final String password;
  ConnectUserEvent(this.email, this.password);
}
class DisconnectUserEvent extends UserEvent{}
class RegistrationUserEvent extends UserEvent{
  final String name;
  final String email;
  final String password;
  RegistrationUserEvent(this.name, this.email, this.password);
}

class UserBloc extends Bloc<UserEvent, CState>{
  UserBloc() : super(_getInitState()) {
    on<ConnectUserEvent>(_onConnect);
    on<DisconnectUserEvent>(_onDisconnect);
    on<RegistrationUserEvent>(_onRegistration);
  }

  static CState _getInitState() {
    if (FirebaseAuth.instance.currentUser == null) {
      CState state = Deconnexion();
      return state;
    }
    else {
      CState state = Connexion(FirebaseAuth.instance.currentUser);
      return state;
    }
  }
}

Future<void> _onConnect(event, emit) async {
  (event as ConnectUserEvent).email;
  (event as ConnectUserEvent).password;
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );
    CState state = Connexion(FirebaseAuth.instance.currentUser);
    emit(state);
    //Navigator.pushReplacementNamed(context, '/menu');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      CState state = Error();
      emit(state);
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      CState state = Error();
      emit(state);
      print('Wrong password provided for that user.');
    }
  }
}

Future<void> _onDisconnect(event, emit) async {
  await FirebaseAuth.instance.signOut();
  CState state = Deconnexion();
  emit(state);
}

Future<void> _onRegistration(event, emit) async {
  (event as RegistrationUserEvent).email;
  (event as RegistrationUserEvent).password;
  (event as RegistrationUserEvent).name;

  bool isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(event.email);
  if(!isEmailValid){
    CState state = RegistrationEmailError();
    emit(state);
  }

  String passwordVerif = event.password;
  String errorMessage = '';
  if (passwordVerif.length < 8 || !passwordVerif.contains(RegExp(r'[A-Z]')) || !passwordVerif.contains(RegExp(r'[0-9]')) || !passwordVerif.contains(RegExp(r'[!,@#\$&*~?]'))) {
    errorMessage += ' Le mot de passe doit contenir au moins: '
        '- 8 caractères '
        '- une majuscule '
        '- un chiffre '
        '- un caractère spécial.';
  }
  if (errorMessage.isNotEmpty) {
    CState state = RegistrationPassError(errorMessage);
    emit(state);
  }

  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );

    final firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance.collection("users").doc(credential.user?.uid).set({
      "name": event.name,
      "email": event.email,
    });
    CState state = Registration();
    emit(state);
  }
  on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
    } else if (e.code == 'email-already-in-use') {
      CState state = RegistrationError();
      emit(state);
    }
  }
}