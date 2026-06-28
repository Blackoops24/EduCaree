import 'package:flutter/material.dart';

class DashboardFooter extends StatelessWidget {
  const DashboardFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4))),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 700;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              isCompact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_buildSummaryRow(context), const SizedBox(height: 18), _buildLinksRow(context)],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _buildSummaryRow(context)),
                        Expanded(flex: 3, child: _buildLinksRow(context)),
                      ],
                    ),
              const SizedBox(height: 18),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Blackoops.com', style: TextStyle(fontSize: 12)),
                  Text('v1.0.0', key: const Key('footer_version_label'), style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return Wrap(
      spacing: 24,
      runSpacing: 12,
      children: [
        _buildFooterStat('Academic Year', '2026-27', textStyle),
        _buildFooterStat('User Role', 'Admin', textStyle),
      ],
    );
  }

  Widget _buildFooterStat(String label, String value, TextStyle? textStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textStyle?.copyWith(color: Colors.black54, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: textStyle?.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
      ],
    );
  }

  Widget _buildLinksRow(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        TextButton(
          key: const Key('footer_help_link'),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Help Center is available from school administration.'))),
          child: const Text('Help Center'),
        ),
        TextButton(
          key: const Key('footer_support_link'),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact support@educaree.com for assistance.'))),
          child: const Text('Support'),
        ),
        TextButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Documentation is included in the project README.'))),
          child: const Text('Documentation'),
        ),
      ],
    );
  }

}
