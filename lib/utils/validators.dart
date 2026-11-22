/// Form validators. Each one returns an error message to show under the
/// field, or null when the value is valid.
class Validators {
  Validators._();

  static const String universityDomain = '@sabanciuniv.edu';

  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? username(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return 'Username is required';
    if (text.length < 3) return 'Username must be at least 3 characters';
    if (text.length > 20) return 'Username must be at most 20 characters';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(text)) {
      return 'Use only letters, numbers and underscores';
    }
    return null;
  }

  static String? universityEmail(String? value) {
    final String text = value?.trim().toLowerCase() ?? '';
    if (text.isEmpty) return 'University email is required';
    final bool hasName = text.length > universityDomain.length;
    if (!text.endsWith(universityDomain) || !hasName || text.contains(' ')) {
      return 'Must end with $universityDomain';
    }
    return null;
  }

  static String? password(String? value) {
    final String text = value ?? '';
    if (text.isEmpty) return 'Password is required';
    if (text.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? postTitle(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return 'Title is required';
    if (text.length < 5) return 'Title must be at least 5 characters';
    if (text.length > 100) return 'Title must be at most 100 characters';
    return null;
  }

  static String? postContent(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return 'Content is required';
    if (text.length < 10) return 'Content must be at least 10 characters';
    return null;
  }
}
