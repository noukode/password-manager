class Password {
  int? id;
  int user_id;
  String nama_akun, username, password;

  Password({this.id, required this.user_id, required this.nama_akun, required this.username, required this.password});

  factory Password.fromMap(Map<String, dynamic> json) => Password (id: json['id'], user_id: json['user_id'], nama_akun: json['nama_akun'], username: json['username'], password: json['password']);
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'nama_akun': nama_akun,
      'username': username,
      'password': password,
    };
  }
}