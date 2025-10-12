import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UnderConstructionPage extends StatefulWidget {
  final String title;
  const UnderConstructionPage({super.key, required this.title});

  @override
  State<UnderConstructionPage> createState() => _UnderConstructionPageState();
}

class _UnderConstructionPageState extends State<UnderConstructionPage> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  late final Animation<double> _a = Tween(begin: .6, end: 1.0).animate(_c);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _a,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction, size: 54, color: Colors.white70),
            const SizedBox(height: 8),
            Text('${widget.title} — Under Construction', style: GoogleFonts.inter(fontSize: 18, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}