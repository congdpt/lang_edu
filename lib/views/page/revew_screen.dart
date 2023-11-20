// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import '../../controller/file_controller.dart';
import '../../models/vocabulary.dart';
import '../../models/category.dart';
import '../../main.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  Map<String, List<String>> listNum = {
    '5': ['0-5', '1-4', '2-3'],
    '10': ['0-10', '2-8', '4-6'],
    '15': ['0-15', '3-12', '6-9'],
    '20': ['0-20', '4-16', '8-12'],
    '25': ['0-25', '5-20', '10-15'],
  };
  String selectRandomStyle = '';
  List<Vocabulary> listVocabulary = [];
  String selectedCategory = '';
  String selectNum = '';

  Future<void> _loadVocabulary(String categName) async {
    selectedCategory = categName;
    setState(() {});
  }

  void _loadNumber(String num) {
    selectNum = num;
    selectRandomStyle = listNum[num]!.first.toString();
    setState(() {});
  }

  void _loadRandomStyle(String randomStyle) {
    selectRandomStyle = randomStyle;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    selectNum = listNum.keys.first;
    selectRandomStyle = listNum[selectNum]!.first.toString();
    setState(() {});
  }

  List<int> _getRandom(List<Vocabulary> listVocabulary, int numWord) {
    Random rnd = Random();
    List<int> listIndex = [];
    do {
      var indexRandom = rnd.nextInt(listVocabulary.length);
      if (!listIndex.contains(indexRandom)) {
        listIndex.add(indexRandom);
      }
    } while (listIndex.length != numWord);
    return listIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
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
                      selectedCategory,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
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
                      padding: const EdgeInsets.all(0),
                      onSelected: (String? value) {
                        _loadVocabulary(value!);
                      },
                    )
                  ],
                ),
              ),
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
                      selectNum,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => listNum.keys
                          .map((item) => PopupMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                ),
                              ))
                          .toList(),
                      padding: const EdgeInsets.all(0),
                      onSelected: (String? value) {
                        _loadNumber(value!);
                      },
                    )
                  ],
                ),
              ),
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
                      selectRandomStyle,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => listNum[selectNum]!
                          .map((item) => PopupMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                ),
                              ))
                          .toList(),
                      padding: const EdgeInsets.all(0),
                      onSelected: (String? value) {
                        _loadRandomStyle(value!);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Gen button ne'),
              onPressed: () {
                if (selectedCategory.isNotEmpty) {
                  if (listVocabulary.isNotEmpty) {
                    listVocabulary = [];
                  }
                  int categID = Category.getIDbyName(
                      StaticVariable.listCategory, selectedCategory);
                  var listVocabByCateg = StaticVariable.allListVocabulary
                      .where((e) => e.categID == categID);
                  if (listVocabByCateg.isNotEmpty) {
                    List<String> randomStyle = selectRandomStyle.split("-");
                    int countWord = 0;
                    var listVocabByCategDone = listVocabByCateg
                        .where((e) => e.status == 'learned')
                        .toList();
                    if (randomStyle[0] != '0') {
                      if (listVocabByCategDone.length <=
                          int.parse(randomStyle[0])) {
                        listVocabulary.addAll(listVocabByCategDone);
                        countWord += listVocabByCategDone.length;
                      } else {
                        List<int> listIndex = _getRandom(
                            listVocabByCategDone, int.parse(randomStyle[0]));
                        debugPrint(listIndex.toString());
                        for (int i = 0; i < listIndex.length; i++) {
                          debugPrint(listIndex[i].toString());
                          listVocabulary
                              .add(listVocabByCategDone[listIndex[i]]);
                        }
                        countWord += int.parse(randomStyle[0]);
                      }
                    }

                    int numWord = int.parse(selectNum) - countWord;
                    var listVocabByCategDraft = listVocabByCateg
                        .where((e) => e.status == 'draft')
                        .toList();
                    if (listVocabByCategDraft.length <= numWord) {
                      listVocabulary.addAll(listVocabByCategDraft);
                    } else {
                      List<int> listIndex =
                          _getRandom(listVocabByCategDraft, numWord);
                      for (int i = 0; i < listIndex.length; i++) {
                        listVocabulary.add(listVocabByCategDraft[listIndex[i]]);
                      }
                    }
                  }
                  setState(() {});
                }
              },
            ),
          ],
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
                    trailing: IconButton(
                      icon: listVocabulary[index].status == 'draft'
                          ? const Icon(
                              Icons.radio_button_unchecked_outlined,
                              color: Colors.deepOrange,
                            )
                          : const Icon(
                              Icons.radio_button_checked,
                              color: Colors.deepOrange,
                            ),
                      onPressed: () {
                        if (listVocabulary[index].status == 'draft') {
                          Vocabulary.learnedStatus(listVocabulary[index]);
                        } else {
                          Vocabulary.relearnStatus(listVocabulary[index]);
                        }
                        FileManager().writeJsonVocabularyFile(
                            StaticVariable.allListVocabulary);
                        setState(() {});
                      },
                    ),
                    onTap: () async {
                      await showVocabularyDetails(listVocabulary[index]);
                    },
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
                    // key: _formKey,
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
