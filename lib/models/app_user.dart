/// A SUtory user.
class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.joinedAt,
    this.karma = 0,
  });

  final String id;
  final String username;
  final String email;
  final DateTime joinedAt;

  /// Score collected from votes on the user's posts and comments.
  final int karma;

  /// Username the way it is shown in the UI, e.g. "@night_owl".
  String get handle => '@$username';

  AppUser copyWith({String? username, String? email, int? karma}) {
    return AppUser(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      joinedAt: joinedAt,
      karma: karma ?? this.karma,
    );
  }
}
