import 'package:flutter/material.dart';
import 'package:lang_edu/controller/file_controller.dart';
import 'package:lang_edu/views/float_button_category.dart';
import '../models/category.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({super.key, required this.listCategory});
  List<Category> listCategory = [];
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Future<void> computeFuture = Future.value();

  void _addCategory(String name) {
    int newID = widget.listCategory.length + 1;
    final newCateg = Category(id: newID, name: name);
    setState(() {
      widget.listCategory.add(newCateg);
    });
    FileManager().writeJsonCategoryFile(widget.listCategory);
  }

  void _removeCategory(int id) {
    setState(() {
      widget.listCategory.removeWhere((item) => item.id == id);
    });
    FileManager().writeJsonCategoryFile(widget.listCategory);
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
                style: ElevatedButton.styleFrom(
                    elevation: 8.0,
                    backgroundColor: const Color.fromRGBO(235, 235, 247, 1)),
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
              children: widget.listCategory.isNotEmpty
                  ? widget.listCategory
                      .map((e) =>
                          vocabularyItem(e, widget.listCategory.indexOf(e)))
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
              ? const Color.fromRGBO(253, 242, 246, 1)
              : const Color.fromRGBO(237, 233, 224, 1),
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
