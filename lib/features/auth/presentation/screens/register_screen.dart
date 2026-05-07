import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _agree = false;

  String _strength(String value) {
    if (value.length < 8) {
      return 'weak';
    }
    if (RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$').hasMatch(value)) {
      return 'medium';
    }
    if (RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{10,}$')
        .hasMatch(value)) {
      return 'strong';
    }
    return 'weak';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);
    final strength = _strength(_passwordController.text);
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name')),
                  const SizedBox(height: 12),
                  TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 12),
                  TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password')),
                  const SizedBox(height: 8),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Strength: $strength')),
                  const SizedBox(height: 12),
                  TextFormField(
                      controller: _confirmController,
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password')),
                  CheckboxListTile(
                    value: _agree,
                    onChanged: (value) =>
                        setState(() => _agree = value ?? false),
                    title: const Text('I agree to the terms of service'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  PrimaryButton(
                    text: 'Create Account',
                    isLoading: state.isLoading,
                    onPressed: () async {
                      if (!_agree) {
                        return;
                      }
                      if (_passwordController.text != _confirmController.text) {
                        return;
                      }
                      await ref.read(authNotifierProvider.notifier).signUp(
                            _emailController.text.trim(),
                            _passwordController.text,
                            _nameController.text.trim(),
                          );
                      if (!context.mounted) {
                        return;
                      }
                      context.goNamed(AppRoutes.home);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
