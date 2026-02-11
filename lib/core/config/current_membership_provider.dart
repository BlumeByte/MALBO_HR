import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CompanyMembership {
  final String companyId;
  final String role;

  CompanyMembership({
    required this.companyId,
    required this.role,
  });
}

final membershipProvider = FutureProvider<CompanyMembership>((ref) async {
  final client = Supabase.instance.client;
  final user = client.auth.currentUser;

  if (user == null) {
    throw Exception('User not authenticated');
  }

  final res = await client
      .from('company_members')
      .select('company_id, role')
      .eq('user_id', user.id)
      .single();

  return CompanyMembership(
    companyId: res['company_id'],
    role: res['role'],
  );
});
