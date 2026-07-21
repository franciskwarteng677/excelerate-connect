import 'package:flutter/material.dart';

class AsyncLoadingState extends StatelessWidget {
  const AsyncLoadingState({
    required this.message,
    this.compact = false,
    super.key,
  });

  final String message;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final indicator = const SizedBox(
      width: 28,
      height: 28,
      child: CircularProgressIndicator(strokeWidth: 3),
    );
    final label = Text(
      message,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium,
    );

    return Semantics(
      liveRegion: true,
      label: message,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: compact ? 20 : 36,
          ),
          child: compact
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    indicator,
                    const SizedBox(width: 14),
                    Flexible(child: label),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [indicator, const SizedBox(height: 16), label],
                ),
        ),
      ),
    );
  }
}

class AsyncErrorCard extends StatelessWidget {
  const AsyncErrorCard({
    required this.title,
    required this.message,
    required this.onRetry,
    this.compact = false,
    this.retryButtonKey,
    super.key,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;
  final bool compact;
  final Key? retryButtonKey;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 18 : 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: compact ? 24 : 30,
              backgroundColor: colors.errorContainer,
              foregroundColor: colors.onErrorContainer,
              child: const Icon(Icons.cloud_off_outlined),
            ),
            SizedBox(height: compact ? 12 : 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 18),
            FilledButton.icon(
              key: retryButtonKey,
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class AsyncEmptyCard extends StatelessWidget {
  const AsyncEmptyCard({
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    super.key,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: colors.primaryContainer,
              foregroundColor: colors.primary,
              child: Icon(icon, size: 30),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
