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
      backgroundColor: Constants.kBackgroundColor,
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
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF1E1B4B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Constants.kPrimaryColor.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.bedtime_outlined, color: Constants.kSecondaryColor, size: 28),
                  Gap(14),
                  Expanded(
                    child: MyText(
                      'Monitorea a qué hora te duermes y despiertas para alimentar tus estadísticas y ajustar tus ritmos de sueño.',
                      fontSize: 13.5,
                      color: Constants.kTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(22),

            // Selector Hora Inicio
            _TimePickerCard(
              title: 'Hora de ir a la cama',
              subtitle: 'Momento en que apagas la luz para descansar',
              icon: Icons.nightlight_round,
              iconColor: Constants.kSecondaryColor,
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
                    okStyle: const TextStyle(
                      color: Constants.kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    cancelStyle: const TextStyle(
                      color: Constants.kTextSecondaryColor,
                    ),
                    okText: 'Aceptar',
                    cancelText: 'Cancelar',
                  ),
                );
              },
            ),
            const Gap(16),

            // Selector Hora Fin
            _TimePickerCard(
              title: 'Hora de despertar',
              subtitle: 'Momento en que inicia tu día',
              icon: Icons.wb_sunny_rounded,
              iconColor: const Color(0xFFF59E0B),
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
                    okStyle: const TextStyle(
                      color: Constants.kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    cancelStyle: const TextStyle(
                      color: Constants.kTextSecondaryColor,
                    ),
                    okText: 'Aceptar',
                    cancelText: 'Cancelar',
                  ),
                );
              },
            ),
            const Gap(32),

            // Botón Guardar
            MyButton(
              text: 'Guardar registro de hoy',
              child: prov.loadingSendSchedule
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save_rounded, color: Colors.white, size: 20),
                        Gap(10),
                        MyText(
                          'Guardar registro de hoy',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
          color: Constants.kSurfaceColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Constants.kBorderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    title,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Constants.kTextColor,
                  ),
                  const Gap(3),
                  MyText(
                    subtitle,
                    fontSize: 12,
                    color: Constants.kTextSecondaryColor,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Constants.kSurfaceLightColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Constants.kBorderColor),
              ),
              child: MyText(
                timeString,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Constants.kSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
