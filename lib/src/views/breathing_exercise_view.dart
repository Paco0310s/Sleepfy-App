import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

enum BreathingPhase { inhale, hold, exhale }

class BreathingExerciseView extends StatefulWidget {
  const BreathingExerciseView({super.key});

  @override
  State<BreathingExerciseView> createState() => _BreathingExerciseViewState();
}

class _BreathingExerciseViewState extends State<BreathingExerciseView> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  Timer? _timer;

  BreathingPhase _phase = BreathingPhase.inhale;
  int _secondsLeft = 4;
  int _currentCycle = 1;
  final int _maxCycles = 4;
  bool _isRunning = false;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _start() {
    setState(() {
      _isRunning = true;
      _isFinished = false;
    });
    _runPhase(BreathingPhase.inhale);
  }

  void _pause() {
    _timer?.cancel();
    _animController.stop();
    setState(() {
      _isRunning = false;
    });
  }

  void _reset() {
    _timer?.cancel();
    _animController.reset();
    setState(() {
      _isRunning = false;
      _isFinished = false;
      _phase = BreathingPhase.inhale;
      _secondsLeft = 4;
      _currentCycle = 1;
    });
  }

  void _runPhase(BreathingPhase phase) {
    _timer?.cancel();
    HapticFeedback.lightImpact();

    setState(() {
      _phase = phase;
    });

    switch (phase) {
      case BreathingPhase.inhale:
        _secondsLeft = 4;
        _animController.duration = const Duration(seconds: 4);
        _animController.forward(from: 0.0);
        break;
      case BreathingPhase.hold:
        _secondsLeft = 7;
        _animController.duration = const Duration(seconds: 7);
        break;
      case BreathingPhase.exhale:
        _secondsLeft = 8;
        _animController.duration = const Duration(seconds: 8);
        _animController.reverse(from: 1.0);
        break;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 1) {
          _secondsLeft--;
        } else {
          _timer?.cancel();
          _nextPhase();
        }
      });
    });
  }

  void _nextPhase() {
    if (_phase == BreathingPhase.inhale) {
      _runPhase(BreathingPhase.hold);
    } else if (_phase == BreathingPhase.hold) {
      _runPhase(BreathingPhase.exhale);
    } else if (_phase == BreathingPhase.exhale) {
      if (_currentCycle < _maxCycles) {
        setState(() {
          _currentCycle++;
        });
        _runPhase(BreathingPhase.inhale);
      } else {
        HapticFeedback.heavyImpact();
        setState(() {
          _isRunning = false;
          _isFinished = true;
        });
      }
    }
  }

  Color _getPhaseColor(BuildContext context) {
    switch (_phase) {
      case BreathingPhase.inhale:
        return Constants.kSageGreen;
      case BreathingPhase.hold:
        return const Color(0xFFD49E3D);
      case BreathingPhase.exhale:
        return Constants.accent(context);
    }
  }

  String get _phaseTitle {
    switch (_phase) {
      case BreathingPhase.inhale:
        return 'INHALA';
      case BreathingPhase.hold:
        return 'MANTÉN';
      case BreathingPhase.exhale:
        return 'EXHALA';
    }
  }

  String get _phaseSubtitle {
    switch (_phase) {
      case BreathingPhase.inhale:
        return 'Respira hondo y lento por la nariz';
      case BreathingPhase.hold:
        return 'Retén el aire con calma en tu pecho';
      case BreathingPhase.exhale:
        return 'Suelta suavemente el aire por la boca';
    }
  }

  @override
  Widget build(BuildContext context) {
    final phaseColor = _getPhaseColor(context);

    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Respiración 4-7-8'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Indicador de ciclo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: Constants.surface(context),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Constants.border(context)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.air_rounded, color: phaseColor, size: 17),
                    const Gap(8),
                    MyText(
                      'Ciclo $_currentCycle de $_maxCycles',
                      color: Constants.textPrimary(context),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Orbe animado de respiración
              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  final double scale = _phase == BreathingPhase.hold
                      ? 1.0
                      : (_phase == BreathingPhase.inhale ? _animController.value : 1.0 - _animController.value);
                  final double size = 150 + (scale * 90);

                  return Center(
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: phaseColor.withValues(alpha: 0.12),
                        border: Border.all(
                          color: phaseColor.withValues(alpha: 0.7),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyText(
                              _isRunning ? '$_secondsLeft' : (_isFinished ? '✓' : '4-7-8'),
                              fontSize: 44,
                              fontWeight: FontWeight.w600,
                              color: Constants.textPrimary(context),
                            ),
                            if (_isRunning) ...[
                              const Gap(4),
                              MyText(
                                _phaseTitle,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                                color: phaseColor,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              // Subtítulo instructivo
              if (_isFinished) ...[
                const Icon(Icons.check_circle_outline_rounded, color: Constants.kSageGreen, size: 44),
                const Gap(12),
                MyText(
                  '¡Excelente trabajo!',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Constants.textPrimary(context),
                ),
                const Gap(6),
                MyText(
                  'Tu ritmo cardíaco se ha desacelerado. Ahora cierra los ojos y disponte a descansar.',
                  fontSize: 13,
                  color: Constants.textSecondary(context),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                MyText(
                  _isRunning ? _phaseSubtitle : 'Técnica médica del Dr. Andrew Weil para reducir la tensión y conciliar el sueño.',
                  fontSize: 13.5,
                  color: Constants.textSecondary(context),
                  textAlign: TextAlign.center,
                ),
              ],

              const Gap(32),

              // Controles
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isRunning) ...[
                    IconButton(
                      icon: Icon(Icons.refresh_rounded, color: Constants.textSecondary(context), size: 26),
                      tooltip: 'Reiniciar',
                      onPressed: _reset,
                    ),
                    const Gap(14),
                    Expanded(
                      child: MyButton(
                        outlined: true,
                        text: 'Pausar',
                        onPressed: _pause,
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: MyButton(
                        text: _isFinished ? 'Repetir ejercicio' : (_animController.value > 0 ? 'Continuar' : 'Iniciar respiración'),
                        onPressed: _start,
                      ),
                    ),
                  ],
                ],
              ),
              const Gap(10),
            ],
          ),
        ),
      ),
    );
  }
}
