// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guarana_mania/model/produtos.dart';
import 'package:guarana_mania/utils/extensions.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CreatePdf extends StatelessWidget {
  final List<Produto> produtosPedido;
  final String cliente;
  final String formadepagamento;
  const CreatePdf({
    Key? key,
    required this.produtosPedido,
    required this.cliente,
    required this.formadepagamento,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: PdfPreview(
        maxPageWidth: 700,
        allowPrinting: false,
        allowSharing: false,
        canChangePageFormat: false,
        canDebug: false,
        build: (format) =>
            makePdf(format, produtosPedido, cliente, formadepagamento),
      ),
    );
  }

  // ignore: long-method
  Future<Uint8List> makePdf(
    PdfPageFormat format,
    List<Produto> produtosPedido,
    String cliente,
    String formadepagamento,
  ) async {
    final fontRoboto = await PdfGoogleFonts.robotoMonoBold();
    final emoji = await PdfGoogleFonts.notoColorEmoji();

    DateTime currentTime = DateTime.now();
    final pdf = pw.Document();

    List produtoss = [];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        orientation: pw.PageOrientation.portrait,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'COMPROVANTE DE VENDA',
                    style: pw.TextStyle(
                      fontSize: 14,
                      font: fontRoboto,
                    ),
                  ),
                ),
                // pw.Center(
                //   child: pw.Image(
                //     pw.MemoryImage(
                //       imagenAgronomic,
                //     ),
                //     height: 65,
                //   ),
                // ),
                line(),
                dualline(
                  textCustom(
                    'HORÁRIO:${currentTime.hour}:${currentTime.minute.toString().length == 1 ? 0 : ''}${currentTime.minute}:${currentTime.second}',
                    color: PdfColors.black,
                    fontSize: 10,
                    font: fontRoboto,
                  ),
                  textCustom(
                    'DATA:${DateFormat(
                      DateFormat.yMd('pt_Br').format(currentTime),
                    ).format(
                      DateTime.now(),
                    )}',
                    color: PdfColors.black,
                    fontSize: 10,
                    font: fontRoboto,
                  ),
                ),
                textCustom(
                  'CLIENTE:${cliente.toUpperCase()}',
                  color: PdfColors.black,
                  fontSize: 10,
                  font: fontRoboto,
                ),
                textCustom(
                  'FORMA DE PAGAMENTO:${formadepagamento.toUpperCase()}',
                  color: PdfColors.black,
                  fontSize: 10,
                  font: fontRoboto,
                ),
                line(),
                pw.ListView.builder(
                  itemCount: produtosPedido.length,
                  itemBuilder: (_, index) {
                    final produto = produtosPedido[index];
                    if (produtoss.contains(produto)) {
                      return pw.Container();
                    } else {
                      produtoss.add(produto);

                      return tableCustom(
                        produtosPedido
                            .where((p) =>
                                p.nome == produto.nome &&
                                p.tipo == produto.tipo)
                            .fold<int>(0, (total, p) => total + 1)
                            .toString(),
                        produto.tipo,
                        produto.nome,
                        fontSize: 10.7,
                        color: PdfColors.black,
                        font: fontRoboto,
                      );
                    }
                  },
                ),
                line(),
                pw.Row(
                  children: [
                    textCustom(
                      'TOTAL : ${produtosPedido.fold<double>(0, (total, p) => total + p.unitario).formatted}',
                      fontSize: 11,
                      color: PdfColors.black,
                      font: fontRoboto,
                    ),
                  ],
                ),
                line(),
                // pw.Center(
                //   child: pw.Image(
                //     pw.MemoryImage(
                //       qrcode,
                //     ),
                //     height: 75,
                //   ),
                // ),
                pw.Center(
                  child: pw.Text(
                    'Obrigado pela preferência 🖤!',
                    style: pw.TextStyle(
                      fontFallback: [emoji],
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  // ignore: long-parameter-list
  tableCustom(
    String quant,
    String tipo,
    String ml, {
    double fontSize = 12,
    PdfColor? color,
    pw.Font? font,
  }) {
    return pw.SizedBox(
      width: 800,
      child: pw.Container(
        child: pw.Stack(
          children: [
            pw.Positioned(
              left: 0,
              child: pw.Text(
                '$quant x',
                style: pw.TextStyle(
                  fontSize: fontSize,
                  color: color,
                  font: font,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Center(
              child: pw.Text(
                tipo.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: fontSize,
                  color: color,
                  font: font,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Positioned(
              right: 0,
              child: pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  ml.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: ml.length > 6 ? fontSize - 2.5 : fontSize,
                    color: color,
                    font: font,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  line() {
    return pw.Divider(
      thickness: 1,
      color: PdfColors.black,
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
    String title, {
    double fontSize = 6,
    PdfColor? color,
    pw.Font? font,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 5, left: 5),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: fontSize,
          color: color,
          font: font,
        ),
      ),
    );
  }
}
