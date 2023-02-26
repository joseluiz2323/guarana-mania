import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guarana_mania/global/color_global.dart';
import 'package:guarana_mania/model/produtos.dart';
import 'package:guarana_mania/src/cadastro_de_estoque/produto_edit_add.dart';
import 'package:guarana_mania/utils/extensions.dart';

class HomeEstoque extends StatelessWidget {
  const HomeEstoque({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: ColorGlobal.colorsbackground,
        title: const Text(
          'Cadastro De Produtos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('produtos')
            .orderBy('tipo')
            .orderBy('nome')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar produtos'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final produtos = snapshot.data?.docs ?? [];
          if (produtos.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado'));
          }
          return ListView.builder(
            itemCount: produtos.length + 1,
            itemBuilder: (_, index) {
              if (index == produtos.length) {
                return const SizedBox(height: 80);
              }
              final produtoData = produtos[index];
              final produto = Produto.fromJson(
                produtoData.data(),
              );
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(produto.nome),
                        Text(
                          'Tipo:${produto.tipo}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(produto.unitario.formatted),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          child: const Icon(
                            Icons.delete,
                            color: ColorGlobal.colorsbackground,
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text('Remover produto'),
                                  content:
                                      const Text('Deseja remover o produto?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Sim'),
                                      onPressed: () {
                                        produtoData.reference.delete();
                                        Navigator.pop(ctx);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Não'),
                                      onPressed: () => Navigator.pop(ctx),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProdutoEditAdd(
                            id: produtoData.id,
                            produto: produto,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorGlobal.colorsbackground,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ProdutoEditAdd()),
          );
        },
        label: const Text('Adicionar produto'),
      ),
    );
  }
}
