import 'package:flutter/material.dart';

import 'env.dart';

/// Shown when the app was built without `--dart-define` values for Supabase.
class MissingEnvApp extends StatelessWidget {
  const MissingEnvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Configuration required')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: SelectableText.rich(
            TextSpan(
              style: const TextStyle(fontSize: 15, height: 1.5),
              children: [
                const TextSpan(
                  text:
                      'Supabase was not configured at build time. '
                      'SHOPIFY_* and SUPABASE_* are injected with ',
                ),
                const TextSpan(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  text: '--dart-define',
                ),
                const TextSpan(
                  text: ' (or use the helper script).\n\n'
                      'Run from the project root:\n\n',
                ),
                const TextSpan(
                  text: '  bash scripts/run_dev.sh -d <device_id>\n\n',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                const TextSpan(
                  text:
                      'Example:\n  bash scripts/run_dev.sh -d chrome\n'
                      '  bash scripts/run_dev.sh -d macos\n\n'
                      'Ensure ',
                ),
                const TextSpan(
                  text: '.env',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: ' exists with SUPABASE_URL and SUPABASE_ANON_KEY '
                      '(publishable key).\n\n'
                      'Current compile-time values:\n'
                      '  SUPABASE_URL length: ',
                ),
                TextSpan(
                  text: '${Env.supabaseUrl.length}\n',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '  SUPABASE_ANON_KEY length: '),
                TextSpan(
                  text: '${Env.supabaseAnonKey.length}\n',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown when SUPABASE_URL / key are still example placeholders (DNS/auth fails).
class PlaceholderSupabaseApp extends StatelessWidget {
  const PlaceholderSupabaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Fix Supabase URL')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: SelectableText.rich(
            TextSpan(
              style: const TextStyle(fontSize: 15, height: 1.5),
              children: [
                const TextSpan(
                  text: 'The app is using a ',
                ),
                const TextSpan(
                  text: 'placeholder',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: ' Supabase URL (e.g. ',
                ),
                const TextSpan(
                  text: 'your-project.supabase.co',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                const TextSpan(
                  text:
                      ').\n\n'
                      'That hostname does not exist, so sign-in fails with '
                      '"Failed host lookup".\n\n'
                      '1. Open Supabase → Project Settings → API.\n'
                      '2. Copy the real ',
                ),
                const TextSpan(
                  text: 'Project URL',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: ' (looks like ',
                ),
                const TextSpan(
                  text: 'https://xxxxx.supabase.co',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                const TextSpan(
                  text: ') and the ',
                ),
                const TextSpan(
                  text: 'Publishable',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text:
                      ' API key.\n'
                      '3. Put them in ',
                ),
                const TextSpan(
                  text: '.env',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text:
                      ' as SUPABASE_URL and SUPABASE_ANON_KEY.\n'
                      '4. Regenerate defines and ',
                ),
                const TextSpan(
                  text: 'fully restart',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: ' (hot reload is not enough):\n\n',
                ),
                const TextSpan(
                  text: '  bash scripts/generate_dart_defines_json.sh\n'
                      '  flutter run -d <device> --dart-define-from-file=dart_defines.json\n\n'
                      'Compile-time URL baked in now:\n',
                ),
                TextSpan(
                  text: Env.supabaseUrl.isEmpty ? '(empty)' : Env.supabaseUrl,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
