import '../../data/models/profile_model.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  UpdateProfileUseCase(this._repository);
  final ProfileRepository _repository;

  Future<ProfileModel?> call({required String fullName}) {
    return _repository.updateProfile(fullName: fullName);
  }
}
