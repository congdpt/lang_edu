import 'package:flutter/material.dart';

class VocabularyFloatingButton extends StatelessWidget {
  VocabularyFloatingButton({
    super.key,
    required this.addNewWord,
    required this.listCateg,
    required this.currentCateg,
  });

  final Function addNewWord;
  final List<String> listCateg;
  final String currentCateg;

  TextEditingController newWord = TextEditingController();
  TextEditingController newMean = TextEditingController();
  TextEditingController newWordCateg = TextEditingController();
  String dropdownFirstValue = '';

  void _handleAddNewWord(BuildContext context) {
    final name = newWord.text;
    final mean = newMean.text;
    final categName = newWordCateg.text;
    if (name.isEmpty | mean.isEmpty | categName.isEmpty) {
      return;
    }
    addNewWord(name, mean, categName, currentCateg);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (currentCateg.isEmpty) {
      dropdownFirstValue = listCateg.isNotEmpty ? listCateg.first : '';
    } else {
      dropdownFirstValue = currentCateg;
    }
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
              controller: newWord,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(45)),
            child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mean',
                  labelStyle: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
              controller: newMean,
            ),
          ),
          DropdownMenu<String>(
              width: 390,
              initialSelection: dropdownFirstValue,
              controller: newWordCateg,
              dropdownMenuEntries:
                  listCateg.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList()),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _handleAddNewWord(context),
              child: const Text('Add word'),
            ),
          )
        ]),
      ),
    );
  }
}
