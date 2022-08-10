import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:guarana_mania/components/text_field_custom.dart';
import 'package:guarana_mania/global/color_global.dart';
import 'package:guarana_mania/model/produtos.dart';
import 'package:guarana_mania/src/vendas/finalizar_pedido.dart';
import 'package:guarana_mania/utils/extensions.dart';

class HomeVendas extends StatefulWidget {
  const HomeVendas({Key? key}) : super(key: key);

  @override
  State<HomeVendas> createState() => _HomeVendasState();
}

class _HomeVendasState extends State<HomeVendas> {
  List<Produto> produtosPedido = [];
  TextEditingController mesaController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  List<String> pagamentList = [
    "Dinheiro",
    "Pix",
    "Cartão de Débito",
    "Cartão de Crédito",
  ];

  String formadePagamento = 'Dinheiro';

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
              child: Row(
                children: [
                  Expanded(
                    child: TextFieldCustom(
                      label: 'Cliente',
                      keyboardType: TextInputType.text,
                      controller: mesaController,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: ColorGlobal.colorsbackground,
                      border: Border.all(
                        color: Colors.black38,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 8,
                        bottom: 7,
                      ),
                      child: DropdownButton(
                        value: formadePagamento,
                        items: pagamentList.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            formadePagamento = value ?? 'Dinheiro';
                          });
                        },
                        icon: const Padding(
                          padding: EdgeInsets.only(
                            left: 5,
                          ),
                          child: Icon(
                            Icons.payment,
                          ),
                        ),
                        iconEnabledColor: Colors.white,
                        underline: const SizedBox(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        elevation: 24,
                        dropdownColor: ColorGlobal.colorsbackground,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 18),
          Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('produtos')
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
                    final produtos = snapshot.data?.docs ?? [];
                    return GroupedListView<dynamic, String>(
                      elements: produtos,
                      groupBy: (element) => element.data()['tipo'],
                      groupComparator: (value1, value2) =>
                          value2.compareTo(value1),
                      itemComparator: (item1, item2) =>
                          item1['tipo'].compareTo(item2['tipo']),
                      order: GroupedListOrder.DESC,
                      useStickyGroupSeparators: true,
                      groupSeparatorBuilder: (String value) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          value.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
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
                                    child: FloatingActionButton(
                                      child: const Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          final i =
                                              produtosPedido.indexOf(produto);
                                          if (i != -1) {
                                            produtosPedido.removeAt(i);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
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
                                    child: FloatingActionButton(
                                      onPressed: () {
                                        setState(() {
                                          produtosPedido.add(produto);
                                        });
                                      },
                                      child: const Icon(Icons.add),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  })),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Produtos: ${produtosPedido.length}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Total: ${produtosPedido.fold<double>(0, (total, p) => total + p.unitario).formatted}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: produtosPedido.isEmpty
            ? null
            : () async {
                showDialog(
                  context: context,
                  builder: (BuildContext cxt) {
                    return WidgetFinalizarPedido(
                      produtosPedido: produtosPedido,
                      cliente: mesaController.text,
                      formadePagamento: formadePagamento,
                    );
                  },
                ).then(
                  (value) => {
                    if (value != null)
                      {
                        setState(
                          () {
                            produtosPedido.clear();
                            mesaController.clear();
                          },
                        ),
                      },
                  },
                );
              },
        label: const Text('Salvar pedido'),
      ),
    );
  }
}
