// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../../controller/file_controller.dart';
import '../../models/category.dart';
import '../float_button_category.dart';
import '../../main.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Future<void> computeFuture = Future.value();

  void _addCategory(String name) {
    int newID = StaticVariable.listCategory.length + 1;
    final newCateg = Category(id: newID, name: name);
    setState(() {
      StaticVariable.listCategory.add(newCateg);
    });
    FileManager().writeJsonCategoryFile(StaticVariable.listCategory);
  }

  void _removeCategory(int id) {
    setState(() {
      StaticVariable.listCategory.removeWhere((item) => item.id == id);
    });
    FileManager().writeJsonCategoryFile(StaticVariable.listCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 8, bottom: 8, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(''),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 8.0, backgroundColor: Colors.deepOrange),
                child: const Text('Add new Category',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext content) {
                        return CategoryFloatingButton(
                          addCategory: _addCategory,
                        );
                      });
                },
              )
            ],
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: ListView(
              restorationId: 'list_vocabulary_view',
              padding: const EdgeInsets.symmetric(horizontal: 5),
              children: [
                for (int index = 0;
                    index < StaticVariable.listCategory.length;
                    index++)
                  ListTile(
                    leading: ExcludeSemantics(
                      child: CircleAvatar(child: Text((index + 1).toString())),
                    ),
                    title: Text(
                      StaticVariable.listCategory[index].name,
                    ),
                    contentPadding: EdgeInsets.zero,
                    tileColor: index % 2 == 1
                        ? const Color.fromRGBO(255, 245, 235, 1)
                        : const Color.fromRGBO(254, 228, 194, 1),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.deepOrange,
                      ),
                      onPressed: () {
                        _removeCategory(StaticVariable.listCategory[index].id);
                      },
                    ),
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
