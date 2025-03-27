import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:srms/config/constants.dart';

class CelebrationWidget extends StatefulWidget {
  final Widget child;
  final bool active;
  final Duration duration;

  const CelebrationWidget({
    super.key,
    required this.child,
    this.active = false,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<CelebrationWidget> createState() => _CelebrationWidgetState();
}

class _CelebrationWidgetState extends State<CelebrationWidget> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: widget.duration,
    );
    if (widget.active) {
      _confettiController.play();
    }
  }

  @override
  void didUpdateWidget(CelebrationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _confettiController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
            createParticlePath: (size) {
              final path = Path();
              path.addOval(Rect.fromCircle(
                center: Offset.zero,
                radius: size.width / 2,
              ));
              return path;
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
}