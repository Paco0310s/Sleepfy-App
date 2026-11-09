import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Acerca de Sleepfy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: <Widget>[
            // Logo
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Constants.surface(context),
                border: Border.all(color: Constants.border(context), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/icon.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Gap(14),
            MyText(
              'Sleepfy',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Constants.textPrimary(context),
            ),
            const Gap(4),
            MyText(
              'Versión ${Constants.appVersion}',
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Constants.textSecondary(context),
            ),
            const Gap(22),

            // Tarjeta de Historia y Propósito
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Constants.surface(context),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Constants.border(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Constants.kSageGreen.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Constants.kSageGreen,
                          size: 18,
                        ),
                      ),
                      const Gap(10),
                      MyText(
                        'Historia del proyecto',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Constants.textPrimary(context),
                      ),
                    ],
                  ),
                  const Gap(14),
                  MyText(
                    'Esta aplicación nació originalmente con mucho cariño para mi sobrino Carlos Ramírez Sotelo, comenzando como un prototipo para un proyecto escolar.\n\nHoy ha evolucionado para convertirse en una herramienta pensada para que toda la gente pueda mejorar su descanso, recuperar sus noches de paz y transformar su bienestar integral.',
                    fontSize: 13.5,
                    color: Constants.textPrimary(context),
                    height: 1.55,
                  ),
                  const Gap(16),
                  Divider(color: Constants.border(context), height: 1),
                  const Gap(14),
                  Row(
                    children: [
                      Icon(
                        Icons.code_rounded,
                        size: 17,
                        color: Constants.textSecondary(context),
                      ),
                      const Gap(8),
                      Expanded(
                        child: MyText(
                          'Desarrollado con dedicación por Francisco Sotelo.',
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Constants.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(18),

            // Tarjeta: Ve mis demás proyectos
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Constants.surface(context),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Constants.border(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Constants.accent(context).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.explore_rounded,
                          color: Constants.accent(context),
                          size: 18,
                        ),
                      ),
                      const Gap(10),
                      MyText(
                        'Ve mis demás proyectos',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Constants.textPrimary(context),
                      ),
                    ],
                  ),
                  const Gap(10),
                  MyText(
                    'Conoce más de mis desarrollos, proyectos de software y aplicaciones en mi página personal:',
                    fontSize: 13,
                    color: Constants.textSecondary(context),
                    height: 1.45,
                  ),
                  const Gap(14),
                  Material(
                    color: Constants.surfaceLight(context),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _launchWeb('https://pacosotelo.com'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Constants.border(context)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.language_rounded,
                              color: Constants.primary(context),
                              size: 20,
                            ),
                            const Gap(10),
                            Expanded(
                              child: MyText(
                                'pacosotelo.com',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: Constants.textPrimary(context),
                              ),
                            ),
                            Icon(
                              Icons.open_in_new_rounded,
                              size: 18,
                              color: Constants.textSecondary(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(18),

            // Tarjeta: Donar un café / Apoyo al proyecto
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Constants.surface(context),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Constants.border(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Constants.kSoftAmber.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.coffee_rounded,
                          color: Constants.kSoftAmber,
                          size: 18,
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: MyText(
                          'Invítale un café al desarrollador',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Constants.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  MyText(
                    'Si te gustó la app y quieres invitarme un café por el desarrollo y mantenimiento... ¡al cabo yo sí duermo! 😄☕',
                    fontSize: 13,
                    color: Constants.textSecondary(context),
                    height: 1.45,
                  ),
                  const Gap(14),
                  Material(
                    color: Constants.surfaceLight(context),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _launchWeb('https://pacosotelo.com/#donaciones'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Constants.border(context)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.local_cafe_rounded,
                              color: Constants.kSoftAmber,
                              size: 19,
                            ),
                            const Gap(10),
                            MyText(
                              'Invitar un café',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: Constants.textPrimary(context),
                            ),
                            const Gap(8),
                            Icon(
                              Icons.open_in_new_rounded,
                              size: 17,
                              color: Constants.textSecondary(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),

            // Pie de página
            Center(
              child: MyText(
                '© Francisco Sotelo 2026',
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Constants.textSecondary(context),
              ),
            ),
            const Gap(28),
          ],
        ),
      ),
    );
  }

  static Future<void> _launchWeb(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      MySnackBar.showSnackBarError('No se pudo abrir el enlace');
    }
  }
}
