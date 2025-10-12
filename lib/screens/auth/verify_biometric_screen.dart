import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/widgets/app_button.dart';
import 'package:paynest_mobile/screens/home/home_shell.dart';

// --- Main Screen Widget (No changes here) ---
class VerifyBiometricScreen extends StatefulWidget {
  final String nida;
  final String method; // 'fingerprint' or 'face'

  const VerifyBiometricScreen({
    super.key,
    required this.nida,
    required this.method,
  });

  @override
  State<VerifyBiometricScreen> createState() => _VerifyBiometricScreenState();
}

class _VerifyBiometricScreenState extends State<VerifyBiometricScreen> with SingleTickerProviderStateMixin {
  bool registered = false;
  bool checking = false;

  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _doRegister() async {
    setState(() => checking = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    setState(() => registered = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration successful ✅')),
    );
    setState(() => checking = false);
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF14B8A6).withOpacity(.18),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF2DD4BF).withOpacity(.35)),
                ),
                child: const Icon(Icons.fingerprint, color: Color(0xFF99F6E4)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PayNest', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700)),
                  Text('Plan. Pay. Grow.', style: GoogleFonts.inter(color: Colors.white70)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text('Secure your account', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w600)),
          Text('NIDA: ${widget.nida}\nMethod: ${widget.method == 'fingerprint' ? 'Fingerprint' : 'Face ID'}',
              style: GoogleFonts.inter(color: Colors.white70)),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              border: Border.all(color: Colors.white.withOpacity(.1)),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: widget.method == 'fingerprint'
                      ? _GlowingFingerprint(animation: _animationController)
                      : _FaceCameraScanner(animation: _animationController),
                ),
                const SizedBox(height: 12),
                Text(
                  'Place your ${widget.method == 'fingerprint' ? 'finger on the sensor' : 'face within the frame'}',
                  style: GoogleFonts.inter(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                AppButton(
                  label: checking ? 'Authorizing…' : 'Verify now',
                  icon: Icons.verified_user,
                  onPressed: checking ? null : _doRegister,
                ),
                const SizedBox(height: 10),
                if (registered)
                  AppButton(
                    label: 'Login to PayNest',
                    icon: Icons.login,
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const HomeShell()),
                      (_) => false,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Animated Glowing Fingerprint Widget (No changes here) ---
class _GlowingFingerprint extends StatelessWidget {
  final Animation<double> animation;
  const _GlowingFingerprint({required this.animation});
  @override
  Widget build(BuildContext context) {
    final tween = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 1),
    ]);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final glowValue = tween.animate(animation).value;
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF99F6E4).withOpacity(0.5 * glowValue),
                blurRadius: 15.0 * glowValue,
                spreadRadius: 7.5 * glowValue,
              ),
            ],
          ),
          child: const Icon(Icons.fingerprint, size: 72, color: Color(0xFF99F6E4)),
        );
      },
    );
  }
}

// --- NEW: StatefulWidget for the Real-Time Camera ---
class _FaceCameraScanner extends StatefulWidget {
  final Animation<double> animation;
  const _FaceCameraScanner({required this.animation});

  @override
  State<_FaceCameraScanner> createState() => _FaceCameraScannerState();
}

class _FaceCameraScannerState extends State<_FaceCameraScanner> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // 1. Get a list of available cameras.
    final cameras = await availableCameras();
    // 2. Select the front camera.
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first, // Fallback to the first camera if no front camera is found
    );

    // 3. Create a CameraController.
    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium, // Use medium resolution for performance
    );

    // 4. Initialize the controller. This returns a Future.
    _initializeControllerFuture = _cameraController!.initialize();
    
    // We need to call setState to rebuild the widget with the initialized controller.
    if(mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // 5. IMPORTANT: Dispose of the controller when the widget is disposed.
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // --- Use FutureBuilder to display loading indicator while camera is initializing ---
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && _cameraController != null && _cameraController!.value.isInitialized) {
                  // If the Future is complete, display the camera preview.
                  return CameraPreview(_cameraController!);
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                }
              },
            ),
            // Animated scanning line (on top of the camera preview)
            AnimatedBuilder(
              animation: widget.animation,
              builder: (context, child) {
                return Positioned(
                  top: widget.animation.value * 130,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2DD4BF),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2DD4BF).withOpacity(0.7),
                          blurRadius: 6,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

