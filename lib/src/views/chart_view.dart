import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/models/sleep_schedule_model.dart';
import 'package:sleepfy/src/providers/control_dreams_provider.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sleepfy/src/widgets/my_text.dart';

class ChartView extends StatefulWidget {
  const ChartView({super.key});

  @override
  State<StatefulWidget> createState() => ChartViewState();
}

class ChartViewState extends State<ChartView> {
  @override
  Widget build(BuildContext context) {
    final ControlDreamsProvider prov = Provider.of<ControlDreamsProvider>(context);
    final List<SleepSchedule> sleepSchedules = prov.sleepSchedules;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Constants.surface(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Constants.border(context), width: 1.2),
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
                      color: Constants.surfaceLight(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.bar_chart_rounded,
                      color: Constants.accent(context),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  MyText(
                    'Horas de sueño',
                    color: Constants.textPrimary(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Constants.surfaceLight(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Constants.border(context)),
                ),
                child: MyText(
                  'Esta semana',
                  color: Constants.textSecondary(context),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              data(context, sleepSchedules),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    BuildContext context,
    int x,
    double y,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Constants.kSageGreen,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          width: 16,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 12,
            color: Constants.surfaceLight(context),
          ),
        ),
      ],
    );
  }

  Widget getLeftTitles(BuildContext context, double value, TitleMeta meta) {
    final style = TextStyle(
      color: Constants.textSecondary(context),
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

  Widget getBottomTitles(BuildContext context, double value, TitleMeta meta) {
    final style = TextStyle(
      color: Constants.textSecondary(context),
      fontWeight: FontWeight.w500,
      fontSize: 11.5,
    );
    const List<String> days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

    int index = value.toInt();
    if (index < 0 || index >= days.length) return const SizedBox.shrink();

    return SideTitleWidget(
      meta: meta,
      space: 8,
      child: Text(
        days[index],
        style: style,
      ),
    );
  }

  BarChartData data(BuildContext context, List<SleepSchedule> sleepSchedules) {
    return BarChartData(
      maxY: 12,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Constants.surfaceLight(context),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${rod.toY.toStringAsFixed(1)} horas',
              TextStyle(
                color: Constants.textPrimary(context),
                fontWeight: FontWeight.w600,
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
            getTitlesWidget: (v, m) => getBottomTitles(context, v, m),
            reservedSize: 28,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 28,
            showTitles: true,
            getTitlesWidget: (v, m) => getLeftTitles(context, v, m),
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
          color: Constants.border(context),
          strokeWidth: 1,
          dashArray: [4, 4],
        ),
      ),
      barGroups: List.generate(
        7,
        (i) => makeGroupData(
          context,
          i,
          getDataFromADay(sleepSchedules, i),
        ),
      ),
    );
  }
}

double getDataFromADay(List<SleepSchedule> sleepSchedules, int day) {
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
