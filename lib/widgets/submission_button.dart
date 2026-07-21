import 'package:flutter/material.dart';

/// A full-width submit action that prevents repeat taps while work is pending.
class SubmissionButton extends StatelessWidget {
  const SubmissionButton({
    required this.label,
    required this.loadingLabel,
    required this.isSubmitting,
    required this.onPressed,
    this.progressKey,
    super.key,
  });

  final String label;
  final String loadingLabel;
  final bool isSubmitting;
  final VoidCallback? onPressed;
  final Key? progressKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isSubmitting ? null : onPressed,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: isSubmitting
              ? Row(
                  key: const ValueKey('submitting'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      key: progressKey,
                      width: 20,
                      height: 20,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        loadingLabel,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : Text(label, key: const ValueKey('ready')),
        ),
      ),
    );
  }
}
