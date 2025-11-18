class SalaFoco {
  final int id;
  final String nome;

  SalaFoco({required this.id, required this.nome});

  factory SalaFoco.fromJson(Map<String, dynamic> json) {
    return SalaFoco(
      id: json['id'],
      nome: json['nome'],
    );
  }
}
