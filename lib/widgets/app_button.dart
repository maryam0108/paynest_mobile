import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool secondary;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.secondary = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bg = secondary ? Colors.white.withOpacity(.08) : const Color(0xFF14B8A6);
    final br = secondary ? Colors.white.withOpacity(.12) : const Color(0xFF2DD4BF);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: bg,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: br, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 8),
          ],
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
