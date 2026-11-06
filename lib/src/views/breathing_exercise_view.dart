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
        // Se mantiene expandido
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

  Color get _phaseColor {
    switch (_phase) {
      case BreathingPhase.inhale:
        return Constants.kMintColor;
      case BreathingPhase.hold:
        return const Color(0xFFFBBF24); // Oro / Ámbar
      case BreathingPhase.exhale:
        return Constants.kSecondaryColor;
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
    return Scaffold(
      backgroundColor: Constants.kBackgroundColor,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Constants.kSurfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Constants.kBorderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.air_rounded, color: _phaseColor, size: 18),
                    const Gap(8),
                    MyText(
                      'Ciclo $_currentCycle de $_maxCycles',
                      color: Constants.kTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Orbe animado de respiración
              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  // Tamaño base 160 -> se expande hasta 260
                  final double scale = _phase == BreathingPhase.hold
                      ? 1.0
                      : (_phase == BreathingPhase.inhale ? _animController.value : 1.0 - _animController.value);
                  final double size = 160 + (scale * 100);

                  return Center(
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            _phaseColor.withValues(alpha: 0.35),
                            _phaseColor.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                        ),
                        border: Border.all(
                          color: _phaseColor.withValues(alpha: 0.8),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _phaseColor.withValues(alpha: 0.35),
                            blurRadius: 35,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyText(
                              _isRunning ? '$_secondsLeft' : (_isFinished ? '✓' : '4-7-8'),
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            if (_isRunning) ...[
                              const Gap(4),
                              MyText(
                                _phaseTitle,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _phaseColor,
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
                const Icon(Icons.check_circle_rounded, color: Constants.kMintColor, size: 48),
                const Gap(12),
                const MyText(
                  '¡Excelente trabajo!',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Constants.kTextColor,
                ),
                const Gap(6),
                const MyText(
                  'Tu ritmo cardíaco se ha desacelerado. Ahora cierra los ojos y disponte a descansar.',
                  fontSize: 13,
                  color: Constants.kTextSecondaryColor,
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                MyText(
                  _isRunning ? _phaseSubtitle : 'Técnica médica del Dr. Andrew Weil para reducir la ansiedad y dormir rápido.',
                  fontSize: 14,
                  color: Constants.kTextSecondaryColor,
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
                      icon: const Icon(Icons.refresh_rounded, color: Constants.kTextSecondaryColor, size: 28),
                      tooltip: 'Reiniciar',
                      onPressed: _reset,
                    ),
                    const Gap(16),
                    Expanded(
                      child: MyButton(
                        text: 'Pausar',
                        color: Constants.kSurfaceLightColor,
                        onPressed: _pause,
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: MyButton(
                        text: _isFinished ? 'Repetir ejercicio' : (_animController.value > 0 ? 'Continuar' : 'Iniciar respiración'),
                        color: Constants.kPrimaryColor,
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

