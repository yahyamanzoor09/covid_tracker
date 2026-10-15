import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  final Object? error;
  const ErrorState({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    size: 46,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Unable to load data. Please try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: onRetry,
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        // decoration: TextDecoration.underline,
                        letterSpacing: 1,
                        fontSize: 16,
                        color: Color.fromARGB(190, 255, 255, 255),
                      ),
                    ),
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
