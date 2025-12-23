class DataModel {
  String? name;
  String? age;
  String? imgUrl;
  bool isFavorite;

  DataModel({
    this.name,
    this.age,
    this.imgUrl,
    this.isFavorite = false,
  });


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'imgUrl': imgUrl,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }


  factory DataModel.fromMap(Map<String, dynamic> map) {
    return DataModel(
      name: map['name'],
      age: map['age'],
      imgUrl: map['imgUrl'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}
