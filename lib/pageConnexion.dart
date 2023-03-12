import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a2025),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Bienvenue !',
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
                  width: 180,
                  child: Text(
                    "Veuillez vous connecter ou créer un nouveau compte pour utiliser l'application.",
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
                margin: const EdgeInsets.only(top:5),
                child: SizedBox(
                  height: 40.0,
                  width: 300,
                  child: TextFormField(
                    cursorColor: Colors.white,
                    controller: passwordController,
                    obscureText: _obscureText,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                          size: 15,
                        ),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: _toggleObscureText,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: const Color(0xFF1e262c),
                      label: const Padding(
                        padding: EdgeInsets.only(left:100),
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
            Align(
              child: Container(
                margin: const EdgeInsets.only(top:60),
                child: SizedBox(
                  height: 40.0,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.value.text,
                            password: passwordController.value.text,
                        );
                        Navigator.pushReplacementNamed(context, '/menu');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF636af6)),
                    ),
                    child: const Text(
                      'Se connecter',
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
            Align(
              child: Container(
                margin: const EdgeInsets.only(top:10),
                child: SizedBox(
                  height: 40.0,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/createaccount');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF1a2025)),
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Color(0xFF636af6), width: 2),
                      ),
                    ),
                    child: const Text(
                      'Créer un nouveau compte',
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
            Align(
              child: Container(
                margin: const EdgeInsets.only(top:120),
                child: SizedBox(
                  height: 20.0,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/passforget');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF1a2025)),
                    ),
                    child: const Text(
                      'Mot de passe oublié',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
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
      ),
    );
  }
}
