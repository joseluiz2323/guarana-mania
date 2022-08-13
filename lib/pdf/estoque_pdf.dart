// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:guarana_mania/model/produtos.dart';

class EstoquePdf extends StatelessWidget {
  List<Produto> produtosPedido;

  EstoquePdf({
    Key? key,
    required this.produtosPedido,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: PdfPreview(
        maxPageWidth: 700,
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        canDebug: false,
        build: (format) => makePdf(format, produtosPedido),
      ),
    );
  }

  // ignore: long-method
  Future<Uint8List> makePdf(
    PdfPageFormat format,
    List<Produto> produtosPedido,
  ) async {
    final imagenAgronomic =
        (await rootBundle.load('assets/logo_pdf.png')).buffer.asUint8List();
    final fontRoboto = await PdfGoogleFonts.robotoLight();
    final fontRobotoRegular = await PdfGoogleFonts.robotoRegular();
    DateTime currentTime = DateTime.now();
    final pdf = pw.Document();
    //for produtosPedido

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(children: [
                    pw.Spacer(),
                    pw.Image(
                      pw.MemoryImage(imagenAgronomic),
                      height: 40,
                    ),
                  ]),
                  pw.SizedBox(height: 20),
                  pw.Center(
                    child: pw.Text(
                      'ESTOQUE DE PRODUTOS',
                      style: pw.TextStyle(
                        fontSize: 20,
                        font: fontRoboto,
                      ),
                    ),
                  ),
                  pw.Text(
                    'Data: ${currentTime.day}/${currentTime.month}/${currentTime.year}',
                    style: pw.TextStyle(
                      fontSize: 12,
                      font: fontRobotoRegular,
                    ),
                  ),
                  line(),
                  pw.SizedBox(height: 20),
                  ...criaTabela(produtosPedido),
                ],
              ),
            )
          ];
        },
      ),
    );

    return pdf.save();
  }

  List<pw.Widget> criaTabela(produtosPedido1) {
    List<pw.Widget> lista = [];
    if (produtosPedido.length < 49) {
      lista.add(pw.Center(child: tabe(produtosPedido)));
    }
    if (produtosPedido.length >= 50) {
      lista.add(pw.Center(child: tabe(produtosPedido.sublist(0, 50))));
    }
    if (produtosPedido.length > 50) {
      lista.add(pw.Center(
        child: tabe(produtosPedido.sublist(
            50, produtosPedido.length > 120 ? 110 : produtosPedido.length)),
      ));
    }
    if (produtosPedido.length > 120) {
      lista.add(pw.Center(
        child: tabe(produtosPedido.sublist(
            120, produtosPedido.length > 170 ? 150 : produtosPedido.length)),
      ));
    }
    if (produtosPedido.length > 170) {
      lista.add(pw.Center(
        child: tabe(produtosPedido.sublist(
            170, produtosPedido.length > 220 ? 200 : produtosPedido.length)),
      ));
    }
    if (produtosPedido.length > 220) {
      lista.add(pw.Center(
        child: tabe(produtosPedido.sublist(
            220, produtosPedido.length > 270 ? 250 : produtosPedido.length)),
      ));
    }
    if (produtosPedido.length > 270) {
      lista.add(pw.Center(
        child: tabe(produtosPedido.sublist(
            270, produtosPedido.length > 320 ? 300 : produtosPedido.length)),
      ));
    }
    if (produtosPedido.length > 320) {
      lista.add(pw.Center(
        child: tabe(produtosPedido.sublist(
            320, produtosPedido.length > 370 ? 350 : produtosPedido.length)),
      ));
    }
    if (produtosPedido.length > 370) {
      lista.add(pw.Center(
        child: tabe(produtosPedido.sublist(
            370, produtosPedido.length > 420 ? 400 : produtosPedido.length)),
      ));
    }
    if (produtosPedido.length > 420) {
      lista.add(pw.Center(
        child: tabe(produtosPedido.sublist(
            420, produtosPedido.length > 470 ? 450 : produtosPedido.length)),
      ));
    }
    if (produtosPedido.length > 470) {
      lista.add(pw.Center(
        child: tabe(produtosPedido.sublist(
            470, produtosPedido.length > 520 ? 500 : produtosPedido.length)),
      ));
    }
    if (produtosPedido.length > 520) {
      lista.add(pw.Center(
        child: tabe(produtosPedido.sublist(
            520, produtosPedido.length > 570 ? 550 : produtosPedido.length)),
      ));
    }
    if (produtosPedido.length > 570) {
      lista.add(pw.Center(
        child: tabe(produtosPedido.sublist(
            570, produtosPedido.length > 620 ? 600 : produtosPedido.length)),
      ));
    }
    if (produtosPedido.length > 620) {
      lista.add(pw.Center(
        child: tabe(produtosPedido.sublist(
            620, produtosPedido.length > 670 ? 650 : produtosPedido.length)),
      ));
    }
    if (produtosPedido.length > 670) {
      lista.add(pw.Center(
        child: tabe(produtosPedido.sublist(
            670, produtosPedido.length > 720 ? 700 : produtosPedido.length)),
      ));
    }
    if (produtosPedido.length > 720) {
      lista.add(pw.Center(
        child: tabe(produtosPedido.sublist(
            720, produtosPedido.length > 770 ? 750 : produtosPedido.length)),
      ));
    }

    return lista;
  }

  tabe(produtosPedido) {
    return pw.Wrap(
      children: [
        ...List.generate(
          produtosPedido.length,
          (index) => pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 2),
            width: 90,
            height: 55,
            child: textCustom(
              produtosPedido[index].nome,
              produtosPedido[index].tipo,
              produtosPedido[index].estoque!.toInt().toString(),
            ),
          ),
        ),
      ],
    );
  }

  line() {
    return pw.Divider(
      thickness: 0.5,
      height: 20,
    );
  }

  dualline(widget1, widget2) {
    return pw.Row(children: [
      widget1,
      pw.Spacer(),
      widget2,
    ]);
  }

  textCustom(
    String title,
    String tipo,
    String qtde, {
    PdfColor? color,
    pw.Font? font,
  }) {
    return pw.Column(
      children: [
        pw.FittedBox(
          fit: pw.BoxFit.contain,
          child: pw.Text(
            tipo,
            style: pw.TextStyle(
              color: color,
              font: font,
            ),
          ),
        ),
        pw.FittedBox(
          fit: pw.BoxFit.contain,
          child: pw.Text(
            title,
            style: pw.TextStyle(
              color: color,
              font: font,
            ),
          ),
        ),
        pw.FittedBox(
          fit: pw.BoxFit.contain,
          child: pw.Text(
            qtde.toString(),
            style: pw.TextStyle(
              color: color,
              font: font,
            ),
          ),
        )
      ],
    );
  }
}
