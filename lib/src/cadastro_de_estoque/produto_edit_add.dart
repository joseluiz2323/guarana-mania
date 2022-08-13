// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guarana_mania/components/text_field_custom.dart';
import 'package:guarana_mania/global/color_global.dart';
import 'package:guarana_mania/model/produtos.dart';

class ProdutoEditAdd extends StatefulWidget {
  final String? id;
  final Produto? produto;
  const ProdutoEditAdd({
    Key? key,
    this.id,
    this.produto,
  }) : super(key: key);

  @override
  State<ProdutoEditAdd> createState() => _ProdutoEditAddState();
}

class _ProdutoEditAddState extends State<ProdutoEditAdd> {
  final nomeController = TextEditingController();
  final unitarioController = TextEditingController();
  final qtdeController = TextEditingController();
  final tipoController = TextEditingController();
  String classe = 'isfood';
  double precoController = 0.0;
  double estoqueController = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      nomeController.text = widget.produto?.nome ?? '';
      unitarioController.text =
          (widget.produto?.unitario ?? 0).toStringAsFixed(0);
      precoController = widget.produto?.unitario ?? 0;
      tipoController.text = widget.produto?.tipo ?? '';
      classe = widget.produto?.classe ?? '';
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
              controller: nomeController,
            ),
            TextFieldCustom(
              label: 'Preço',
              controller: unitarioController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  precoController =
                      double.tryParse(value.replaceAll(',', '.')) ?? 0;
                });
              },
            ),
            TextFieldCustom(
              label: 'Tipo',
              controller: tipoController,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  estoqueController =
                      double.tryParse(value.replaceAll(',', '.')) ?? 0;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 30),
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          classe = 'isfood';
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: classe == 'isfood'
                          ? const Color.fromARGB(255, 135, 77, 160)
                          : Colors.grey,
                      padding: const EdgeInsets.all(16),
                      disabledColor: Colors.grey,
                      elevation: classe == 'isfood' ? 0 : 3,
                      child: Text(
                        "Alimento",
                        style: TextStyle(
                          color:
                              classe == 'isfood' ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          classe = 'notfood';
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: classe == 'notfood'
                          ? const Color.fromARGB(255, 135, 77, 160)
                          : Colors.grey,
                      padding: const EdgeInsets.all(16),
                      disabledColor: Colors.grey,
                      elevation: classe == 'isfood' ? 0 : 3,
                      child: Text(
                        "Produto",
                        style: TextStyle(
                          color:
                              classe == 'notfood' ? Colors.white : Colors.black,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 135, 77, 160),
        onPressed: () async {
          if (nomeController.text == '' ||
              unitarioController.text == '' ||
              tipoController.text == '') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('preencha os campos'),
              ),
            );
          } else {
            final Produto produto = Produto(
              nome: nomeController.text,
              estoque: estoqueController,
              unitario: precoController,
              tipo: tipoController.text,
              classe: classe,
            );

            if (widget.id == null) {
              await FirebaseFirestore.instance
                  .collection('produtos')
                  .add(produto.toJson());
            } else {
              await FirebaseFirestore.instance
                  .collection('produtos')
                  .doc(widget.id)
                  .update(produto.toJson());
              FirebaseFirestore.instance
                  .collection('estoque')
                  .snapshots()
                  .listen((snapshot) {});
            }

            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
