import 'package:flutter/material.dart';

import 'package:guarana_mania/src/produtos/home_produtos.dart';
import 'package:guarana_mania/src/vendas/home_vendas.dart';

import '../../global/color_global.dart';
import '../../global/login_data.dart';
import '../cadastro_de_estoque/home_cadastro_de_estoque.dart';
import '../controller_de_estoque/home_controller_de_estoque.dart';
import '../relatorio_de_vendas/home_relatorio.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Guaraná-mania',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: ColorGlobal.colorsbackground,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoginData().isAdmin
              ? roww(
                  buthonHomePage(
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
                  ),
                  buthonHomePage(
                    size,
                    'Contole de estoque',
                    'estoque',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeContollerDeEstoque(),
                        ),
                      );
                    },
                  ),
                )
              : Container(),
          const SizedBox(height: 20),
          roww(
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
          ),
          const SizedBox(height: 20),
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
        ],
      ),
    );
  }

  Widget roww(widget1, widget2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        widget1,
        widget2,
      ],
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
