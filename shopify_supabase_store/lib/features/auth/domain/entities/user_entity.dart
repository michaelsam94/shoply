import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity(
      {required this.id, required this.email, required this.createdAt});

  final String id;
  final String email;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, email, createdAt];
}
