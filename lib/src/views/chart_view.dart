import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/models/sleep_schedule_model.dart';
import 'package:sleepfy/src/providers/control_dreams_provider.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartView extends StatefulWidget {
  const ChartView({super.key});

  final Color barBackgroundColor = Constants.kSurfaceLightColor;
  final Color barColor = Constants.kSecondaryColor;

  @override
  State<StatefulWidget> createState() => ChartViewState();
}

class ChartViewState extends State<ChartView> {
  @override
  Widget build(BuildContext context) {
    final ControlDreamsProvider prov = Provider.of<ControlDreamsProvider>(context);
    final List<SleepSchedule> sleepSchedules = prov.sleepSchedules;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Constants.kSurfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Constants.kBorderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Constants.kSecondaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.bar_chart_rounded,
                      color: Constants.kSecondaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Horas de sueño',
                    style: TextStyle(
                      color: Constants.kTextColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Constants.kSurfaceLightColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Constants.kBorderColor),
                ),
                child: const Text(
                  'Esta semana',
                  style: TextStyle(
                    color: Constants.kTextSecondaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AspectRatio(
            aspectRatio: 1.4,
            child: BarChart(
              data(sleepSchedules),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: const LinearGradient(
            colors: [Constants.kSecondaryColor, Constants.kPrimaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          width: 18,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 12,
            color: Constants.kSurfaceLightColor.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Constants.kTextSecondaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 11,
    );

    if (value == 0 || value == 4 || value == 8 || value == 12) {
      return SideTitleWidget(
        meta: meta,
        child: Text(
          '${value.toInt()}h',
          style: style,
          textAlign: TextAlign.center,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Constants.kTextSecondaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 12,
    );
    List<String> days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

    int index = value.toInt();
    if (index < 0 || index >= days.length) return const SizedBox.shrink();

    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: Text(
        days[index],
        style: style,
      ),
    );
  }

  BarChartData data(List<SleepSchedule> sleepSchedules) {
    return BarChartData(
      maxY: 12,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Constants.kSurfaceLightColor,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${rod.toY.toInt()} horas',
              const TextStyle(
                color: Constants.kTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getBottomTitles,
            reservedSize: 32,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 32,
            showTitles: true,
            getTitlesWidget: getLeftTitles,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 4,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Constants.kBorderColor.withValues(alpha: 0.5),
          strokeWidth: 1,
          dashArray: [4, 4],
        ),
      ),
      barGroups: List.generate(
        7,
        (i) => makeGroupData(
          i,
          getDataFromADay(sleepSchedules, i),
        ),
      ),
    );
  }
}

double getDataFromADay(List<SleepSchedule> sleepSchedules, int day) {
  // Lunes
  final DateTime startWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  for (final SleepSchedule sleepSchedule in sleepSchedules) {
    final DateTime end = sleepSchedule.end;

    final DateTime now = startWeek.add(Duration(days: day));

    if (twoDatesAreTheSameDay(now, end)) {
      return getHoursDifference(sleepSchedule.start, sleepSchedule.end);
    }
  }

  return 0;
}

bool twoDatesAreTheSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}

double getHoursDifference(DateTime start, DateTime end) {
  final diffMinutes = end.difference(start).inMinutes;
  final hours = diffMinutes / 60.0;
  return hours > 0 ? (hours > 24 ? 24.0 : hours) : 0.0;
}
