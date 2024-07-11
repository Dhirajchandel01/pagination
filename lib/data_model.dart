// model/data_model.dart
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String countryCode;
  final String phoneNo;
  final String status;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.countryCode,
    required this.phoneNo,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      countryCode: json['country_code'],
      phoneNo: json['phone_no'],
      status: json['status'],
    );
  }
}

class DataModel {
  final List<User> userList;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  DataModel({
    required this.userList,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    var list = json['userList'] as List;
    List<User> users = list.map((i) => User.fromJson(i)).toList();
    return DataModel(
      userList: users,
      currentPage: json['currentPage'],
      lastPage: json['lastPage'],
      total: json['total'],
      perPage: json['perPage'],
    );
  }
}
