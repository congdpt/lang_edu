import 'package:flutter/material.dart';
import 'package:lang_edu/controller/file_controller.dart';
import 'package:lang_edu/views/float_button_category.dart';
import '../models/category.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

List<Category> listCategory = [];

class _CategoryPageState extends State<CategoryPage> {
  Future<void> computeFuture = Future.value();

  Future<void> _readCategory() async {
    if (listCategory.isEmpty) {
      try {
        // if (data_value.toString().isEmpty) {
        listCategory = await FileManager().readCategoryFile();
        // }
      } catch (e) {
        debugPrint("Couldn't read file");
      }
      setState(() {
        listCategory;
      });
    }
  }

  void _addCategory(String name) {
    int newID = listCategory.length + 1;
    final newCateg = Category(id: newID, name: name);
    setState(() {
      listCategory.add(newCateg);
    });
    FileManager().writeJsonCategoryFile(listCategory);
  }

  void _removeCategory(int id) {
    setState(() {
      listCategory.removeWhere((item) => item.id == id);
    });
    FileManager().writeJsonCategoryFile(listCategory);
  }

  @override
  void initState() {
    super.initState();
    // Call the readJson method when the app starts
    _readCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 8, bottom: 8, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(''),
              ElevatedButton(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: listCategory.isNotEmpty
                  ? listCategory
                      .map((e) => vocabularyItem(e, listCategory.indexOf(e)))
                      .toList()
                  : [const Text('Please add new Category')],
            ),
          ),
        )
      ],
    );
  }

  Container vocabularyItem(Category item, int index) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
          color: index % 2 == 1
              ? const Color.fromRGBO(239, 239, 248, 20)
              : const Color.fromRGBO(170, 158, 158, 165),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromARGB(255, 201, 200, 200))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            item.name,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
          InkWell(
            child: const Icon(
              Icons.delete_outline,
              color: Colors.deepOrange,
            ),
            onTap: () {
              _removeCategory(item.id);
              // onTap: () async {
              //   if (await confirm(context)) {
              //     return _removeWord(item.id);
              //   }
              //   return;
            },
          )
        ]),
      ),
    );
  }
}
