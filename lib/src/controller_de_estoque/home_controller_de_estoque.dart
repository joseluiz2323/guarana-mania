import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:guarana_mania/model/produtos.dart';

import '../../global/color_global.dart';
import '../../pdf/estoque_pdf.dart';

import 'add_estoque.dart';

class HomeContollerDeEstoque extends StatefulWidget {
  const HomeContollerDeEstoque({Key? key}) : super(key: key);

  @override
  State<HomeContollerDeEstoque> createState() => _HomeContollerDeEstoqueState();
}

class _HomeContollerDeEstoqueState extends State<HomeContollerDeEstoque> {
  List<Produto> produtosmod = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>> prdoutos =
        FirebaseFirestore.instance
            .collection('produtos')
            .orderBy('tipo')
            .orderBy('nome')
            .snapshots()
            .listen((data) {
      for (var doc in data.docs) {
        produtosmod.add(Produto.fromJson(doc.data()));
      }
    });
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Controle de estoque'),
        centerTitle: true,
        backgroundColor: ColorGlobal.colorsbackground,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EstoquePdf(
                    produtosPedido: produtosmod,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('produtos')
              .orderBy('tipo')
              .orderBy('nome')
              .snapshots(),
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
                produtosmod.add(produto);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Card(
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produto.nome,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            produto.tipo,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'quantidade: ${produto.estoque!.toInt()}',
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
                  ), //sa
                );
              },
            );
          },
        ),
      ),
    );
  }
}
