import 'package:test_floor/provider.dart';

class Client {
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
      "CREATE TABLE Client ("
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
      DBProvider.db.insert("CLIENT", toJson());
    }

    update() {
      this.firstName = "aaa";
      this.lastName = "11111aa";
      DBProvider.db.updateByWhere("CLIENT", toJson(), "id = ?", [2] );
    }

    static Future<List<Client>> getAll() async {
      final res = await DBProvider.db.getAll("CLIENT");
      return List<Client>.from(res.map((c) => fromJson(c)).toList());
    }

    static Future<void> deleteAll() async {
      return await DBProvider.db.deleteAll("CLIENT");
    }

    static Future<int> getNextSequence() async {
      var response = await DBProvider.db.execQuery("SELECT coalesce(MAX(id), 0) + 1 as ID FROM CLIENT");
      return response.first["ID"];
    }
}