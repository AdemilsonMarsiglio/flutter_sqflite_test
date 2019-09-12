class UIName {
  String name;
  String surname;
  String gender;
  String region;

  UIName({this.name, this.surname, this.gender, this.region});

  UIName.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    surname = json['surname'];
    gender = json['gender'];
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['gender'] = this.gender;
    data['region'] = this.region;
    return data;
  }
}
