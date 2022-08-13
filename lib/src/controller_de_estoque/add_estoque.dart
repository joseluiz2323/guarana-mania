import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guarana_mania/components/text_field_custom.dart';
import 'package:guarana_mania/global/color_global.dart';
import 'package:guarana_mania/model/produtos.dart';

class EstoqueEditAdd extends StatefulWidget {
  final String? id;
  final Produto? produto;
  const EstoqueEditAdd({
    Key? key,
    this.id,
    this.produto,
  }) : super(key: key);

  @override
  State<EstoqueEditAdd> createState() => _EstoqueEditAddState();
}

class _EstoqueEditAddState extends State<EstoqueEditAdd> {
  final nomeController = TextEditingController();
  final estoqueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      nomeController.text = widget.produto?.nome ?? '';
      estoqueController.text =
          widget.produto?.estoque?.toInt().toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: ColorGlobal.colorsbackground,
        centerTitle: true,
        title: const Text(
          'Casatrar produto',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 8),
            TextFieldCustom(
              label: 'Nome',
              enabled: false,
              controller: nomeController,
            ),
            TextFieldCustom(
              label: 'estoque',
              controller: estoqueController,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 135, 77, 160),
        onPressed: () async {
          if (estoqueController.text == '') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('preencha os campos'),
              ),
            );
          } else {
            final Produto estoque = Produto(
              nome: nomeController.text,
              estoque: double.parse(estoqueController.text),
              tipo: widget.produto?.tipo ?? '',
              classe: widget.produto?.classe ?? '',
              unitario: widget.produto?.unitario ?? 0,
            );
            await FirebaseFirestore.instance
                .collection('produtos')
                .doc(widget.id)
                .update(estoque.toJsonEstoque())
                .then(
                  (value) => Navigator.pop(context),
                );
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
