part of '../onboarding_screen.dart';

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry, required this.message});
  final VoidCallback onRetry;
  final String message;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.storage_rounded, size: 48),
              const SizedBox(height: AppSpacing.x4),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.x4),
              _PrimaryButton(label: 'Try again', onPressed: onRetry),
            ],
          ),
        ),
      ),
    ),
  );
}
