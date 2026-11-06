import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/src/providers/test_provider.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/views/ai_chat_view.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});

  String _formatDate(String? isoString) {
    if (isoString == null) return '';
    try {
      final dt = DateTime.parse(isoString);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final TestProvider testProvider = Provider.of<TestProvider>(context);
    final routine = testProvider.routine;

    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Tu Rutina de Descanso'),
        actions: [
          if (routine != null)
            IconButton(
              icon: Icon(Icons.copy_rounded, color: Constants.textPrimary(context), size: 20),
              tooltip: 'Copiar rutina',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: routine));
                MySnackBar.showSnackBarSuccess('Rutina copiada al portapapeles');
              },
            ),
          IconButton(
            icon: Icon(Icons.history_rounded, color: Constants.textPrimary(context), size: 20),
            tooltip: 'Historial de rutinas',
            onPressed: () => _showHistoryModal(context, testProvider),
          ),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: Constants.textPrimary(context), size: 20),
            tooltip: 'Sincronizar rutina',
            onPressed: () => testProvider.refreshRoutine(),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        if (testProvider.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Constants.accent(context)),
                const Gap(16),
                MyText(
                  'Cargando tu rutina...',
                  color: Constants.textSecondary(context),
                  fontSize: 14,
                ),
              ],
            ),
          );
        }

        if (routine == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bedtime_off_outlined, size: 54, color: Constants.textSecondary(context).withValues(alpha: 0.5)),
                  const Gap(16),
                  MyText(
                    'No se encontró una rutina guardada',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Constants.textPrimary(context),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(8),
                  MyText(
                    'Completa el cuestionario de análisis para generar tu primera rutina personalizada.',
                    fontSize: 13,
                    color: Constants.textSecondary(context),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Badge de IA
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Constants.surface(context),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Constants.border(context)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: Constants.accent(context), size: 17),
                    const Gap(10),
                    Expanded(
                      child: MyText(
                        'Rutina generada por Sleepfy AI basándose en tu perfil de descanso',
                        color: Constants.textPrimary(context),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),

              // Indicador de disponibilidad Offline / Sincronización
              if (testProvider.cachedRoutineDate != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            testProvider.isOffline ? Icons.cloud_off_rounded : Icons.check_circle_outline_rounded,
                            size: 14,
                            color: testProvider.isOffline ? const Color(0xFFD49E3D) : Constants.kSageGreen,
                          ),
                          const Gap(6),
                          MyText(
                            testProvider.isOffline ? 'Modo Offline (Copia Local)' : 'Disponible sin conexión',
                            fontSize: 11.5,
                            color: testProvider.isOffline ? const Color(0xFFD49E3D) : Constants.kSageGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      MyText(
                        'Actualizado: ${_formatDate(testProvider.cachedRoutineDate)}',
                        fontSize: 11,
                        color: Constants.textSecondary(context),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
              ],

              // Contenedor principal con Markdown estilizado
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Constants.surface(context),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Constants.border(context), width: 1.2),
                ),
                child: MarkdownBody(
                  data: routine,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      color: Constants.textPrimary(context),
                      fontSize: 14,
                      height: 1.55,
                    ),
                    h1: TextStyle(
                      color: Constants.textPrimary(context),
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                    h2: TextStyle(
                      color: Constants.textPrimary(context),
                      fontSize: 16.5,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                    h3: TextStyle(
                      color: Constants.textPrimary(context),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                    strong: TextStyle(
                      color: Constants.textPrimary(context),
                      fontWeight: FontWeight.bold,
                    ),
                    em: TextStyle(
                      color: Constants.textSecondary(context),
                      fontStyle: FontStyle.italic,
                    ),
                    listBullet: TextStyle(
                      color: Constants.accent(context),
                      fontSize: 14,
                    ),
                    blockquote: TextStyle(
                      color: Constants.textSecondary(context),
                      fontSize: 13.5,
                    ),
                    blockquoteDecoration: BoxDecoration(
                      color: Constants.surfaceLight(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        left: BorderSide(color: Constants.accent(context), width: 3.5),
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(14),

              // Botón para consultar a Sleepfy AI sobre la rutina
              Container(
                decoration: BoxDecoration(
                  color: Constants.surface(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Constants.border(context)),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Constants.surfaceLight(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.auto_awesome, color: Constants.accent(context), size: 20),
                  ),
                  title: MyText(
                    '¿Tienes dudas sobre tu rutina o no puedes dormir?',
                    color: Constants.textPrimary(context),
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                  subtitle: MyText(
                    'Chatea con Sleepfy AI para recibir guía personalizada al instante',
                    color: Constants.textSecondary(context),
                    fontSize: 11.5,
                  ),
                  trailing: Icon(Icons.chevron_right_rounded, color: Constants.textSecondary(context)),
                  onTap: () => Get.to(() => const AiChatView()),
                ),
              ),
              const Gap(10),

              // Botón de reevaluación
              Container(
                decoration: BoxDecoration(
                  color: Constants.surface(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Constants.border(context)),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Constants.surfaceLight(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.refresh_rounded, color: Constants.textSecondary(context), size: 20),
                  ),
                  title: MyText(
                    '¿Cambiaron tus hábitos de descanso?',
                    color: Constants.textPrimary(context),
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                  subtitle: MyText(
                    'Reevalúa tus respuestas para que la IA adapte tu rutina a tus avances',
                    color: Constants.textSecondary(context),
                    fontSize: 11.5,
                  ),
                  trailing: Icon(Icons.chevron_right_rounded, color: Constants.textSecondary(context)),
                  onTap: () => testProvider.startRetake(),
                ),
              ),
              const Gap(24),
            ],
          ),
        );
      }),
    );
  }

  void _showHistoryModal(BuildContext context, TestProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Constants.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        final history = provider.routineHistory;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Constants.border(context),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Gap(16),
                Row(
                  children: [
                    Icon(Icons.history_rounded, color: Constants.accent(context), size: 20),
                    const Gap(10),
                    MyText(
                      'Historial de Rutinas',
                      fontSize: 16.5,
                      fontWeight: FontWeight.w600,
                      color: Constants.textPrimary(context),
                    ),
                  ],
                ),
                const Gap(4),
                MyText(
                  'Consulta tus versiones anteriores de descanso generadas por la IA',
                  fontSize: 12,
                  color: Constants.textSecondary(context),
                ),
                const Gap(16),
                if (history.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: MyText(
                      'Esta es tu primera rutina. Al reevaluar tus respuestas podrás ver la evolución aquí.',
                      color: Constants.textSecondary(context),
                      fontSize: 12.5,
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: history.length,
                      separatorBuilder: (_, __) => Divider(height: 1, color: Constants.border(context)),
                      itemBuilder: (context, index) {
                        final item = history[index];
                        final isLatest = index == 0;
                        final dateStr = item.createdAt != null
                            ? '${item.createdAt!.day}/${item.createdAt!.month}/${item.createdAt!.year}'
                            : 'Versión ${history.length - index}';

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Constants.surfaceLight(context),
                            ),
                            child: Icon(
                              isLatest ? Icons.auto_awesome : Icons.check_circle_outline_rounded,
                              size: 16,
                              color: isLatest ? Constants.accent(context) : Constants.textSecondary(context),
                            ),
                          ),
                          title: Row(
                            children: [
                              MyText(
                                'Rutina del $dateStr',
                                fontWeight: isLatest ? FontWeight.w600 : FontWeight.w500,
                                fontSize: 13.5,
                                color: Constants.textPrimary(context),
                              ),
                              if (isLatest) ...[
                                const Gap(8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Constants.kSageGreen.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const MyText(
                                    'ACTUAL',
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    color: Constants.kSageGreen,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Constants.textSecondary(context)),
                          onTap: () {
                            provider.viewRoutineFromHistory(item);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
