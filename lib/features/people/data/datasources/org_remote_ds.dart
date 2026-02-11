import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/department.dart';
import '../../domain/entities/job_title.dart';
import '../../domain/entities/location.dart';

class OrgRemoteDs {
  final SupabaseClient _client;
  OrgRemoteDs(this._client);

  Future<List<Department>> listDepartments(String companyId) async {
    final res = await _client
        .from('departments')
        .select('id,name')
        .eq('company_id', companyId)
        .order('name');

    return (res as List).map((e) => Department.fromJson(e)).toList();
  }

  Future<List<JobTitle>> listJobTitles(String companyId) async {
    final res = await _client
        .from('job_titles')
        .select('id,name')
        .eq('company_id', companyId)
        .order('name');

    return (res as List).map((e) => JobTitle.fromJson(e)).toList();
  }

  Future<List<Location>> listLocations(String companyId) async {
    final res = await _client
        .from('locations')
        .select('id,name')
        .eq('company_id', companyId)
        .order('name');

    return (res as List).map((e) => Location.fromJson(e)).toList();
  }
}
