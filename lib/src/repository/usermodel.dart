// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  int? age;
  String? userID;
  double? weight;
  double? height;
  double? bodyFat;
  String? fullName;
  String? userName;
  String? phoneNo;
  String? email;
  DateTime? dateOfBirth;
  String? gender;
  UserModel({
    this.age,
    this.userID,
    this.weight,
    this.height,
    this.bodyFat,
    this.fullName,
    this.userName,
    this.phoneNo,
    this.email,
    this.dateOfBirth,
    this.gender,
  });
  






  UserModel copyWith({
    int? age,
    String? userID,
    double? weight,
    double? height,
    double? bodyFat,
    String? fullName,
    String? userName,
    String? phoneNo,
    String? email,
    DateTime? dateOfBirth,
    String? gender,
  }) {
    return UserModel(
      age: age ?? this.age,
      userID: userID ?? this.userID,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      bodyFat: bodyFat ?? this.bodyFat,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'age': age,
      'userID': userID,
      'weight': weight,
      'height': height,
      'bodyFat': bodyFat,
      'fullName': fullName,
      'userName': userName,
      'phoneNo': phoneNo,
      'email': email,
      'dateOfBirth': dateOfBirth?.millisecondsSinceEpoch,
      'gender': gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      age: map['age'] != null ? map['age'] as int : null,
      userID: map['userID'] != null ? map['userID'] as String : null,
      weight: map['weight'] != null ? map['weight'] as double : null,
      height: map['height'] != null ? map['height'] as double : null,
      bodyFat: map['bodyFat'] != null ? map['bodyFat'] as double : null,
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      phoneNo: map['phoneNo'] != null ? map['phoneNo'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      dateOfBirth: map['dateOfBirth'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int) : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(age: $age, userID: $userID, weight: $weight, height: $height, bodyFat: $bodyFat, fullName: $fullName, userName: $userName, phoneNo: $phoneNo, email: $email, dateOfBirth: $dateOfBirth, gender: $gender)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.age == age &&
      other.userID == userID &&
      other.weight == weight &&
      other.height == height &&
      other.bodyFat == bodyFat &&
      other.fullName == fullName &&
      other.userName == userName &&
      other.phoneNo == phoneNo &&
      other.email == email &&
      other.dateOfBirth == dateOfBirth &&
      other.gender == gender;
  }

  @override
  int get hashCode {
    return age.hashCode ^
      userID.hashCode ^
      weight.hashCode ^
      height.hashCode ^
      bodyFat.hashCode ^
      fullName.hashCode ^
      userName.hashCode ^
      phoneNo.hashCode ^
      email.hashCode ^
      dateOfBirth.hashCode ^
      gender.hashCode;
  }
}
