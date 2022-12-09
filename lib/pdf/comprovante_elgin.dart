import 'dart:io';

import 'package:elgin/elgin.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/produtos.dart';
import '../model/model_soma.dart';

Future<void> comproventePrint({
  required List<Produto> produtosPedido,
  required String cliente,
  required String formadepagamento,
}) async {
  FlutterBeep.beep();
  List<ProdutosModelSoma> produtosPedidovery = [];
  for (var i = 0; i < produtosPedido.length; i++) {
    //se o produto ja foi adicionado a lista, soma a quantidade
    if (produtosPedidovery
        .any((element) => element.nome == produtosPedido[i].nome)) {
      for (var j = 0; j < produtosPedidovery.length; j++) {
        if (produtosPedidovery[j].nome == produtosPedido[i].nome &&
            produtosPedidovery[j].tipo == produtosPedido[i].tipo) {
          produtosPedidovery[j].qtde += 1;
        }
      }
    } else {
      produtosPedidovery.add(ProdutosModelSoma(
        nome: produtosPedido[i].nome,
        estoque: produtosPedido[i].estoque,
        qtde: 1,
        tipo: produtosPedido[i].tipo,
        classe: produtosPedido[i].classe,
      ));
    }
  }
  DateTime currentTime = DateTime.now();

  final driver = ElginPrinter(type: ElginPrinterType.MINIPDV);
  try {
    final int? result = await Elgin.printer.connect(driver: driver);

    if (result != null) {
      if (result == 0) {
        await Elgin.printer.printString('COMPROVANTE DE VENDA',
            align: ElginAlign.CENTER, fontSize: ElginSize.MD, isBold: true);

        Uint8List byte = await _getImageFromAsset('assets/logo_pdf.png');
        Directory tempPath = await getTemporaryDirectory();
        File file = File('${tempPath.path}/dash.png');
        await file.writeAsBytes(byte);
        await file.writeAsBytes(
            byte.buffer.asUint8List(byte.offsetInBytes, byte.lengthInBytes));
        await Elgin.printer.printImage(file, false);

        await Elgin.printer.printString('-----------------------------',
            align: ElginAlign.CENTER, fontSize: ElginSize.MD);
        await Elgin.printer.feed(1);
        await Elgin.printer.printString(
            'HORÁRIO:${currentTime.hour}:${currentTime.minute.toString().length == 1 ? 0 : ''}${currentTime.minute}:${currentTime.second}',
            align: ElginAlign.LEFT,
            fontSize: ElginSize.MD);
        await Elgin.printer.printString('CLIENTE: ${cliente.toUpperCase()}',
            align: ElginAlign.LEFT, fontSize: ElginSize.MD);
        await Elgin.printer.printString(
          'FORMA DE PAGAMENTO: ${formadepagamento.toUpperCase()}',
        );
        await Elgin.printer.printString('-----------------------------',
            align: ElginAlign.LEFT, fontSize: ElginSize.MD);
        produtosPedidovery.map((produto) {
          return Elgin.printer.printString(
              //'${produto.qtde} X ${produto.tipo.length} ${produto.tipo}  ${produto.nome}',
              '${produto.qtde} X ${produto.tipo.toUpperCase()}  ${produto.nome}',
              align: ElginAlign.LEFT,
              fontSize: ElginSize.MD);
        }).toList();
        await Elgin.printer.printString('-----------------------------',
            align: ElginAlign.CENTER, fontSize: ElginSize.MD);

        await Elgin.printer.printString(
            'TOTAL: R\$ ${produtosPedido.map((produto) {
              return produto.unitario;
            }).reduce((a, b) => a + b)}',
            align: ElginAlign.LEFT,
            fontSize: ElginSize.MD);
        await Elgin.printer.printString('-----------------------------',
            align: ElginAlign.CENTER, fontSize: ElginSize.MD);

        Uint8List byte2 = await _getImageFromAsset('assets/qrcode.png');
        Directory tempPath2 = await getTemporaryDirectory();
        File file2 = File('${tempPath2.path}/dash.png');
        await file2.writeAsBytes(byte2);
        await file2.writeAsBytes(
            byte2.buffer.asUint8List(byte2.offsetInBytes, byte2.lengthInBytes));
        await Elgin.printer.printImage(file2, false);

        await Elgin.printer.printString('Obrigado pela preferência❤️!',
            align: ElginAlign.CENTER, fontSize: ElginSize.MD);
        await Elgin.printer.cut(lines: 5);

        await Elgin.printer.disconnect();
      }
    }
  } on ElginException {
    print('Erro ao imprimir');
  }
}

Future<Uint8List> readFileBytes(String path) async {
  ByteData fileData = await rootBundle.load(path);
  Uint8List fileUnit8List = fileData.buffer
      .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
  return fileUnit8List;
}

Future<Uint8List> _getImageFromAsset(String iconPath) async {
  return await readFileBytes(iconPath);
}
