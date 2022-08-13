class Pedidos {
  final String nome;
  final String pagamento;
  final DateTime data;

  final List<ProdutoPedido> produtos;

  Pedidos({
    required this.nome,
    required this.pagamento,
    required this.data,
    required this.produtos,
  });

  double get total =>
      produtos.fold(0, (total, produto) => total + produto.total);

  factory Pedidos.fromJson(Map<String, dynamic> json) {
    final data = DateTime.parse(json['data'] as String);
    // ignore: newline-before-return
    return Pedidos(
      nome: json['nome'] as String,
      pagamento: json['pagamento'] as String,
      data: data.isUtc ? data.toLocal() : data,
      produtos: (json['produtos'] as List<dynamic>)
          .map((produto) =>
              ProdutoPedido.fromJson(produto as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'pagamento': pagamento,
      'data': data.toUtc().toIso8601String(),
      'produtos': produtos.map((p) => p.toJson()).toList(),
    };
  }
}

class ProdutoPedido {
  final String nome;
  final double qtde;
  final double unitario;

  ProdutoPedido({
    required this.nome,
    required this.qtde,
    required this.unitario,
  });

  double get total => qtde * unitario;

  factory ProdutoPedido.fromJson(Map<String, dynamic> json) {
    return ProdutoPedido(
      nome: json['nome'] as String,
      qtde: double.parse(json['qtde'].toString()),
      unitario: double.parse(json['unitario'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'qtde': qtde,
      'unitario': unitario,
    };
  }
}
