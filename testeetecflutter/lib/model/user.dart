class UserModel {
  final int id;
  final String email;
  final String senha;
  final String nome;

  UserModel({
    required this.id,
    required this.email,
    required this.senha,
    required this.nome,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      senha: json['senha'],
      nome: json['nome'],
    );
  }
}
