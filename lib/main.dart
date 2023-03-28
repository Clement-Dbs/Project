import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/firebase_options.dart';
import 'package:project/pageConnexion.dart';
import 'package:project/PageCreationCompte.dart';
import 'package:project/pageMenu.dart';
import 'package:project/pagePassOublié.dart';
import 'package:project/navigatorBloc.dart';
import 'package:project/gameListBloc.dart';
import 'package:project/likeBloc.dart';
import 'package:project/pageLike.dart';
import 'package:project/pageFav.dart';
import 'package:project/favBloc.dart';
import 'package:project/searchBloc.dart';
import 'package:project/searchAddedBloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MostPlayedGameListBloc>(
            create: (context) => MostPlayedGameListBloc(),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(),
          ),
          BlocProvider<LikeManagementBloc>(
            create: (context) => LikeManagementBloc(),
          ),
          BlocProvider<FavManagementBloc>(
            create: (context) => FavManagementBloc(),
          ),
          BlocProvider<SearchBarBloc>(
            create: (context) => SearchBarBloc(),
          ),
          BlocProvider<SearchAddedBarBloc>(
            create: (context) => SearchAddedBarBloc(),
          ),
        ],
      child:MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Steam Like App',
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/createaccount': (context) => CreateAccountPage(),
          '/menu': (context) => MenuPage(),
          '/passforget': (context) => PassForgetPage(),
          '/likes': (context) => LikePage(),
          '/favorites': (context) => FavPage(),
        },
      )
    );
  }
}

