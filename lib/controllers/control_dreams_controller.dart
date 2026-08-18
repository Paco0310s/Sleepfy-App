import 'package:sleepfy/controllers/dio_controller.dart';
import 'package:sleepfy/models/response_model.dart';
import 'package:sleepfy/models/sleep_schedule_model.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';

class ControlDreamsController {
  static Future<SleepSchedule?> sendControlDreams(Map<String, dynamic> data) async {
    final ResponseModel resp = await DioController.petition(HTTPMethods.post, 'sleep-schedules', data: data, showLoading: false);

    if (resp.status == 201) {
      return SleepSchedule.fromJson(resp.data['sleepSchedule']);
    } else {
      return null;
    }
  }

  static Future<List<SleepSchedule>> getSleepSchedules() async {
    final ResponseModel resp = await DioController.petition(HTTPMethods.get, 'sleep-schedules/last-week/${UserPreferences.id}', showLoading: false);

    if (resp.status == 200) {
      final List<SleepSchedule> sleepSchedules = [];
      for (final Map<String, dynamic> sleepSchedule in resp.data['sleepSchedules']) {
        sleepSchedules.add(SleepSchedule.fromJson(sleepSchedule));
      }
      return sleepSchedules;
    } else {
      return [];
    }
  }
}
