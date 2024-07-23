class ProductItem {
  String? calories;
  String? carbos;
  String? description;
  int? difficulty;
  String? fats;
  String? headline;
  String? id;
  String? image;
  String? name;
  String? proteins;
  String? thumb;
  String? time;

  ProductItem(
      {this.calories,
        this.carbos,
        this.description,
        this.difficulty,
        this.fats,
        this.headline,
        this.id,
        this.image,
        this.name,
        this.proteins,
        this.thumb,
        this.time});

  ProductItem.fromJson(Map<String, dynamic> json) {
    calories = json['calories'];
    carbos = json['carbos'];
    description = json['description'];
    difficulty = json['difficulty'];
    fats = json['fats'];
    headline = json['headline'];
    id = json['id'];
    image = json['image'];
    name = json['name'];
    proteins = json['proteins'];
    thumb = json['thumb'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['calories'] = calories;
    data['carbos'] = carbos;
    data['description'] = description;
    data['difficulty'] = difficulty;
    data['fats'] = fats;
    data['headline'] = headline;
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    data['proteins'] = proteins;
    data['thumb'] = thumb;
    data['time'] = time;
    return data;
  }
}
