import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'data_model.dart';

class DataController {

  late DataModel _dataModel;
  bool isLoading = false;
  final String _jwtToken;

  DataController(this._jwtToken) {
    _dataModel = DataModel(userList: [], currentPage: 0, lastPage: 1, total: 0, perPage: 10);
  }

  DataModel getData() {
    return _dataModel;
  }




  Future<void> fetchData({int page = 1}) async {
    if (isLoading) return;

    isLoading = true;

    try {
      final response = await http.get(
        Uri.parse('https://mmfinfotech.co/machine_test/api/userList?page=$page'),
        headers: {
          'Authorization': 'Bearer $_jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final newData = DataModel.fromJson(jsonData);

        _dataModel = DataModel(
          userList: [..._dataModel.userList, ...newData.userList],
          currentPage: newData.currentPage,
          lastPage: newData.lastPage,
          total: newData.total,
          perPage: newData.perPage,
        );
      } else {
        throw Exception('Failed to load data (${response.statusCode})');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
      rethrow; // Rethrow the exception to handle it in ViewModel
    } finally {
      isLoading = false;
    }
  }

  Future<void> loadMoreData() async {
    if (_dataModel.currentPage < _dataModel.lastPage) {
      await fetchData(page: _dataModel.currentPage + 1);
    }
  }
}



enum ViewType { list, grid }

class ViewModel with ChangeNotifier {
  final DataController _dataController;
  List<User> _userList = [];
  bool _isLoading = false;
  bool _hasError = false;
  ViewType _viewType = ViewType.list; // Initialize viewType

  ViewModel(this._dataController) {
    _userList = _dataController.getData().userList;
  }

  List<User> get userList => _userList;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  ViewType get viewType => _viewType; // Getter for viewType

  void toggleView() {
    _viewType = _viewType == ViewType.list ? ViewType.grid : ViewType.list; // Method to toggle viewType
    notifyListeners();
  }

  Future<void> fetchData({int page = 1}) async {
    if (_isLoading) return;

    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      await _dataController.fetchData(page: page);
      _userList = _dataController.getData().userList;
    } catch (e) {
      _hasError = true;
      if (kDebugMode) {
        print("Error fetching data: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreData() async {
    await _dataController.loadMoreData();
    _userList = _dataController.getData().userList;
    notifyListeners();
  }
}
