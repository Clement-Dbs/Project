import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a2025),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Inscription',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 32.0,
                    color: Colors.white,
                  ),
                ),
                Align(
                  child: Container(
                    margin: const EdgeInsets.only(top:5, bottom:15),
                    child: const SizedBox(
                      width: 275,
                      child: Text(
                        "Veuillez saisir ces différentes informations, afin que vos listes soient sauvegardées.",
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
                    margin: const EdgeInsets.only(top:8, bottom:5),
                    child: SizedBox(
                      height: 40.0,
                      width: 300,
                      child: TextFormField(
                        cursorColor: Colors.white,
                        controller: nameController,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF1e262c),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          label: Center(
                            child: Text(
                              "Nom d'utilisateur",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w300,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF1e262c), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF1e262c), width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  child: Container(
                    margin: const EdgeInsets.only(top:8, bottom:5),
                    child: SizedBox(
                      height: 40.0,
                      width: 300,
                      child: TextFormField(
                        cursorColor: Colors.white,
                        controller: emailController,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF1e262c),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          label: Center(
                            child: Text(
                              "E-mail",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w300,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF1e262c), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF1e262c), width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  child: Container(
                    margin: const EdgeInsets.only(top:5),
                    child: SizedBox(
                      height: 40.0,
                      width: 300,
                      child: TextFormField(
                        cursorColor: Colors.white,
                        controller: passwordController,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          filled: true,
                          fillColor: Color(0xFF1e262c),
                          label: Center(
                            child: Text(
                              "Mot de Passe",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w300,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF1e262c), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF1e262c), width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  child: Container(
                    margin: const EdgeInsets.only(top:60),
                    child: SizedBox(
                      height: 40.0,
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () async {
                          String nameVerif = nameController.value.text;

                          String emailVerif = emailController.value.text;
                          bool isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailVerif);
                          if (!isEmailValid) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Erreur'),
                                  content: Text("L'e-mail n'est pas de la forme: -----@-----.--"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }

                          String passwordVerif = passwordController.value.text;
                          String errorMessage = '';
                          if (passwordVerif.length < 8 || !passwordVerif.contains(new RegExp(r'[A-Z]')) || !passwordVerif.contains(new RegExp(r'[0-9]')) || !passwordVerif.contains(new RegExp(r'[!@#\$&*~?]'))) {
                            errorMessage += ' Le mot de passe doit contenir au moins: '
                                '- 8 caractères '
                                '- une majuscule '
                                '- un chiffre '
                                '- un caractère spécial.';
                          }
                          if (errorMessage.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Erreur'),
                                  content: Text(errorMessage),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }

                          try {
                            final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: emailVerif,
                              password: passwordVerif,
                            );

                            final firestoreInstance = FirebaseFirestore.instance;
                            await firestoreInstance.collection("users").doc(credential.user?.uid).set({
                              "name": nameVerif,
                              "email": emailVerif,
                            });

                            Navigator.pop(context);

                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                            } else if (e.code == 'email-already-in-use') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Erreur'),
                                    content: Text('Cet email existe déjà.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF636af6)),
                        ),
                        child: const Text(
                          "S'inscrire",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w300,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}