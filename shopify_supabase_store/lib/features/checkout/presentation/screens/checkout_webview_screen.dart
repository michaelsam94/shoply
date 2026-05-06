import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/router/app_router.dart';
import '../../../../features/cart/presentation/providers/cart_provider.dart';

class CheckoutWebviewScreen extends ConsumerStatefulWidget {
  const CheckoutWebviewScreen({required this.checkoutUrl, super.key});
  final String checkoutUrl;

  @override
  ConsumerState<CheckoutWebviewScreen> createState() =>
      _CheckoutWebviewScreenState();
}

class _CheckoutWebviewScreenState extends ConsumerState<CheckoutWebviewScreen> {
  WebViewController? _controller;
  bool _loading = true;
  bool _invalidUrl = false;
  bool _handledCompletion = false;

  @override
  void initState() {
    super.initState();
    final uri = Uri.tryParse(widget.checkoutUrl);
    if (uri == null ||
        !(uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'))) {
      _invalidUrl = true;
      _loading = false;
      return;
    }

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onNavigationRequest: (request) {
            if (!_handledCompletion &&
                (request.url.contains('/thank_you') ||
                    request.url.contains('/orders/'))) {
              _handledCompletion = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                ref.read(cartProvider.notifier).clearCart();
                context.goNamed(AppRoutes.home);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Checkout completed successfully')),
                );
              });
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    controller.loadRequest(uri);
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    if (_invalidUrl) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('Invalid checkout link. Go back and try again.'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller!),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
