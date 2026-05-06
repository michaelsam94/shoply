import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

import '../../../../core/config/env.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/logging/app_logger.dart';
import '../models/user_model.dart';

class SupabaseAuthDatasource {
  SupabaseAuthDatasource(this._client);
  final SupabaseClient _client;

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) throw AuthException('Invalid credentials.');
      return UserModel.fromSupabaseUser(user);
    } catch (e, st) {
      AppLogger.exception(e, st, context: 'SupabaseAuth.signIn');
      debugPrint('[SupabaseAuth.signIn] ${e.runtimeType}: $e');
      throw AuthException(e.toString());
    }
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
        emailRedirectTo: Env.supabaseEmailRedirect.isEmpty
            ? null
            : Env.supabaseEmailRedirect,
      );
      final user = response.user;
      if (user == null) {
        throw AuthException(
          'Sign up did not return a user. If email confirmation is required, '
          'check your inbox or disable confirmations in Supabase '
          '(Authentication → Providers → Email).',
        );
      }
      // Profile row is created by SQL trigger `on_auth_user_created` in
      // `001_initial_schema.sql`. Do not upsert here: with "confirm email"
      // enabled there is often no session yet, so RLS would block client inserts.
      return UserModel.fromSupabaseUser(user);
    } catch (e, st) {
      AppLogger.exception(e, st, context: 'SupabaseAuth.signUp');
      debugPrint('[SupabaseAuth.signUp] ${e.runtimeType}: $e');
      throw AuthException(e.toString());
    }
  }

  Future<Unit> signOut() async {
    try {
      await _client.auth.signOut();
      return unit;
    } catch (e, st) {
      AppLogger.exception(e, st, context: 'SupabaseAuth.signOut');
      throw AuthException(e.toString());
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    return user == null ? null : UserModel.fromSupabaseUser(user);
  }

  Future<Unit> sendPasswordResetEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: Env.supabaseEmailRedirect.isEmpty
            ? null
            : Env.supabaseEmailRedirect,
      );
      return unit;
    } catch (e, st) {
      AppLogger.exception(e, st, context: 'SupabaseAuth.resetPassword');
      throw AuthException(e.toString());
    }
  }
}
