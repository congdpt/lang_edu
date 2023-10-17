class Category {
  int id;
  String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json.containsKey('id') ? json['id'] : 0,
        name: json.containsKey('name') ? json['name'] : '');
  }

  Map toJson() => {
        'id': id,
        'name': name,
      };

  static Map<int, String> getName(List<Category> listCateg) {
    Map<int, String> listName = {};
    for (var item in listCateg) {
      listName[item.id] = item.name;
    }
    return listName;
  }

  static int getIDbyName(List<Category> listCateg, String name) {
    for (var item in listCateg) {
      if (item.name == name) {
        return item.id;
      }
    }
    return 0;
  }
}
