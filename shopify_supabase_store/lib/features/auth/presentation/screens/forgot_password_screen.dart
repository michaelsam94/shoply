import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/di_providers.dart';
import '../../../../shared/widgets/primary_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Send Reset Link',
              isLoading: _loading,
              onPressed: () async {
                setState(() => _loading = true);
                final result = await ref
                    .read(authRepositoryProvider)
                    .sendPasswordResetEmail(_email.text.trim());
                if (!context.mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      result.fold((l) => l.message, (_) => 'Reset link sent'),
                    ),
                  ),
                );
                setState(() => _loading = false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
