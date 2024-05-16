import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'unWantedWords.dart';

class Helper {
  String getNameProduct(String input) {
    String result = _removeUnwantedWords(_getBoxText(input));
    return result;
  }
  List<String> getListNameProduct(String input) {
    String result = _removeUnwantedWords(_getBoxText(input));
    List<String> nameSplit = splitProduct(result);
    return nameSplit;
  }

  String _getBoxText(String input) {
     String head = 'Tên ';
    String end = 'Tong ';
    int openParenthesisIndex = _findClosestMatch(input, head, head.length);
    int closeParenthesisIndex = _findClosestMatch(input, end, end.length);

    if (openParenthesisIndex != -1 && closeParenthesisIndex != -1) {
      String textInParentheses = input.substring(
          openParenthesisIndex + head.length, closeParenthesisIndex);
      // Xử lý trường hợp có xuống dòng
      textInParentheses = textInParentheses.replaceAll('\n', ' ').trim();
      return textInParentheses;
    } else {
      return 'No find result'; // Không tìm thấy dấu ngoặc đơn
    }
  }

  int _levenshtein(String s, String t) {
    if (s == t) {
      return 0;
    }
    if (s.isEmpty) {
      return t.length;
    }
    if (t.isEmpty) {
      return s.length;
    }

    List<int> v0 = List.filled(t.length + 1, 0);
    List<int> v1 = List.filled(t.length + 1, 0);

    for (int i = 0; i <= t.length; i++) {
      v0[i] = i;
    }
    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;

      for (int j = 0; j < t.length; j++) {
        int cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = [v1[j] + 1, v0[j + 1] + 1, v0[j] + cost].reduce(min);
      }
      for (int j = 0; j <= t.length; j++) {
        v0[j] = v1[j];
      }
    }
    return v1[t.length];
  }

  int _findClosestMatch(String rssString, String target, int chunkSize) {
    int minDistance = target.length; // Giả định khoảng cách lớn nhất có thể
    String closestMatch = "";
    int closestIndex = -1;

    // Duyệt qua chuỗi lớn, lấy từng phần để so sánh
    for (int i = 0; i < rssString.length - chunkSize; i++) {
      String chunk = rssString.substring(i, i + chunkSize);
      int distance = _levenshtein(chunk, target);

      if (distance < minDistance) {
        minDistance = distance;
        closestMatch = chunk;
        closestIndex = i;
      }
    }
    return closestIndex; // tra ve vi tri dau tien cua tu duoc tim thay
  }

  String _removeUnwantedWords(String input) {
    List<String> words = input.split(' ');
    List<String> resultWords = [];
    for (String word in words) {
      bool isUnwanted = false;
      for (String unwantedWord in unwantedWords) {
        int distance = _levenshtein(unwantedWord, word);
        if (distance <= 2) {
          isUnwanted = true; // tim được tu can xoa
          break; // Không cần kiểm tra thêm nữa
        }
      }
      if (!isUnwanted) {
        resultWords.add(word);
      }
    }
    return resultWords.join(' ');
  }
  String getNameUser(String dataRss) {
    final nameRegex = RegExp(r'(?<=KH: ).+?(?=\n)');
    final nameMatch = nameRegex.firstMatch(dataRss);
    final name = nameMatch?.group(0);
    return name.toString();
  }
  String getLieuThuoc(String dataRss) {
    final nameRegex = RegExp(r'\d+\s*Liều');
    final nameMatch = nameRegex.firstMatch(dataRss);
    final name = nameMatch?.group(0);
    if(name == null){
      return '0';
    }
    final numRegex = RegExp(r'\d');
    final numMatch = numRegex.firstMatch(dataRss);
    final num = numMatch?.group(0);
    return num.toString();
  }

List<String> splitProduct(String input){
  String pattern = r'\b\d{1,3}(,\d{3})+\b|\b\d{4,}\b|(?<=\b\d+V\s+|\b\d+X\d+\s+)(?=[A-Z])';
    RegExp exp = RegExp(pattern);
    List<String> parts = input.split(exp);
    List<String> drugNames = [];
    for (String part in parts.where((part) => part.isNotEmpty)) {
      drugNames.add(part.trim());
    }
    for (var element in drugNames) {
      // debugPrint(element);
    }return drugNames;
  }
}
