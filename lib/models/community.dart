/// A topic board such as su/Courses.
class Community {
  const Community({
    required this.id,
    required this.name,
    required this.description,
    required this.memberCount,
    this.isJoined = false,
  });

  final String id;

  /// Name without the prefix, e.g. "Courses".
  final String name;
  final String description;
  final int memberCount;

  /// Whether the current user has joined this community.
  final bool isJoined;

  /// Name the way it is shown in the UI, e.g. "su/Courses".
  String get displayName => 'su/$name';

  Community copyWith({int? memberCount, bool? isJoined}) {
    return Community(
      id: id,
      name: name,
      description: description,
      memberCount: memberCount ?? this.memberCount,
      isJoined: isJoined ?? this.isJoined,
    );
  }
}
