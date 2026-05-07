import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._datasource);
  final ProfileDatasource _datasource;

  @override
  Future<ProfileModel?> getProfile() => _datasource.getProfile();

  @override
  Future<ProfileModel?> updateProfile({required String fullName}) {
    return _datasource.updateProfile(fullName: fullName);
  }
}
