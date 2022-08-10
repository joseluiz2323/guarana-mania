import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guarana_mania/model/produtos.dart';

import '../../global/color_global.dart';

import 'add_estoque.dart';

class HomeContollerDeEstoque extends StatelessWidget {
  const HomeContollerDeEstoque({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Controle de estoque'),
        centerTitle: true,
        backgroundColor: ColorGlobal.colorsbackground,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('produtos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar estoque'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final estoque = snapshot.data?.docs ?? [];
          if (estoque.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado'));
          }
          // ignore: newline-before-return
          return ListView.builder(
            itemCount: estoque.length + 1,
            itemBuilder: (_, index) {
              if (index == estoque.length) {
                return const SizedBox(height: 90);
              }
              final produtoData = estoque[index];
              final produto = Produto.fromJson(
                produtoData.data(),
              );

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(produto.nome),
                        Text(
                          '${produto.tipo} ',
                        ),
                        Text(
                          'quantidade: ${produto.estoque.toInt()}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EstoqueEditAdd(
                            id: produtoData.id,
                            produto: produto,
                          ),
                        ), //as
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
