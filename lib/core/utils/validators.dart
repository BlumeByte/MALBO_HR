class Validators {
  static String? requiredField(String? v, {String label = 'This field'}) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final value = v.trim();
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);
    if (!ok) return 'Enter a valid email address';
    return null;
  }

  static String? phoneGhOptional(String? v) {
    if (v == null || v.trim().isEmpty) return null; // optional
    final value = v.trim();
    // digits only, allow + at start
    final ok = RegExp(r'^\+?\d{7,15}$').hasMatch(value);
    if (!ok) return 'Enter a valid phone number';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Password must be at least 8 characters';
    return null;
  }
}
