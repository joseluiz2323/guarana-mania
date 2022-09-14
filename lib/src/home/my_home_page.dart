import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guarana_mania/src/produtos/home_produtos.dart';
import 'package:guarana_mania/src/vendas/home_vendas.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global/color_global.dart';
import '../../global/login_data.dart';
import '../../model/atualizacao.dart';
import '../cadastro_de_estoque/home_cadastro_de_estoque.dart';
import '../controller_de_estoque/home_controller_de_estoque.dart';
import '../relatorio_de_vendas/home_relatorio.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? link;
  bool isSwitched = false;
  Future<bool> atualizacaovery() async {
    final atualizacaoRef =
        await FirebaseFirestore.instance.collection('atualizacao').get();
    if (atualizacaoRef.docs.isNotEmpty) {
      final atualizacaoData = atualizacaoRef.docs.first.data();
      final atualizacao = Atualizacao.fromJson(atualizacaoData);

      if (atualizacao.verification) {
        link = atualizacao.link;
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    atualizacaovery().then(
      (_) {
        if (link != null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Atualização Disponível"),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text("Atualizar"),
                    onPressed: () async {
                      final url = link ?? '';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                      final atualizacaoRef =
                          FirebaseFirestore.instance.collection('atualizacao');
                      await atualizacaoRef.doc('jZ5hhk9p5kEZXztli8XE').update({
                        'verification': false,
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              scale: 3,
            ),
            Center(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  LoginData().isAdmin
                      ? buthonHomePage(
                          size,
                          'Cadastra produto',
                          'estoque-pronto',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeEstoque(),
                              ),
                            );
                          },
                        )
                      : const SizedBox(),
                  LoginData().isAdmin
                      ? buthonHomePage(
                          size,
                          'Contole de estoque',
                          'estoque',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const HomeContollerDeEstoque(),
                              ),
                            );
                          },
                        )
                      : const SizedBox(),
                  buthonHomePage(
                    size,
                    'Vendas',
                    'cart',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeVendas(),
                        ),
                      );
                    },
                  ),
                  buthonHomePage(
                    size,
                    'Produtos',
                    'package',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeProdutos(),
                        ),
                      );
                    },
                  ),
                  LoginData().isAdmin
                      ? buthonHomePage(
                          size,
                          'Relatorio de Vendas',
                          'report',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeRelatorio(),
                              ),
                            );
                          },
                        )
                      : Container(),
                  Card(
                    color: const Color.fromARGB(255, 220, 180, 226),
                    child: SizedBox(
                      height: 200,
                      width: 190,
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('status')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('Erro ao carregar produtos'),
                            );
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                isSwitched ? 'ABERTO' : 'FECHADO',
                                style: TextStyle(
                                  color: isSwitched ? Colors.green : Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Situção da loja',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Switch(
                                value: isSwitched,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched = value;
                                    FirebaseFirestore.instance
                                        .collection('status')
                                        .doc('GIMTdFGton7oPKEQGDY5')
                                        .update({
                                      'status': isSwitched,
                                    });
                                  });
                                },
                                activeTrackColor: Colors.lightGreenAccent,
                                activeColor: Colors.green,
                              ),
                              Text(
                                'Visitas: ${snapshot.data!.docs.first.data()['count']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('status')
                                          .doc('GIMTdFGton7oPKEQGDY5')
                                          .update({
                                        'count': 0,
                                      });
                                    },
                                    child: const Text('Zerar'),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buthonHomePage(
    size,
    String text,
    String imagen, {
    required Function onPressed,
  }) {
    bool cant = false;
    if (imagen == 'report' || imagen == 'cart') {
      cant = true;
    }
    return GestureDetector(
      onTap: () => onPressed(),
      child: Card(
        color: ColorGlobal.colorsbackground,
        child: SizedBox(
          height: 200,
          width: 190,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Image.asset(
                        'assets/icons_menu/$imagen.png',
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: FittedBox(
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
