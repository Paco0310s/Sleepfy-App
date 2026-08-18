import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/models/sleep_schedule_model.dart';
import 'package:sleepfy/src/providers/control_dreams_provider.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartView extends StatefulWidget {
  const ChartView({super.key});

  final Color barBackgroundColor = Constants.kBackgroundColor;
  final Color barColor = Constants.kPrimaryColor;

  @override
  State<StatefulWidget> createState() => ChartViewState();
}

class ChartViewState extends State<ChartView> {
  @override
  Widget build(BuildContext context) {
    final ControlDreamsProvider prov = Provider.of<ControlDreamsProvider>(context);
    final List<SleepSchedule> sleepSchedules = prov.sleepSchedules;

    return AspectRatio(
      aspectRatio: 1.1,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Horas de sueño',
              style: TextStyle(
                color: Constants.kBackgroundColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: BarChart(
                data(sleepSchedules),
              ),
            ),
          ],
        ),
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
          // color: isBeforeOrToday(x + 1) ? Colors.transparent : widget.barColor,
          color: widget.barColor,
          borderRadius: BorderRadius.zero,
          // borderDashArray: isBeforeOrToday(x + 1) ? [5, 5] : null,
          borderDashArray: null,
          width: 22,
          borderSide: BorderSide(color: widget.barColor, width: 2.0),
        ),
      ],
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Constants.kBackgroundColor,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    return SideTitleWidget(
      meta: meta,
      // axisSide: meta.axisSide,
      child: Text(
        '${value.toInt()}',
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Constants.kBackgroundColor,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    List<String> days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

    Widget text = Text(
      days[value.toInt()],
      style: style,
    );

    return SideTitleWidget(
      meta: meta,
      // axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartData randomData() {
    return BarChartData(
      maxY: 12,
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getBottomTitles,
            reservedSize: 35,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 40,
            showTitles: true,
            getTitlesWidget: getLeftTitles,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(
        7,
        (i) => makeGroupData(
          i,
          Random().nextInt(14).toDouble() + 10,
        ),
      ),
      gridData: const FlGridData(show: false),
    );
  }

  BarChartData data(List<SleepSchedule> sleepSchedules) {
    return BarChartData(
      maxY: 12,
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getBottomTitles,
            reservedSize: 35,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 40,
            showTitles: true,
            getTitlesWidget: getLeftTitles,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(
        7,
        (i) => makeGroupData(
          i,
          getDataFromADay(sleepSchedules, i),
        ),
      ),
      gridData: const FlGridData(show: false),
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
  return end.difference(start).inHours.toDouble();
}

// bool isBeforeOrToday(int x) {
//   final DateTime dateNow = DateTime.now();

//   final day = 6;

//   return x > day;
// }
