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
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Ciclos de Sueño'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner explicativo
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Constants.surface(context),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Constants.border(context)),
              ),
              child: Row(
                children: [
                  Icon(Icons.bedtime_outlined, color: Constants.accent(context), size: 24),
                  const Gap(14),
                  Expanded(
                    child: MyText(
                      'Monitorea a qué hora te duermes y despiertas para alimentar tus estadísticas y ajustar tus ritmos de sueño.',
                      fontSize: 13,
                      color: Constants.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(18),

            // Selector Hora Inicio
            _TimePickerCard(
              title: 'Hora de ir a la cama',
              subtitle: 'Momento en que apagas la luz para descansar',
              icon: Icons.bedtime_outlined,
              iconColor: Constants.accent(context),
              timeString: timeStart.format(context),
              onTap: () {
                Navigator.of(context).push(
                  showPicker(
                    context: context,
                    value: timeStart,
                    sunrise: const TimeOfDay(hour: 6, minute: 0),
                    sunset: const TimeOfDay(hour: 18, minute: 0),
                    duskSpanInMinutes: 120,
                    onChange: prov.onTimeStartChanged,
                    okStyle: TextStyle(
                      color: Constants.primary(context),
                      fontWeight: FontWeight.w600,
                    ),
                    cancelStyle: TextStyle(
                      color: Constants.textSecondary(context),
                    ),
                    okText: 'Aceptar',
                    cancelText: 'Cancelar',
                  ),
                );
              },
            ),
            const Gap(14),

            // Selector Hora Fin
            _TimePickerCard(
              title: 'Hora de despertar',
              subtitle: 'Momento en que inicia tu día',
              icon: Icons.wb_sunny_rounded,
              iconColor: const Color(0xFFD49E3D),
              timeString: timeEnd.format(context),
              onTap: () {
                Navigator.of(context).push(
                  showPicker(
                    context: context,
                    value: timeEnd,
                    sunrise: const TimeOfDay(hour: 6, minute: 0),
                    sunset: const TimeOfDay(hour: 18, minute: 0),
                    duskSpanInMinutes: 120,
                    onChange: prov.onTimeEndChanged,
                    okStyle: TextStyle(
                      color: Constants.primary(context),
                      fontWeight: FontWeight.w600,
                    ),
                    cancelStyle: TextStyle(
                      color: Constants.textSecondary(context),
                    ),
                    okText: 'Aceptar',
                    cancelText: 'Cancelar',
                  ),
                );
              },
            ),
            const Gap(28),

            // Botón Guardar
            MyButton(
              text: 'Guardar registro de hoy',
              child: prov.loadingSendSchedule
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(Constants.primaryContent(context)),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save_rounded, color: Constants.primaryContent(context), size: 19),
                        const Gap(8),
                        MyText(
                          'Guardar registro de hoy',
                          color: Constants.primaryContent(context),
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                        ),
                      ],
                    ),
              onPressed: () {
                prov.saveData();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TimePickerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String timeString;
  final VoidCallback onTap;

  const _TimePickerCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.timeString,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Constants.surface(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Constants.border(context)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    title,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Constants.textPrimary(context),
                  ),
                  const Gap(2),
                  MyText(
                    subtitle,
                    fontSize: 12,
                    color: Constants.textSecondary(context),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Constants.surfaceLight(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Constants.border(context)),
              ),
              child: MyText(
                timeString,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Constants.textPrimary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
