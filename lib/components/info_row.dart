import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget? additionalChild;
  final Widget? additionalInfo;

  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.additionalChild,
    this.additionalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.green),
            const SizedBox(width: 4),
            Text(text, style: const TextStyle(fontSize: 12)),
          ],
        ),
        if (additionalChild != null) additionalChild!,
        if (additionalInfo != null) additionalInfo!,
      ],
    );
  }
}
