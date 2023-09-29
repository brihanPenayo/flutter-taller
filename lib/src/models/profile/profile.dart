// ignore_for_file: public_member_api_docs, sort_constructors_first
class Profile {
  final String id;
  final String firstName;
  final String lastName;
  final String avatarUrl;

  Profile(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.avatarUrl =
          'https://img2.freepng.es/20180505/upw/kisspng-computer-icons-avatar-businessperson-interior-desi-corporae-5aee195c6d1683.4671087315255535004468.jpg'});

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'id': id,
  //     'firstName': firstName,
  //     'lastName': lastName,
  //   };
  // }
  String get display => "$firstName $lastName";

  dynamic get data => ["$firstName $lastName", avatarUrl];

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
        id: map['id'] as String,
        firstName: map['first_name'] as String,
        lastName: map['last_name'] as String,
        avatarUrl: map['avatar_url'] as String);
  }

  static final cache = <String, Profile>{};
}
