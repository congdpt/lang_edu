// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../../controller/file_controller.dart';
import '../../models/vocabulary.dart';
import '../../models/category.dart';
import '../float_button_vocabulary.dart';
import '../../main.dart';

class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => VocabularyPageState();
}

class VocabularyPageState extends State<VocabularyPage> {
  final _formKey = GlobalKey<FormState>();
  String dropdownFirstValue = '';
  int maxIDVocabulary = 0;
  List<Vocabulary> listVocabulary = [];

  Future<void> _loadVocabulary(String categName) async {
    try {
      int categID;
      if (categName.isNotEmpty) {
        categID = Category.getIDbyName(StaticVariable.listCategory, categName);
      } else {
        categID = StaticVariable.categMapData.keys.first;
      }
      if (!categID.isNaN) {
        dropdownFirstValue = StaticVariable.categMapData[categID]!;
        listVocabulary = Vocabulary.getVocabularybyCategID(
            StaticVariable.allListVocabulary, categID);
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
    int categID = Category.getIDbyName(StaticVariable.listCategory, categName);
    final newWord =
        Vocabulary('', categID, id: maxIDVocabulary, name: name, mean: mean);
    await Vocabulary.fetchWorData(newWord);
    StaticVariable.allListVocabulary.add(newWord);
    FileManager().writeJsonVocabularyFile(StaticVariable.allListVocabulary);
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
    StaticVariable.allListVocabulary.removeWhere((item) => item.id == id);
    FileManager().writeJsonVocabularyFile(StaticVariable.allListVocabulary);
    setState(() {
      listVocabulary.removeWhere((item) => item.id == id);
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the readJson method when the app starts
    _loadVocabulary('');
    for (var vocab in StaticVariable.allListVocabulary) {
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
              Container(
                margin: const EdgeInsets.all(0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 0.01,
                      color: const Color.fromARGB(255, 229, 229, 229)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dropdownFirstValue,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => StaticVariable.listCateg
                          .map((item) => PopupMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                ),
                              ))
                          .toList(),
                      onSelected: (String? value) {
                        _loadVocabulary(value!);
                      },
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 8.0, backgroundColor: Colors.deepOrange),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext content) {
                        return VocabularyFloatingButton(
                            addNewWord: _addNewWord,
                            listCateg: StaticVariable.listCateg,
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
          child: Scrollbar(
            child: ListView(
              restorationId: 'list_vocabulary_view',
              padding: const EdgeInsets.symmetric(horizontal: 5),
              children: [
                for (int index = 0; index < listVocabulary.length; index++)
                  ListTile(
                    leading: ExcludeSemantics(
                      child: CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              (listVocabulary[index].status == 'draft')
                                  ? Colors.deepOrangeAccent
                                  : Colors.blueGrey,
                          child: Text((index + 1).toString())),
                    ),
                    title: Text(listVocabulary[index].name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    contentPadding: EdgeInsets.zero,
                    tileColor: index % 2 == 1
                        ? const Color.fromRGBO(255, 245, 235, 1)
                        : const Color.fromRGBO(245, 186, 147, 1),
                    // (listVocabulary[index].status == 'draft')
                    //     ? (index % 2 == 1
                    //         ? const Color.fromRGBO(255, 245, 235, 1)
                    //         : const Color.fromRGBO(245, 186, 147, 1))
                    //     : (index % 2 == 1
                    //         ? const Color.fromRGBO(225, 227, 170, 1)
                    //         : const Color.fromRGBO(173, 201, 101, 1)),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.deepOrange,
                      ),
                      onPressed: () {
                        _removeWord(listVocabulary[index].id);
                      },
                    ),
                    onTap: () async {
                      await showVocabularyDetails(listVocabulary[index]);
                    },
                    subtitle: Text(listVocabulary[index].mean,
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> showVocabularyDetails(Vocabulary item) {
    return showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color.fromRGBO(237, 172, 140, 1),
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
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            item.status,
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
