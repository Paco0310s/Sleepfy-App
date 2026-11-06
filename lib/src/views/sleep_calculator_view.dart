import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class SleepCalculatorView extends StatefulWidget {
  const SleepCalculatorView({super.key});

  @override
  State<SleepCalculatorView> createState() => _SleepCalculatorViewState();
}

class _SleepCalculatorViewState extends State<SleepCalculatorView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TimeOfDay _targetWakeTime = const TimeOfDay(hour: 7, minute: 0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _formatDateTime(DateTime dt) {
    int hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    if (hour == 0) hour = 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  List<Map<String, dynamic>> _calculateBedtimes(TimeOfDay wake) {
    final now = DateTime.now();
    var wakeDateTime = DateTime(now.year, now.month, now.day, wake.hour, wake.minute);
    if (wakeDateTime.isBefore(now)) {
      wakeDateTime = wakeDateTime.add(const Duration(days: 1));
    }

    // Un ciclo = 90 min. Tiempo promedio en conciliar = 14 min.
    return [
      {
        'cycles': 6,
        'hours': '9 hrs',
        'badge': 'ÓPTIMO',
        'badgeColor': Constants.kMintColor,
        'time': _formatDateTime(wakeDateTime.subtract(const Duration(minutes: (6 * 90) + 14))),
        'desc': 'Descanso profundo y reparación celular completa.',
      },
      {
        'cycles': 5,
        'hours': '7.5 hrs',
        'badge': 'RECOMENDADO',
        'badgeColor': Constants.kSecondaryColor,
        'time': _formatDateTime(wakeDateTime.subtract(const Duration(minutes: (5 * 90) + 14))),
        'desc': 'Ideal para la mayoría de adultos activos.',
      },
      {
        'cycles': 4,
        'hours': '6 hrs',
        'badge': 'ACEPTABLE',
        'badgeColor': Constants.kWarningColor,
        'time': _formatDateTime(wakeDateTime.subtract(const Duration(minutes: (4 * 90) + 14))),
        'desc': 'Suficiente para días ocupados sin fatiga severa.',
      },
      {
        'cycles': 3,
        'hours': '4.5 hrs',
        'badge': 'MÍNIMO',
        'badgeColor': Constants.kErrorColor,
        'time': _formatDateTime(wakeDateTime.subtract(const Duration(minutes: (3 * 90) + 14))),
        'desc': 'Solo en casos excepcionales o siestas largas.',
      },
    ];
  }

  List<Map<String, dynamic>> _calculateWakeTimesFromNow() {
    final now = DateTime.now().add(const Duration(minutes: 14)); // 14 min para conciliar

    return [
      {
        'cycles': 6,
        'hours': '9 hrs',
        'badge': 'ÓPTIMO',
        'badgeColor': Constants.kMintColor,
        'time': _formatDateTime(now.add(const Duration(minutes: 6 * 90))),
        'desc': 'Te despertarás al final de tu 6to ciclo REM.',
      },
      {
        'cycles': 5,
        'hours': '7.5 hrs',
        'badge': 'RECOMENDADO',
        'badgeColor': Constants.kSecondaryColor,
        'time': _formatDateTime(now.add(const Duration(minutes: 5 * 90))),
        'desc': 'Balance perfecto entre descanso y productividad.',
      },
      {
        'cycles': 4,
        'hours': '6 hrs',
        'badge': 'ACEPTABLE',
        'badgeColor': Constants.kWarningColor,
        'time': _formatDateTime(now.add(const Duration(minutes: 4 * 90))),
        'desc': 'Despertarás ligero sin interrumpir el ciclo profundo.',
      },
      {
        'cycles': 3,
        'hours': '4.5 hrs',
        'badge': 'MÍNIMO',
        'badgeColor': Constants.kErrorColor,
        'time': _formatDateTime(now.add(const Duration(minutes: 3 * 90))),
        'desc': 'Descanso básico para emergencias.',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kBackgroundColor,
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Calculadora de Sueño'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Constants.kSecondaryColor,
          labelColor: Constants.kSecondaryColor,
          unselectedLabelColor: Constants.kTextSecondaryColor,
          tabs: const [
            Tab(text: 'Hora de Despertar'),
            Tab(text: 'Dormir Ahora'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWakeTimeTab(),
          _buildSleepNowTab(),
        ],
      ),
    );
  }

  Widget _buildWakeTimeTab() {
    final bedtimes = _calculateBedtimes(_targetWakeTime);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        // Selector de hora de despertar
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Constants.kSurfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Constants.kBorderColor),
          ),
          child: Column(
            children: [
              const MyText(
                '¿A qué hora quieres despertar?',
                fontSize: 14,
                color: Constants.kTextSecondaryColor,
              ),
              const Gap(10),
              GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _targetWakeTime,
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Constants.kSecondaryColor,
                            surface: Constants.kSurfaceColor,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() => _targetWakeTime = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Constants.kSurfaceLightColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Constants.kSecondaryColor.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.alarm_rounded, color: Constants.kSecondaryColor, size: 28),
                      const Gap(12),
                      MyText(
                        _formatTimeOfDay(_targetWakeTime),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Constants.kTextColor,
                      ),
                      const Gap(8),
                      const Icon(Icons.edit_rounded, color: Constants.kTextSecondaryColor, size: 18),
                    ],
                  ),
                ),
              ),
              const Gap(12),
              const MyText(
                'Calculamos los ciclos de 90 min + 14 min para quedarte dormido.',
                fontSize: 12,
                color: Constants.kTextSecondaryColor,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Gap(20),

        const Padding(
          padding: EdgeInsets.only(left: 6, bottom: 8),
          child: MyText(
            'DEBERÍAS ACOSTARTE A ALGUNA DE ESTAS HORAS:',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Constants.kTextSecondaryColor,
          ),
        ),

        ...bedtimes.map((item) => _buildResultCard(item)),
      ],
    );
  }

  Widget _buildSleepNowTab() {
    final wakeTimes = _calculateWakeTimesFromNow();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E293B), Color(0xFF1E1B4B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Constants.kPrimaryColor.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Constants.kPrimaryColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.nightlight_round, color: Constants.kSecondaryColor, size: 30),
              ),
              const Gap(14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      'Si te duermes en este momento...',
                      color: Constants.kTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    Gap(4),
                    MyText(
                      'Programa tu alarma a una de estas horas para despertar sin pesadez.',
                      color: Constants.kTextSecondaryColor,
                      fontSize: 12.5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Gap(20),

        const Padding(
          padding: EdgeInsets.only(left: 6, bottom: 8),
          child: MyText(
            'HORAS RECOMENDADAS PARA DESPERTAR:',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Constants.kTextSecondaryColor,
          ),
        ),

        ...wakeTimes.map((item) => _buildResultCard(item)),
      ],
    );
  }

  Widget _buildResultCard(Map<String, dynamic> item) {
    final Color badgeColor = item['badgeColor'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Constants.kSurfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Constants.kBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
                      ),
                      child: MyText(
                        item['badge'],
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: badgeColor,
                      ),
                    ),
                    const Gap(8),
                    MyText(
                      '${item['cycles']} ciclos (${item['hours']})',
                      fontSize: 12.5,
                      color: Constants.kTextSecondaryColor,
                    ),
                  ],
                ),
                const Gap(8),
                MyText(
                  item['desc'],
                  fontSize: 12,
                  color: Constants.kTextSecondaryColor,
                ),
              ],
            ),
          ),
          const Gap(12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Constants.kSurfaceLightColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
            ),
            child: MyText(
              item['time'],
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Constants.kTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
