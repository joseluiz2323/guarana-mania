class Produto {
  final String nome;
  double? estoque;
  final double unitario;
  final String tipo;
  final String classe;
  Produto({
    required this.nome,
    this.estoque,
    required this.unitario,
    required this.tipo,
    required this.classe,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      nome: json['nome'] as String,
      estoque: json['estoque'] ?? 0,
      unitario: double.parse(json['unitario'].toString()),
      tipo: json['tipo'] as String,
      classe: json['classe'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'unitario': unitario,
      'tipo': tipo,
      'classe': classe,
    };
  }

  Map<String, dynamic> toJsonEstoque() {
    return {
      'estoque': estoque,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Produto && other.nome == nome && other.unitario == unitario;
  }

  @override
  int get hashCode => nome.hashCode ^ unitario.hashCode;
}
