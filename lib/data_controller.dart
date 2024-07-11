import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data_model.dart';
import 'package:flutter/material.dart';



class DataController extends ChangeNotifier {
  DataModel _dataModel = DataModel(userList: [], currentPage: 0, lastPage: 1, total: 0, perPage: 10);
  bool isLoading = false;
  String statusMessage = "";

  DataModel get dataModel => _dataModel;

  Future<void> fetchData({int page = 1}) async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse('https://mmfinfotech.co/machine_test/api/userList?page=$page'));

    if (response.body.isNotEmpty) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == true) {
        final newData = DataModel.fromJson(jsonData);

        _dataModel = DataModel(
          userList: [..._dataModel.userList, ...newData.userList],
          currentPage: newData.currentPage,
          lastPage: newData.lastPage,
          total: newData.total,
          perPage: newData.perPage,
        );
      } else {
        statusMessage = jsonData['message'];
      }
    } else {
      statusMessage = "Failed to load data.";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    if (_dataModel.currentPage < _dataModel.lastPage) {
      await fetchData(page: _dataModel.currentPage + 1);
    }
  }
}
