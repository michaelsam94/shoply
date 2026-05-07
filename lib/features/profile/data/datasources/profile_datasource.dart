import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';

class ProfileDatasource {
  ProfileDatasource(this._client);
  final SupabaseClient _client;

  Future<ProfileModel?> getProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final name = (user.userMetadata?['full_name'] ?? '').toString();
    return ProfileModel(id: user.id, email: user.email ?? '', fullName: name);
  }

  Future<ProfileModel?> updateProfile({required String fullName}) async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    await _client.auth
        .updateUser(UserAttributes(data: {'full_name': fullName}));
    return ProfileModel(
        id: user.id, email: user.email ?? '', fullName: fullName);
  }
}
