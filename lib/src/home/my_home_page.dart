import 'package:flutter/material.dart';

import 'package:guarana_mania/src/vendas/home_vendas.dart';

import '../../global/color_global.dart';
import '../cadastro_de_estoque/home_cadastro_de_estoque.dart';
import '../controller_de_estoque/home_controller_de_estoque.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // ignore: newline-before-return
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
              ],
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
    return GestureDetector(
      onTap: () => onPressed(),
      child: Card(
        color: ColorGlobal.colorsbackground,
        child: SizedBox(
          height: size.height * 0.2,
          width: size.width * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/icons_menu/$imagen.png',
                color: Colors.white,
                width: size.width * 0.2,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
