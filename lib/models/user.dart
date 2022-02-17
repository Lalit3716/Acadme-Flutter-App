import '../constant.dart';

class User {
  final String id;
  final String username;
  final String avatar;

  User({required this.id, required this.username, required this.avatar});

  factory User.fromJSON(Map<String, dynamic> json) {
    final avatarUrl = (json['avatar'] as String).contains('https') ||
            (json['avatar'] as String).contains('http')
        ? json['avatar']
        : '${Constants.serverUrl}${json['avatar']}'.replaceFirst('/api', '');

    return User(
      id: json['_id'],
      username: json['username'],
      avatar: avatarUrl,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      '_id': id,
      'username': username,
      'avatar': avatar,
    };
  }
}
