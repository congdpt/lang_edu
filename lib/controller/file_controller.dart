import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lang_edu/models/category.dart';
import 'package:lang_edu/models/vocabulary.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  Future<String> get _directoryPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _jsonVocabularyFile async {
    final path = await _directoryPath;
    debugPrint(path);
    if (File(path).existsSync()) {
      return File('$path/vocabulary.json');
    } else {
      return File('$path/vocabulary.json').create(recursive: true);
    }
  }

  Future<List<Vocabulary>> readVocabularyFile() async {
    String fileContent;
    File file = await _jsonVocabularyFile;
    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
        if (fileContent.isNotEmpty) {
          List<Vocabulary> listVocabulary = [];
          var dataJson = json.decode(fileContent);
          for (var item in dataJson) {
            Vocabulary newWord = Vocabulary.fromJson(item);
            listVocabulary.add(newWord);
          }
          return listVocabulary;
        } else {
          return [];
        }
      } catch (e) {
        debugPrint(e.toString());
        return [];
      }
    }
    return [];
  }

  Future writeJsonVocabularyFile(List<Vocabulary> vocab) async {
    List<String> listData = [];
    for (var item in vocab) {
      listData.add(json.encode(item.toJson()));
    }
    File file = await _jsonVocabularyFile;
    await file.writeAsString(json.encode(vocab));
  }

  Future<File> get _jsonCategoryFile async {
    final path = await _directoryPath;
    if (File(path).existsSync()) {
      return File('$path/category.json');
    } else {
      return File('$path/category.json').create(recursive: true);
    }
  }

  Future<List<Category>> readCategoryFile() async {
    String fileContent;

    File file = await _jsonCategoryFile;

    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
        if (fileContent.isNotEmpty) {
          var dataJson = json.decode(fileContent);
          List<Category> listCategory = [];
          for (var item in dataJson) {
            Category newCateg = Category.fromJson(item);
            listCategory.add(newCateg);
          }
          return listCategory;
        } else {
          return [];
        }
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  Future writeJsonCategoryFile(List<Category> categ) async {
    List<String> listData = [];
    for (var item in categ) {
      listData.add(json.encode(item.toJson()));
    }
    File file = await _jsonCategoryFile;
    await file.writeAsString(json.encode(categ));
  }
}
