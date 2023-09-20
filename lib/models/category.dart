class Category {
  int id;
  String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'] as int, name: json['name'] as String);
  }

  Map toJson() => {
        'id': id,
        'name': name,
      };

  static List<String> getName(List<Category> listCateg) {
    List<String> listName = [];
    for (var item in listCateg) {
      listName.add(item.name);
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
