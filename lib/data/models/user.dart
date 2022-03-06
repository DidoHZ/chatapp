import 'dart:convert';

class User {
  String uid;
  String username;
  String image;
  User({
    required this.uid,
    required this.username,
    required this.image,
  });

  User copyWith({
    String? uid,
    String? username,
    String? image,
  }) {
    return User(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'image': image,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() => 'User(uid: $uid, username: $username, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User &&
      other.uid == uid &&
      other.username == username &&
      other.image == image;
  }

  @override
  int get hashCode => uid.hashCode ^ username.hashCode ^ image.hashCode;
}
