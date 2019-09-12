import 'package:test_floor/provider.dart';

class Client {

  static final String tableName = "CLIENT";

  int id;
  String firstName;
  String lastName;
  bool blocked;

  Client({
      this.id,
      this.firstName,
      this.lastName,
      this.blocked,
  });

  static String createTable() => (
    "CREATE TABLE $tableName ("
        "id INTEGER PRIMARY KEY,"
        "first_name TEXT,"
        "last_name TEXT,"
        "blocked BIT"
    ")"
  );

  static fromJson(Map<String, dynamic> json) => new Client(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      blocked: json["blocked"],
  );

  Map<String, dynamic> toJson() => {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "blocked": blocked,
  };

  insert() {
    DBProvider.db.insert(tableName, toJson());
  }

  update() {
    DBProvider.db.updateByWhere(tableName, toJson(), "id = ?", [this.id]);
  }

  delete() {
    DBProvider.db.deleteWhere(tableName, "id = ?", [this.id]);
  }

  static Future<List<Client>> getAll() async {
    final res = await DBProvider.db.getAll(tableName);
    return List<Client>.from(res.map((c) => fromJson(c)).toList());
  }

  static Future<void> deleteAll() async {
    return await DBProvider.db.deleteAll(tableName);
  }

  static Future<int> getNextSequence() async {
    var response = await DBProvider.db.execQuery("SELECT coalesce(MAX(id), 0) + 1 as ID FROM CLIENT");
    return response.first["ID"];
  }
}