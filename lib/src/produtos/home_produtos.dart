import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grouped_list/grouped_list.dart';

import 'package:guarana_mania/components/text_field_custom.dart';
import 'package:guarana_mania/global/color_global.dart';
import 'package:guarana_mania/model/produtos.dart';
import 'package:guarana_mania/utils/extensions.dart';

import '../../model/pedidos.dart';

class HomeProdutos extends StatefulWidget {
  const HomeProdutos({Key? key}) : super(key: key);

  @override
  State<HomeProdutos> createState() => _HomeProdutosState();
}

class _HomeProdutosState extends State<HomeProdutos> {
  List<Produto> produtosPedido = [];
  TextEditingController mesaController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  int count = 0;

  void increment() {
    setState(() {
      count++;
    });
  }

  void decrement() {
    if (count > 0) {
      setState(() {
        count--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: ColorGlobal.colorsbackground,
        title: const Text('Adicionar Pedido'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Material(
            elevation: 100.0,
            child: SizedBox(
              width: double.infinity,
              height: 80,
              child: Column(
                children: [
                  Expanded(
                    child: TextFieldCustom(
                      label: 'Utilização',
                      keyboardType: TextInputType.text,
                      controller: mesaController,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 100,
              child: Card(
                child: Center(
                  child: ListTile(
                    title: const Text('Sangria'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            color: ColorGlobal.colorsbackground,
                            onPressed: () {
                              decrement();
                            },
                            child:
                                const Icon(Icons.remove, color: Colors.white),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 120,
                          child: Text(
                            count.toDouble().formatted,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            color: ColorGlobal.colorsbackground,
                            onPressed: () {
                              increment();
                            },
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 18),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance.collection('produtos').snapshots(),
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
                final produtos = snapshot.data?.docs ?? [];
                //remover tipo de produtos
                final produtosFiltrados = produtos.where((produto) {
                  return produto.data()['classe'] == 'notfood';
                }).toList();
                print(produtosFiltrados);
                return GroupedListView<dynamic, String>(
                  elements: produtosFiltrados,
                  groupBy: (element) => element.data()['tipo'],
                  groupComparator: (value1, value2) => value2.compareTo(value1),
                  itemComparator: (item1, item2) =>
                      item1['tipo'].compareTo(item2['tipo']),
                  order: GroupedListOrder.DESC,
                  useStickyGroupSeparators: true,
                  groupSeparatorBuilder: (String value) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        value.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                  itemBuilder: (c, element) {
                    final produtoData = element;
                    final produto = Produto.fromJson(produtoData.data());
                    final quantidade =
                        produtosPedido.where((p) => p == produto).length;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        child: ListTile(
                          title: Text(produto.nome),
                          subtitle: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(produto.estoque.toInt().toString()),
                              Text(produto.unitario.formatted),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  color: ColorGlobal.colorsbackground,
                                  onPressed: () {
                                    setState(() {
                                      final i = produtosPedido.indexOf(produto);
                                      if (i != -1) {
                                        produtosPedido.removeAt(i);
                                      }
                                    });
                                  },
                                  child: const Icon(Icons.remove,
                                      color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  quantidade.toString(),
                                  style: const TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              AspectRatio(
                                aspectRatio: 1,
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  color: ColorGlobal.colorsbackground,
                                  onPressed: () {
                                    //verificar quantos produto esxiste em produtosPedido
                                    int i = produtosPedido
                                        .where((p) => p == produto)
                                        .length;

                                    if (i < produto.estoque.toDouble()) {
                                      setState(() {
                                        produtosPedido.add(produto);
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final pedido2 = Produto(
            nome: mesaController.text,
            estoque: 0,
            unitario: count.toDouble(),
            tipo: 'sanguia',
            classe: 'notfood',
          );
          produtosPedido.add(pedido2);
          final unique = produtosPedido.toSet().toList();
          final produtos = unique
              .map((p) => ProdutoPedido(
                    nome: p.nome,
                    tipo: 'Estoque',
                    qtde: double.parse(produtosPedido
                        .where((p2) => p2 == p)
                        .length
                        .toString()),
                    unitario: p.unitario,
                  ))
              .toList();
          final pedido = Pedidos(
            nome: mesaController.text,
            pagamento: 'Estoque',
            data: DateTime.now(),
            produtos: produtos,
          );
          final data = pedido.toJson();

          FirebaseFirestore.instance
              .collection('pedidos')
              .add(data)
              .then((value) => {
                    Navigator.pop(context),
                  });
        },
        label: const Padding(
          padding: EdgeInsets.only(right: 40, left: 40),
          child: Text('Salvar'),
        ),
      ),
    );
  }
}
