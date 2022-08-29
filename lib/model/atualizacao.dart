class Atualizacao {
  final bool verification;
  final String link;

  Atualizacao({required this.verification, required this.link});

  factory Atualizacao.fromJson(Map<String, dynamic> json) => Atualizacao(
        verification: json["verification"],
        link: json["link"],
      );
}
