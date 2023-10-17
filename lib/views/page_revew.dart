// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../models/vocabulary.dart';
import '../models/category.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage(
      {super.key,
      required this.allListVocabulary,
      required this.listCategory,
      required this.listCategStr});
  List<Vocabulary> allListVocabulary = [];
  List<Category> listCategory = [];
  List<String> listCategStr = [];

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  String selectedCategory = '';
  Map<String, List<String>> listNum = {
    '5': ['0-5', '1-4', '2-3'],
    '10': ['0-10', '2-8', '4-6'],
    '15': ['0-15', '3-12', '6-9'],
    '20': ['0-20', '4-16', '8-12'],
    '25': ['0-25', '5-20', '10-15'],
  };
  String selectNum = '';
  String selectRandomStyle = '';
  List<Vocabulary> listVocabulary = [];

  @override
  Widget build(BuildContext context) {
    selectedCategory =
        widget.listCategStr.isNotEmpty ? widget.listCategStr.first : '';
    selectNum = listNum.keys.first;
    selectRandomStyle = listNum[selectNum]!.first.toString();
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 8, bottom: 8, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownMenu(
                  initialSelection: selectedCategory,
                  width: 150,
                  onSelected: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  dropdownMenuEntries: widget.listCategStr
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList()),
              DropdownMenu<String>(
                  initialSelection: selectNum,
                  width: 85,
                  onSelected: (String? value) {
                    setState(() {
                      selectNum = value!;
                      selectRandomStyle = listNum[value]!.first.toString();
                    });
                  },
                  dropdownMenuEntries: listNum.keys
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList()),
              DropdownMenu<String>(
                  initialSelection: selectRandomStyle,
                  width: 100,
                  onSelected: (String? value) {
                    setState(() {
                      selectRandomStyle = value!;
                    });
                  },
                  dropdownMenuEntries: listNum[selectNum]!
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList()),
            ],
          ),
        ),
      ],
    );
  }
}
