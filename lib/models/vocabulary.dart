import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Vocabulary {
  int id;
  String mean;
  String name;
  final String description;
  final int categID;
  late String status = 'draft';
  late List<String> phonetic = [];

  Vocabulary(
    this.description,
    this.categID, {
    required this.id,
    required this.name,
    required this.mean,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    debugPrint(json.toString());
    String phonetic = json['phonetic'];
    Vocabulary newVocab = Vocabulary('', json['categID'] as int,
        id: json['id'] as int,
        name: json['name'] as String,
        mean: json['mean'] as String);
    newVocab.status = 'draft';
    newVocab.phonetic = phonetic.isNotEmpty ? phonetic.split('-') : [];
    return newVocab;
  }

  Map toJson() => {
        'id': id,
        'mean': mean,
        'name': name,
        'categID': categID,
        'status': status,
        'phonetic': phonetic.join('-')
      };

  static List<Vocabulary> getVocabularybyCategID(
      List<Vocabulary> listVocab, int categID) {
    List<Vocabulary> listVocabNew = [];
    for (var item in listVocab) {
      if (item.categID == categID) {
        listVocabNew.add(item);
      }
    }
    return listVocabNew;
  }

  static relearnStatus(Vocabulary vocabItem) {
    vocabItem.status = 'draft';
  }

  static learnedStatus(Vocabulary vocabItem) {
    vocabItem.status = 'learned';
  }

  static Future fetchWorData(Vocabulary newWord) async {
    var url = Uri.parse(
        'https://api.dictionaryapi.dev/api/v2/entries/en/${newWord.name}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      Map<String, dynamic> jsonWord = json.decode(response.body)[0];
      if (jsonWord.containsKey('phonetic')) {
        debugPrint(jsonWord['phonetic']);
        newWord.phonetic.add(jsonWord['phonetic']);
      }
    } else {
      // If the server did not return a 200 OK response
      debugPrint('Failed to load new word');
    }
  }
}
