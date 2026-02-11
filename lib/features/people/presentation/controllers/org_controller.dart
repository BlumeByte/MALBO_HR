import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/current_membership_provider.dart';
import '../../data/datasources/org_remote_ds.dart';
import '../../domain/entities/department.dart';
import '../../domain/entities/job_title.dart';
import '../../domain/entities/location.dart';

final orgDsProvider = Provider<OrgRemoteDs>((ref) {
  return OrgRemoteDs(Supabase.instance.client);
});

final departmentsProvider = FutureProvider<List<Department>>((ref) async {
  final membership = await ref.read(membershipProvider.future);
  return ref.read(orgDsProvider).listDepartments(membership.companyId);
});

final jobTitlesProvider = FutureProvider<List<JobTitle>>((ref) async {
  final membership = await ref.read(membershipProvider.future);
  return ref.read(orgDsProvider).listJobTitles(membership.companyId);
});

final locationsProvider = FutureProvider<List<Location>>((ref) async {
  final membership = await ref.read(membershipProvider.future);
  return ref.read(orgDsProvider).listLocations(membership.companyId);
});
