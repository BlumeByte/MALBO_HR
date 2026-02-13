import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfile {
  final String employeeId;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? avatarUrl;

  const UserProfile({
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.avatarUrl,
  });

  String get fullName => '$firstName $lastName';

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        employeeId: json['id'] as String,
        firstName: (json['first_name'] ?? '') as String,
        lastName: (json['last_name'] ?? '') as String,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        avatarUrl: json['avatar_url'] as String?,
      );
}

final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final client = Supabase.instance.client;
  final user = client.auth.currentUser;
  if (user == null) {
    throw Exception('Not authenticated');
  }

  final res = await client
      .from('employees')
      .select('id, first_name, last_name, email, phone, avatar_url')
      .eq('user_id', user.id)
      .single();

  return UserProfile.fromJson(res);
});
