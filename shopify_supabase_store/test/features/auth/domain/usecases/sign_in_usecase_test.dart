import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopify_supabase_store/core/error/failures.dart';
import 'package:shopify_supabase_store/features/auth/domain/entities/user_entity.dart';
import 'package:shopify_supabase_store/features/auth/domain/repositories/auth_repository.dart';
import 'package:shopify_supabase_store/features/auth/domain/usecases/sign_in_usecase.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late SignInUseCase useCase;

  setUp(() {
    repository = _MockAuthRepository();
    useCase = SignInUseCase(repository);
  });

  test('returns UserEntity on success', () async {
    final user =
        UserEntity(id: '1', email: 'a@b.com', createdAt: DateTime(2024));
    when(
      () => repository.signIn(
          email: any(named: 'email'), password: any(named: 'password')),
    ).thenAnswer((_) async => Right(user));

    final result =
        await useCase(const SignInParams(email: 'a@b.com', password: 'secret'));
    expect(result, Right(user));
  });

  test('returns AuthFailure on invalid credentials', () async {
    when(
      () => repository.signIn(
          email: any(named: 'email'), password: any(named: 'password')),
    ).thenAnswer((_) async => const Left(AuthFailure('Invalid credentials')));

    final result =
        await useCase(const SignInParams(email: 'a@b.com', password: 'wrong'));
    expect(result, const Left(AuthFailure('Invalid credentials')));
  });
}
