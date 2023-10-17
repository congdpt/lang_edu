// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lang_edu/controller/file_controller.dart';
import 'package:lang_edu/views/float_button_vocabulary.dart';
import '../models/vocabulary.dart';
import '../models/category.dart';

class VocabularyPage extends StatefulWidget {
  VocabularyPage(
      {super.key,
      required this.allListVocabulary,
      required this.listCategory,
      required this.listCategStr});
  List<Vocabulary> allListVocabulary = [];
  List<Category> listCategory = [];
  List<String> listCategStr = [];

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  final _formKey = GlobalKey<FormState>();
  String dropdownFirstValue = '';
  int maxIDVocabulary = 0;
  Map<int, String> categMapData = {};
  List<Vocabulary> listVocabulary = [];

  Future<void> _loadVocabulary(String categName) async {
    try {
      if (categMapData.isEmpty) {
        categMapData = Category.getName(widget.listCategory);
      }
      int categID;
      if (categName.isNotEmpty) {
        categID = Category.getIDbyName(widget.listCategory, categName);
      } else {
        categID = categMapData.keys.first;
      }
      if (!categID.isNaN) {
        dropdownFirstValue = categMapData[categID]!;
        listVocabulary = Vocabulary.getVocabularybyCategID(
            widget.allListVocabulary, categID);
      }
      setState(() {
        listVocabulary;
      });
    } catch (e) {
      debugPrint("Couldn't read data Vocabulary");
    }
  }

  void _addNewWord(
      String name, String mean, String categName, String currentCateg) async {
    maxIDVocabulary += 1;
    int categID = Category.getIDbyName(widget.listCategory, categName);
    final newWord =
        Vocabulary('', categID, id: maxIDVocabulary, name: name, mean: mean);
    await Vocabulary.fetchWorData(newWord);
    widget.allListVocabulary.add(newWord);
    FileManager().writeJsonVocabularyFile(widget.allListVocabulary);
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
    widget.allListVocabulary.removeWhere((item) => item.id == id);
    FileManager().writeJsonVocabularyFile(widget.allListVocabulary);
    setState(() {
      listVocabulary.removeWhere((item) => item.id == id);
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the readJson method when the app starts
    _loadVocabulary('');
    for (var vocab in widget.allListVocabulary) {
      if (vocab.id > maxIDVocabulary) {
        maxIDVocabulary = vocab.id;
      }
    }
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
                  width: 160,
                  initialSelection: dropdownFirstValue,
                  onSelected: (String? value) {
                    _loadVocabulary(value!);
                  },
                  dropdownMenuEntries: widget.listCategStr
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList()),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 8.0,
                    backgroundColor: const Color.fromRGBO(235, 235, 247, 1)),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext content) {
                        return VocabularyFloatingButton(
                            addNewWord: _addNewWord,
                            listCateg: widget.listCategStr,
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
      height: 50,
      decoration: BoxDecoration(
          color: (item.status == 'draft')
              ? (index % 2 == 1
                  ? const Color.fromRGBO(235, 235, 247, 1)
                  : const Color.fromRGBO(227, 239, 247, 1))
              : (index % 2 == 1
                  ? const Color.fromRGBO(253, 242, 246, 1)
                  : const Color.fromRGBO(237, 233, 224, 1)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color.fromARGB(255, 201, 200, 200))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(
            onTap: () async {
              await showVocabularyDetails(item);
            },
            child: Text(
              item.name,
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
          ),
          InkWell(
            onTap: () {
              _removeWord(item.id);
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

  Future<void> showVocabularyDetails(Vocabulary item) {
    return showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color.fromRGBO(217, 229, 198, 1),
              content: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            item.name,
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            item.mean,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w100),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: item.phonetic.map<Text>((List item) {
                                return Text(item[0]);
                              }).toList()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
