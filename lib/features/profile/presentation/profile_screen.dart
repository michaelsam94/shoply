import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../shared/widgets/tab_page_scaffold.dart';
import '../../auth/application/auth_notifier.dart';
import 'providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    return TabPageScaffold(
      title: 'Profile',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              profileAsync.valueOrNull?.email.isNotEmpty == true
                  ? profileAsync.valueOrNull!.email
                  : 'Manage your account settings and sign out securely.',
            ),
            if ((profileAsync.valueOrNull?.fullName ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Name: ${profileAsync.valueOrNull!.fullName}'),
            ],
            const SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) context.goNamed(AppRoutes.login);
              },
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
