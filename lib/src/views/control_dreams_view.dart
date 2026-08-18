import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/src/providers/control_dreams_provider.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class ControlDreamsView extends StatelessWidget {
  const ControlDreamsView({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ControlDreamsProvider>(context);
    final Time timeStart = prov.timeStart;
    final Time timeEnd = prov.timeEnd;

    return Scaffold(
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Control de ciclos del sueño'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                'Controla tus ciclos de sueño y mejora tu calidad de descanso monitoreando tus patrones de sueño. '
                'Lleva un registro semanal de a qué hora te acuestas y te levantas, ayudando así a identificar patrones. ',
                textAlign: TextAlign.justify,
                fontSize: 15,
              ),
              Gap(20),
              Row(
                children: [
                  MyText(
                    '◆	Hora de inicio del sueño: ',
                    textAlign: TextAlign.justify,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        showPicker(
                          context: context,
                          value: timeStart,
                          sunrise: TimeOfDay(hour: 6, minute: 0), // optional
                          sunset: TimeOfDay(hour: 18, minute: 0), // optional
                          duskSpanInMinutes: 120, // optional
                          onChange: prov.onTimeStartChanged,
                          okStyle: TextStyle(
                            color: Constants.kPrimaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          cancelStyle: TextStyle(
                            color: Constants.kPrimaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          okText: 'Aceptar',
                          cancelText: 'Cancelar',
                        ),
                      );
                    },
                    child: Text(
                      timeStart.format(context),
                      style: TextStyle(
                        color: Constants.kPrimaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  MyText(
                    '◆	Hora de fin del sueño: ',
                    textAlign: TextAlign.justify,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        showPicker(
                          context: context,
                          value: timeEnd,
                          sunrise: TimeOfDay(hour: 6, minute: 0), // optional
                          sunset: TimeOfDay(hour: 18, minute: 0), // optional
                          duskSpanInMinutes: 120, // optional
                          onChange: prov.onTimeEndChanged,
                          okStyle: TextStyle(
                            color: Constants.kPrimaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          cancelStyle: TextStyle(
                            color: Constants.kPrimaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          okText: 'Aceptar',
                          cancelText: 'Cancelar',
                        ),
                      );
                    },
                    child: Text(
                      timeEnd.format(context),
                      style: TextStyle(
                        color: Constants.kPrimaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(20),
              MyButton(
                text: 'Guardar',
                onPressed: () {
                  prov.saveData();
                },
                child: prov.loadingSendSchedule
                    ? Padding(
                        padding: const EdgeInsets.all(5),
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
