import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Complain Model
class ComplainItem {
  String id;
  String title;
  String description;
  String status;
  DateTime dateTime;
  int wardNo;
  String category;
  String assignedTo;
  int priority;
  ComplainItem(
      {required this.id,
      required this.title,
      required this.description,
      this.status = 'Submitted',
      required this.dateTime,
      required this.wardNo,
      required this.category,
      this.priority = 1,
      required this.assignedTo});
}

class Complain with ChangeNotifier {
  String? authToken;
  String? userId;

  Complain(this.authToken, this.userId);
  List<ComplainItem> _items = [];

  List<ComplainItem> get items {
    return _items;
  }

  List<ComplainItem> _allItems = [];

  List<ComplainItem> get allItems {
    return _allItems;
  }

  // Complain Stat Info
  final Map<String, dynamic> _complainStat = {
    'Total Complains Reported': {'data': 0, 'color': const Color(0XFFB02323)},
    'On Initial Phase': {'data': 0, 'color': const Color(0XFFBC7100)},
    'On Review Phase': {'data': 0, 'color': const Color(0XFF6C63FF)},
    'Completed': {'data': 0, 'color': const Color(0XFF23B029)},
  };

  Map<String, dynamic> get complainStat {
    return _complainStat;
  }

  // Returns Complain by complainId
  ComplainItem findComplainById(bool userComplains, String complainId) {
    return userComplains == true
        ? items.firstWhere(
            (comData) => comData.id == complainId,
          )
        : allItems.firstWhere(
            (comData) => comData.id == complainId,
          );
  }

  // FIXME : Not the best way to implement.
  // TODO : Use Firebase to filter
  // Filter the complain a/c to ward and category
  List<ComplainItem> filterComplain(int wardNo, String category) {
    return _allItems
        .where((comData) =>
            comData.wardNo == wardNo && comData.category == category)
        .toList();
  }

  // Adding complain to dB
  Future<void> addComplain(
      {required String title,
      required int wardNo,
      required String category,
      required String description}) async {
    final regTime = DateTime.now().toIso8601String();

    final url = Uri.parse(
        'https://mero-gunasho-98804-default-rtdb.asia-southeast1.firebasedatabase.app/my-complains.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'creatorId': userId,
            'title': title,
            'description': description,
            'dateTime': regTime,
            'category': category,
            'ward': wardNo,
            'status': 'Submitted',
            'priority': 1,
          }));

      final responseData = json.decode(response.body);
      print('response = ${response.body}');

      _items.add(ComplainItem(
          id: responseData['name'],
          title: title,
          dateTime: DateTime.now(),
          wardNo: wardNo,
          category: category,
          description: description,
          status: 'Submitted',
          priority: 1,
          assignedTo: 'Chairman'));
      notifyListeners();
    } catch (error) {
      debugPrint('error = ${error.toString()}');
      rethrow;
    }
  }

  // Update the priority in dB
  Future<void> updateComplain(String complainId) async {
    final complainIndex =
        items.indexWhere((element) => element.id == complainId);
    if (complainIndex >= 0) {
      final complainData = findComplainById(false, complainId);
      try {
        final url = Uri.parse(
            'https://mero-gunasho-98804-default-rtdb.asia-southeast1.firebasedatabase.app/my-complains/$complainId.json?auth=$authToken');
        await http.patch(url,
            body: json.encode({
              'priority': complainData.priority + 1,
            }));
      } catch (error) {
        rethrow;
      }
    } else {
      return;
    }
  }

  // Update the stat component
  void updateStat() {
    complainStat['Total Complains Reported']['data'] = items.length;
    complainStat['On Initial Phase']['data'] = items
        .where((element) {
          return element.status == 'On Initial Phase';
        })
        .toList()
        .length;
    complainStat['On Review Phase']['data'] = items
        .where((element) {
          return element.status == 'On Review Phase';
        })
        .toList()
        .length;
    complainStat['Completed']['data'] = items
        .where((element) {
          return element.status == 'Completed';
        })
        .toList()
        .length;
    notifyListeners();
  }

  // Fetches complains from dB
  Future<void> fetchComplains(bool filterByUser) async {
    // filterByUser == true -> fetches complains specific to user
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    final url = Uri.parse(
        'https://mero-gunasho-98804-default-rtdb.asia-southeast1.firebasedatabase.app/my-complains.json?auth=$authToken&$filterString');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      List<ComplainItem> extractedComplains = [];
      //print('exData= $extractedData');
      extractedData.forEach((complainId, complainData) {
        extractedComplains.add(ComplainItem(
            id: complainId,
            title: complainData['title'],
            description: complainData['description'],
            dateTime: DateTime.parse(complainData['dateTime']),
            wardNo: complainData['ward'],
            category: complainData['category'],
            status: complainData['status'],
            priority: complainData['priority'],
            assignedTo: 'ward head'));
      });
      // To fetch all complains
      if (filterByUser == false) {
        _allItems = extractedComplains;
        notifyListeners();
        return;
      }
      _items = extractedComplains;
      updateStat();
      notifyListeners();
    } catch (error) {
      print('error = $error');
      rethrow;
    }
  }
}
