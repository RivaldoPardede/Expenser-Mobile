import 'country_model.dart';

class UserModel {
  final String id;
  final String email;
  final String? name;
  final CountryModel? country;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.country,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      country: json['country'] != null ? CountryModel.fromJson(json['country']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'country': country?.toJson(),
    };
  }
}
