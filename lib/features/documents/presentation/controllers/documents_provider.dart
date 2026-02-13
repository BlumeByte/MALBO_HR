import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/current_membership_provider.dart';

final documentsProvider = FutureProvider((ref) async {
  final client = Supabase.instance.client;
  final membership = await ref.read(membershipProvider.future);

  final res = await client
      .from('documents')
      .select('*')
      .eq('company_id', membership.companyId)
      .order('created_at', ascending: false);

  return res;
});
