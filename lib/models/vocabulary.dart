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
  late List<List<dynamic>> phonetic = [];
  late List<String> audio = [];

  Vocabulary(
    this.description,
    this.categID, {
    required this.id,
    required this.name,
    required this.mean,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> jsonValue) {
    Vocabulary newVocab = Vocabulary(
        '', jsonValue.containsKey('categID') ? jsonValue['categID'] : 0,
        id: jsonValue.containsKey('id') ? jsonValue['id'] : 0,
        name: jsonValue.containsKey('name') ? jsonValue['name'] : '',
        mean: jsonValue.containsKey('mean') ? jsonValue['mean'] : '');
    newVocab.status =
        jsonValue.containsKey('status') ? jsonValue['status'] : 'draft';
    if (jsonValue.containsKey('phonetic')) {
      for (var i = 0; i < jsonValue['phonetic'].length; i++) {
        newVocab.phonetic.add(jsonValue['phonetic'][i]);
      }
    }
    return newVocab;
  }

  Map toJson() => {
        'id': id,
        'mean': mean,
        'name': name,
        'categID': categID,
        'status': status,
        'phonetic': phonetic,
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
      if (jsonWord.containsKey('phonetics')) {
        for (Map<String, dynamic> item in jsonWord['phonetics']) {
          List<dynamic> newPhonetic = [];
          item.containsKey('text')
              ? newPhonetic.add(item['text'])
              : newPhonetic.add('');
          item.containsKey('audio')
              ? newPhonetic.add(item['audio'])
              : newPhonetic.add('');
          newWord.phonetic.add(newPhonetic);
        }
      }
    } else {
      // If the server did not return a 200 OK response
      debugPrint('Failed to load new word');
    }
  }
}
