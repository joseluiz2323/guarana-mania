import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../components/text_field_custom.dart';
import '../../../global/login_data.dart';
import '../../../model/usuarios.dart';
import '../../../utils/shared_preferences.dart';
import '../home/my_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  Future<void> login() async {
    final usuariosRef = await FirebaseFirestore.instance
        .collection('login')
        .where('user', isEqualTo: loginController.text)
        .where('pass', isEqualTo: senhaController.text)
        .get();
    if (usuariosRef.docs.isNotEmpty) {
      final userData = usuariosRef.docs.first.data();
      final user = Usuarios.fromJson(userData);
      LoginData().setUser(user);
    }
  }

  @override
  void initState() {
    lerisLogged().then(
      (logged) async {
        loginController.text = logged[0];
        senhaController.text = logged[1];
        Future.delayed(
          const Duration(seconds: 1),
          () {
            login().then(
              (value) {
                if (LoginData().logged) {
                  gravarisLogged(loginController.text, senhaController.text);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MyHomePage()),
                    (route) => false,
                  );
                }
              },
            );
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icon.png',
                  width: 200,
                ),
                TextFieldCustom(
                  label: 'Usuário',
                  controller: loginController,
                ),
                TextFieldCustom(
                  label: 'Senha',
                  obscure: true,
                  controller: senhaController,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  child: const SizedBox(
                    height: 50,
                    width: 120,
                    child: Center(
                      child: Text('Login'),
                    ),
                  ),
                  onPressed: () {
                    login().then(
                      (value) {
                        if (LoginData().logged) {
                          gravarisLogged(
                            loginController.text,
                            senhaController.text,
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MyHomePage()),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Usuário ou senha inválidos'),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
