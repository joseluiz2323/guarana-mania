import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guarana_mania/utils/extensions.dart';

import '../../global/color_global.dart';
import '../../model/pedidos.dart';
import '../../model/produtos.dart';
import '../../pdf/comprovante_elgin.dart';
import '../../pdf/create_pdf.dart';

class WidgetFinalizarPedido extends StatefulWidget {
  final List<Produto> produtosPedido;
  final String cliente;
  final String formadePagamento;
  const WidgetFinalizarPedido({
    Key? key,
    required this.produtosPedido,
    required this.cliente,
    required this.formadePagamento,
  }) : super(key: key);
  @override
  State<WidgetFinalizarPedido> createState() => _WidgetFinalizarPedidoState();
}

class _WidgetFinalizarPedidoState extends State<WidgetFinalizarPedido> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: ColorGlobal.colorsbackground,
        title: const Text('Comprovante'),
        actions: [
          IconButton(
              icon: const Icon(Icons.print),
              onPressed: isLoading
                  ? () async {
                      setState(() {
                        isLoading = false;
                      });
                      print('Carregando...');
                      await comproventePrint(
                        produtosPedido: widget.produtosPedido,
                        cliente: widget.cliente,
                        formadepagamento: widget.formadePagamento,
                      );
                    }
                  : null)
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CreatePdf(
                produtosPedido: widget.produtosPedido,
                cliente: widget.cliente,
                formadepagamento: widget.formadePagamento,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Produtos: ${widget.produtosPedido.length}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Total: ${widget.produtosPedido.fold<double>(0, (total, p) => total + p.unitario).formatted}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 50, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton.extended(
              backgroundColor: const Color.fromARGB(255, 255, 66, 66),
              onPressed: () {
                Navigator.pop(context, true);
              },
              tooltip: 'Increment',
              label: const Text('Cancelar'),
            ),
            FloatingActionButton.extended(
              backgroundColor: const Color.fromARGB(255, 255, 66, 66),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: 'Increment',
              label: const Text('  Editar  '),
            ),
            FloatingActionButton.extended(
              backgroundColor: const Color.fromARGB(255, 104, 187, 107),
              onPressed: () async {
                bool isclick = true;
                if (isclick) {
                  isclick = false;
                  final unique = widget.produtosPedido.toSet().toList();
                  final produtos = unique
                      .map((p) => ProdutoPedido(
                            nome: p.nome,
                            tipo: p.tipo,
                            qtde: double.parse(widget.produtosPedido
                                .where((p2) => p2 == p)
                                .length
                                .toString()),
                            unitario: p.unitario,
                          ))
                      .toList();
                  final pedido = Pedidos(
                    nome: widget.cliente,
                    pagamento: widget.formadePagamento,
                    data: DateTime.now(),
                    produtos: produtos,
                  );
                  final data = pedido.toJson();

                  FirebaseFirestore.instance.collection('pedidos').add(data);
                  // remove estoque itens do estoque
                  Future remove() async {
                    final firebaseEstoque = FirebaseFirestore.instance
                        .collection('produtos')
                        .snapshots();
                    final estoque = await firebaseEstoque.first;

                    for (final produto in estoque.docs) {
                      for (final produtoPedido in widget.produtosPedido) {
                        if (produto.data()['nome'] == produtoPedido.nome &&
                            produto.data()['tipo'] == produtoPedido.tipo) {
                          final quantidade = widget.produtosPedido
                              .where((p) =>
                                  p.nome == produto.data()['nome'] &&
                                  p.tipo == produto.data()['tipo'])
                              .length;
                          FirebaseFirestore.instance
                              .collection('produtos')
                              .doc(produto.id)
                              .update({
                            'estoque': produto.data()['estoque'] - quantidade,
                          });
                        }
                      }
                    }
                  }

                  remove().then((value) {
                    Navigator.pop(context, true);
                  });
                }
              },
              tooltip: 'Increment',
              label: const Text('Finalizar'),
            ),
          ],
        ),
      ),
    );
  }
}
