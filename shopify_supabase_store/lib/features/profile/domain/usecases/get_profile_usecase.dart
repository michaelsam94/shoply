import '../../data/models/profile_model.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  GetProfileUseCase(this._repository);
  final ProfileRepository _repository;

  Future<ProfileModel?> call() => _repository.getProfile();
}
