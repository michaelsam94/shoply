import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure_to_message.dart';
import '../../../../core/providers/di_providers.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

final authStateProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
  return AuthNotifier(
    signInUseCase: ref.read(signInUseCaseProvider),
    signUpUseCase: ref.read(signUpUseCaseProvider),
    signOutUseCase: ref.read(signOutUseCaseProvider),
    getCurrentUserUseCase: ref.read(getCurrentUserUseCaseProvider),
  )..checkCurrentUser();
});

class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  AuthNotifier({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AsyncLoading());

  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  Future<void> checkCurrentUser() async {
    final result = await getCurrentUserUseCase(const NoParams());
    state = result.fold(
      (failure) => AsyncError(mapFailureToMessage(failure), StackTrace.current),
      AsyncData.new,
    );
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    final result = await signInUseCase(
      SignInParams(email: email, password: password),
    );
    state = result.fold(
      (failure) => AsyncError(mapFailureToMessage(failure), StackTrace.current),
      AsyncData.new,
    );
  }

  Future<void> signUp(String email, String password, String name) async {
    state = const AsyncLoading();
    final result = await signUpUseCase(
      SignUpParams(email: email, password: password, name: name),
    );
    state = result.fold(
      (failure) => AsyncError(mapFailureToMessage(failure), StackTrace.current),
      AsyncData.new,
    );
  }

  Future<void> signOut() async {
    final result = await signOutUseCase(const NoParams());
    state = result.fold(
      (failure) => AsyncError(mapFailureToMessage(failure), StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}
