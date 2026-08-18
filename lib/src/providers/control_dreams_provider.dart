import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/widgets.dart';
import 'package:sleepfy/controllers/control_dreams_controller.dart';
import 'package:sleepfy/models/sleep_schedule_model.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';

class ControlDreamsProvider extends ChangeNotifier {
  Time _timeStart = Time(hour: 22, minute: 00, second: 00);
  Time _timeEnd = Time(hour: 6, minute: 00, second: 00);

  Time get timeStart => _timeStart;
  Time get timeEnd => _timeEnd;

  List<SleepSchedule> _sleepSchedules = [];

  List<SleepSchedule> get sleepSchedules => _sleepSchedules;

  bool loadingSendSchedule = false;
  bool loadingGetSchedules = false;

  ControlDreamsProvider() {
    init();
  }

  void init() {
    getSleepSchedules();
  }

  Future<void> getSleepSchedules() async {
    loadingGetSchedules = true;
    notifyListeners();

    _sleepSchedules = await ControlDreamsController.getSleepSchedules();

    loadingGetSchedules = false;
    notifyListeners();
  }

  void onTimeStartChanged(Time newTime) {
    _timeStart = newTime;
    notifyListeners();
  }

  void onTimeEndChanged(Time newTime) {
    _timeEnd = newTime;
    notifyListeners();
  }

  void saveData() async {
    final DateTime now = DateTime.now();

    final DateTime start = DateTime(
      now.year,
      now.month,
      now.day - 1,
      _timeStart.hour,
      _timeStart.minute,
    );

    final DateTime end = DateTime(
      now.year,
      now.month,
      now.day,
      _timeEnd.hour,
      _timeEnd.minute,
    );

    final data = {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'userId': UserPreferences.id,
    };

    loadingSendSchedule = true;
    notifyListeners();

    final SleepSchedule? newSleepSchedule = await ControlDreamsController.sendControlDreams(data);

    loadingSendSchedule = false;

    if (newSleepSchedule != null) {
      _sleepSchedules.add(newSleepSchedule);
      MySnackBar.showSnackBarSuccess('Horario de sueño guardado correctamente');
    }

    notifyListeners();
  }
}
