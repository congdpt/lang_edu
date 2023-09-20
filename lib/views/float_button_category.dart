import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryFloatingButton extends StatelessWidget {
  CategoryFloatingButton({
    super.key,
    required this.addCategory,
  });

  final Function addCategory;

  TextEditingController cateName = TextEditingController();

  void _handleAddCategory(BuildContext context) {
    final name = cateName.text;
    if (name.isEmpty) {
      return;
    }
    addCategory(name);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(children: [
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(45)),
            child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Word',
                  labelStyle: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
              controller: cateName,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _handleAddCategory(context),
              child: const Text('Add Category'),
            ),
          )
        ]),
      ),
    );
  }
}
