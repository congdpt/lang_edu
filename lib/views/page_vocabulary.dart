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
int maxIDVocabulary = 0;

dynamic dataValue;

class _VocabularyPageState extends State<VocabularyPage> {
  final _formKey = GlobalKey<FormState>();

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
    for (var vocab in allListVocabulary) {
      if (vocab.id > maxIDVocabulary) {
        maxIDVocabulary = vocab.id;
      }
    }
    maxIDVocabulary += 1;
    // int newID = allListVocabulary.length + 1;
    // listCategObj = await FileManager().readCategoryFile();
    int categID = Category.getIDbyName(listCategObj, categName);
    final newWord =
        Vocabulary('', categID, id: maxIDVocabulary, name: name, mean: mean);
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
                style: ElevatedButton.styleFrom(
                    elevation: 8.0,
                    backgroundColor: const Color.fromRGBO(235, 235, 247, 1)),
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
                  Positioned(
                    right: -40,
                    top: -40,
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),
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
                        // Padding(
                        //   padding: const EdgeInsets.all(8),
                        //   child: ElevatedButton(
                        //     child: const Text('Submitß'),
                        //     onPressed: () {
                        //       if (_formKey.currentState!.validate()) {
                        //         _formKey.currentState!.save();
                        //       }
                        //     },
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
