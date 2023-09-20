import 'package:flutter/material.dart';
import 'package:lang_edu/controller/file_controller.dart';
import 'package:lang_edu/models/category.dart';
import 'package:lang_edu/views/float_button_vocabulary.dart';
import '../models/vocabulary.dart';

class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

List<Vocabulary> listVocabulary = [];
List<Vocabulary> allListVocabulary = [];
List<Category> listCategObj = [];
List<String> listCateg = [];
String dropdownFirstValue = '';

dynamic dataValue;

class _VocabularyPageState extends State<VocabularyPage> {
  Future<void> _readVocabulary() async {
    if (listVocabulary.isEmpty) {
      // try {
      // if (data_value.toString().isEmpty) {
      listCategObj = await FileManager().readCategoryFile();
      listCateg = Category.getName(listCategObj);
      if (listCateg.isNotEmpty) {
        dropdownFirstValue = listCateg.first;
      }
      await _reloadVocabulary(dropdownFirstValue);
      // } catch (e) {
      //   debugPrint("Couldn't read file");
      // }
    }
  }

  Future _reloadVocabulary(String categName) async {
    dropdownFirstValue = categName;
    // listCategObj = await FileManager().readCategoryFile();
    int categID = Category.getIDbyName(listCategObj, categName);
    listVocabulary = await FileManager().readVocabularyFile();
    allListVocabulary = listVocabulary;
    if (categID != 0) {
      listVocabulary =
          Vocabulary.getVocabularybyCategID(listVocabulary, categID);
    }
    setState(() {
      listVocabulary;
    });
  }

  void _addNewWord(
      String name, String mean, String categName, String currentCateg) async {
    int newID = allListVocabulary.length + 1;
    // listCategObj = await FileManager().readCategoryFile();
    int categID = Category.getIDbyName(listCategObj, categName);
    final newWord = Vocabulary('', categID, id: newID, name: name, mean: mean);
    await Vocabulary.fetchWorData(newWord);
    allListVocabulary.add(newWord);
    FileManager().writeJsonVocabularyFile(allListVocabulary);
    if (categName == currentCateg) {
      {
        setState(() {
          listVocabulary.add(newWord);
        });
      }
    }
  }

  void _removeWord(int id) {
    FileManager().writeJsonVocabularyFile(listVocabulary);
    allListVocabulary.removeWhere((item) => item.id == id);
    FileManager().writeJsonVocabularyFile(allListVocabulary);
    setState(() {
      listVocabulary.removeWhere((item) => item.id == id);
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the readJson method when the app starts
    _readVocabulary();
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
              DropdownMenu<String>(
                  width: 200,
                  initialSelection: dropdownFirstValue,
                  onSelected: (String? value) {
                    _reloadVocabulary(value!);
                  },
                  dropdownMenuEntries:
                      listCateg.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList()),
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 8.0),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext content) {
                        return VocabularyFloatingButton(
                            addNewWord: _addNewWord,
                            listCateg: listCateg,
                            currentCateg: dropdownFirstValue);
                      });
                },
                child: const Text('Add New Word',
                    style: TextStyle(fontWeight: FontWeight.w800)),
              )
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: listVocabulary.isNotEmpty
                  ? listVocabulary
                      .map((e) => vocabularyItem(e, listVocabulary.indexOf(e)))
                      .toList()
                  : [const Text('Please add new word for leaning')],
            ),
          ),
        )
      ],
    );
  }

  Container vocabularyItem(Vocabulary item, int index) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
          color: (item.status != 'draft')
              ? (index % 2 == 1
                  ? const Color.fromRGBO(239, 239, 248, 20)
                  : const Color.fromRGBO(170, 158, 158, 165))
              : (index % 2 == 1
                  ? const Color.fromRGBO(255, 222, 233, 247)
                  : const Color.fromRGBO(255, 234, 246, 230)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color.fromARGB(255, 201, 200, 200))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            children: [
              Row(
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  ),
                  const Text('  '),
                  Text(
                    item.phonetic.isNotEmpty ? item.phonetic.toString() : '',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.green),
                  )
                ],
              ),
              Text(
                item.mean,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey),
              )
            ],
          ),
          InkWell(
            onTap: () {
              _removeWord(item.id);
              // onTap: () async {
              //   if (await confirm(context)) {
              //     return _removeWord(item.id);
              //   }
              //   return;
            },
            child: const Icon(
              Icons.delete_outline,
              color: Colors.deepOrange,
            ),
          )
        ]),
      ),
    );
  }
}
