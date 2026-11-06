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

    return [
      {
        'cycles': 6,
        'hours': '9 hrs',
        'badge': 'ÓPTIMO',
        'badgeColor': Constants.kSageGreen,
        'time': _formatDateTime(wakeDateTime.subtract(const Duration(minutes: (6 * 90) + 14))),
        'desc': 'Descanso profundo y reparación celular completa.',
      },
      {
        'cycles': 5,
        'hours': '7.5 hrs',
        'badge': 'RECOMENDADO',
        'badgeColor': Constants.kSageGreen,
        'time': _formatDateTime(wakeDateTime.subtract(const Duration(minutes: (5 * 90) + 14))),
        'desc': 'Ideal para la mayoría de adultos activos.',
      },
      {
        'cycles': 4,
        'hours': '6 hrs',
        'badge': 'ACEPTABLE',
        'badgeColor': const Color(0xFFD49E3D),
        'time': _formatDateTime(wakeDateTime.subtract(const Duration(minutes: (4 * 90) + 14))),
        'desc': 'Suficiente para días ocupados sin fatiga severa.',
      },
      {
        'cycles': 3,
        'hours': '4.5 hrs',
        'badge': 'MÍNIMO',
        'badgeColor': Constants.kSoftRose,
        'time': _formatDateTime(wakeDateTime.subtract(const Duration(minutes: (3 * 90) + 14))),
        'desc': 'Solo en casos excepcionales o siestas largas.',
      },
    ];
  }

  List<Map<String, dynamic>> _calculateWakeTimesFromNow() {
    final now = DateTime.now().add(const Duration(minutes: 14));

    return [
      {
        'cycles': 6,
        'hours': '9 hrs',
        'badge': 'ÓPTIMO',
        'badgeColor': Constants.kSageGreen,
        'time': _formatDateTime(now.add(const Duration(minutes: 6 * 90))),
        'desc': 'Te despertarás al final de tu 6to ciclo REM.',
      },
      {
        'cycles': 5,
        'hours': '7.5 hrs',
        'badge': 'RECOMENDADO',
        'badgeColor': Constants.kSageGreen,
        'time': _formatDateTime(now.add(const Duration(minutes: 5 * 90))),
        'desc': 'Balance ideal entre descanso y productividad.',
      },
      {
        'cycles': 4,
        'hours': '6 hrs',
        'badge': 'ACEPTABLE',
        'badgeColor': const Color(0xFFD49E3D),
        'time': _formatDateTime(now.add(const Duration(minutes: 4 * 90))),
        'desc': 'Despertarás ligero sin interrumpir el ciclo profundo.',
      },
      {
        'cycles': 3,
        'hours': '4.5 hrs',
        'badge': 'MÍNIMO',
        'badgeColor': Constants.kSoftRose,
        'time': _formatDateTime(now.add(const Duration(minutes: 3 * 90))),
        'desc': 'Descanso básico para emergencias.',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Calculadora de Sueño'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Constants.accent(context),
          labelColor: Constants.textPrimary(context),
          unselectedLabelColor: Constants.textSecondary(context),
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
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Constants.surface(context),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Constants.border(context)),
          ),
          child: Column(
            children: [
              MyText(
                '¿A qué hora quieres despertar?',
                fontSize: 13.5,
                color: Constants.textSecondary(context),
              ),
              const Gap(10),
              GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _targetWakeTime,
                  );
                  if (picked != null) {
                    setState(() => _targetWakeTime = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                  decoration: BoxDecoration(
                    color: Constants.surfaceLight(context),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Constants.border(context)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.alarm_rounded, color: Constants.accent(context), size: 24),
                      const Gap(12),
                      MyText(
                        _formatTimeOfDay(_targetWakeTime),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Constants.textPrimary(context),
                      ),
                      const Gap(8),
                      Icon(Icons.edit_rounded, color: Constants.textSecondary(context), size: 16),
                    ],
                  ),
                ),
              ),
              const Gap(10),
              MyText(
                'Calculamos ciclos de 90 min + 14 min para quedarte dormido.',
                fontSize: 11.5,
                color: Constants.textSecondary(context),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Gap(18),

        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: MyText(
            'DEBERÍAS ACOSTARTE A ALGUNA DE ESTAS HORAS:',
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: Constants.textSecondary(context),
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
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Constants.surface(context),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Constants.border(context)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Constants.surfaceLight(context),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.bedtime_outlined, color: Constants.accent(context), size: 24),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      'Si te duermes en este momento...',
                      color: Constants.textPrimary(context),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    const Gap(2),
                    MyText(
                      'Programa tu alarma a una de estas horas para despertar sin pesadez.',
                      color: Constants.textSecondary(context),
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Gap(18),

        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: MyText(
            'HORAS RECOMENDADAS PARA DESPERTAR:',
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: Constants.textSecondary(context),
          ),
        ),

        ...wakeTimes.map((item) => _buildResultCard(item)),
      ],
    );
  }

  Widget _buildResultCard(Map<String, dynamic> item) {
    final Color badgeColor = item['badgeColor'];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Constants.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Constants.border(context)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: MyText(
                        item['badge'],
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: badgeColor,
                      ),
                    ),
                    const Gap(8),
                    MyText(
                      '${item['cycles']} ciclos (${item['hours']})',
                      fontSize: 12,
                      color: Constants.textSecondary(context),
                    ),
                  ],
                ),
                const Gap(6),
                MyText(
                  item['desc'],
                  fontSize: 12,
                  color: Constants.textSecondary(context),
                ),
              ],
            ),
          ),
          const Gap(12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: Constants.surfaceLight(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Constants.border(context)),
            ),
            child: MyText(
              item['time'],
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Constants.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }
}
