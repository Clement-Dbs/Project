import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PassForgetPage extends StatefulWidget {
  const PassForgetPage({Key? key}) : super(key: key);
  @override
  _PassForgetPageState createState() => _PassForgetPageState();
}

class _PassForgetPageState extends State<PassForgetPage> {
  final TextEditingController emailController = TextEditingController();

  Future<void> sendPasswordResetEmail(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Afficher une alerte indiquant que l'e-mail a été envoyé
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('E-mail envoyé'),
            content: Text('Un e-mail contenant un lien pour réinitialiser votre mot de passe a été envoyé à $email.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text('L\'adresse e-mail $email n\'est associée à aucun compte.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

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
                  'Mot de passe oublié',
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
                    margin: const EdgeInsets.only(top:10, bottom:15),
                    child: const SizedBox(
                      width: 190,
                      child: Text(
                        "Veuillez saisir votre email afin de réinitialiser votre mot de passe",
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
                    margin: const EdgeInsets.only(top:10),
                    child: SizedBox(
                      height: 40.0,
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () async {
                          await sendPasswordResetEmail(context, emailController.value.text);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF636af6)),
                        ),
                        child: const Text(
                          'Renvoyer e-mail',
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
