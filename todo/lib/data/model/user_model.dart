import 'dart:convert';


class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String? profileImage;

  UserModel(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.fullName,
      required this.email,
      this.profileImage});
  UserModel copyWith(
      {String? id,
      String? firstName,
      String? lastName,
      String? fullName,
      String? email,
      String? profileImage}) {
    return UserModel(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        profileImage: profileImage ?? this.profileImage);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'email': email,
      'profile_image': profileImage
    };
  }

  factory UserModel.formMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      fullName: map['full_name'] as String,
      email: map['email'] as String,
      profileImage:
          map["profile_image"] != null ? map['profile_image'] as String : null,
    );
  }
  String toJson() => json.encode(toMap());
  factory UserModel.fromJson(String source) =>
      UserModel.formMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, first_name: $firstName, last_name: $lastName, full_name:$fullName, email:$email, profile_image:$profileImage)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.fullName == fullName &&
        other.email == email &&
        other.profileImage == profileImage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        profileImage.hashCode;
  }
}
