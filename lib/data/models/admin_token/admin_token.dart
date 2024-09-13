class AdminToken {
  int id;
  String token;
  int adminId;

  AdminToken({
    required this.id,
    required this.token,
    required this.adminId,
  });

  factory AdminToken.fromJson(Map<String, dynamic> json) {
    return AdminToken(
      id: json['id'],
      token: json['token'],
      adminId: json['admin_id'],
    );
  }

  // fromJsonList
  static List<AdminToken> fromJsonList(List list) {
    return list.map((item) => AdminToken.fromJson(item)).toList();
  }
}
