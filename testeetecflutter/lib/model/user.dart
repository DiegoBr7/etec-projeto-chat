class UserModel {
  final int id;
  final String username;
  final String? displayName;
  UserModel({required this.id, required this.username, this.displayName});
  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
    id: j['id'], username: j['username'], displayName: j['displayName'],
  );
}