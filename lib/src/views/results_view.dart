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
      backgroundColor: Constants.kBackgroundColor,
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Tu Rutina de Descanso'),
        actions: [
          if (routine != null)
            IconButton(
              icon: const Icon(Icons.copy_rounded, color: Constants.kSecondaryColor),
              tooltip: 'Copiar rutina',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: routine));
                MySnackBar.showSnackBarSuccess('Rutina copiada al portapapeles');
              },
            ),
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Constants.kSecondaryColor),
            tooltip: 'Historial de rutinas',
            onPressed: () => _showHistoryModal(context, testProvider),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Constants.kSecondaryColor),
            tooltip: 'Sincronizar rutina',
            onPressed: () => testProvider.refreshRoutine(),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        if (testProvider.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Constants.kPrimaryColor),
                Gap(16),
                MyText(
                  'Cargando tu rutina...',
                  color: Constants.kTextSecondaryColor,
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
                  Icon(Icons.bedtime_off_outlined, size: 60, color: Constants.kTextSecondaryColor.withValues(alpha: 0.5)),
                  const Gap(16),
                  const MyText(
                    'No se encontró una rutina guardada',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Constants.kTextColor,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(8),
                  const MyText(
                    'Completa el cuestionario de análisis para generar tu primera rutina personalizada.',
                    fontSize: 13,
                    color: Constants.kTextSecondaryColor,
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
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Constants.kPrimaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Constants.kPrimaryColor.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: Constants.kSecondaryColor, size: 18),
                    Gap(8),
                    Expanded(
                      child: MyText(
                        'Generada por Sleepfy AI basándose en tu cuestionario',
                        color: Constants.kSecondaryColor,
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
                            testProvider.isOffline ? Icons.cloud_off_rounded : Icons.offline_pin_rounded,
                            size: 15,
                            color: testProvider.isOffline ? Constants.kWarningColor : Constants.kSuccessColor,
                          ),
                          const Gap(6),
                          MyText(
                            testProvider.isOffline ? 'Modo Offline (Copia Local)' : 'Disponible sin conexión',
                            fontSize: 11.5,
                            color: testProvider.isOffline ? Constants.kWarningColor : Constants.kSuccessColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      MyText(
                        'Actualizado: ${_formatDate(testProvider.cachedRoutineDate)}',
                        fontSize: 11,
                        color: Constants.kTextSecondaryColor,
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
                  color: Constants.kSurfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Constants.kBorderColor, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: MarkdownBody(
                  data: routine,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(
                      color: Constants.kTextColor,
                      fontSize: 14.5,
                      height: 1.55,
                    ),
                    h1: const TextStyle(
                      color: Constants.kSecondaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                    h2: const TextStyle(
                      color: Constants.kSecondaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                    h3: const TextStyle(
                      color: Constants.kTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                    strong: const TextStyle(
                      color: Constants.kTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                    em: const TextStyle(
                      color: Constants.kTextSecondaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                    listBullet: const TextStyle(
                      color: Constants.kSecondaryColor,
                      fontSize: 14,
                    ),
                    blockquote: const TextStyle(
                      color: Constants.kTextSecondaryColor,
                      fontSize: 14,
                    ),
                    blockquoteDecoration: BoxDecoration(
                      color: Constants.kSurfaceLightColor,
                      borderRadius: BorderRadius.circular(8),
                      border: const Border(
                        left: BorderSide(color: Constants.kSecondaryColor, width: 4),
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(16),

              // Botón para consultar a Sleepfy AI sobre la rutina
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Constants.kPrimaryColor.withValues(alpha: 0.6)),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E1B4B), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.auto_awesome, color: Constants.kSecondaryColor, size: 26),
                  title: const MyText(
                    '¿Tienes dudas sobre tu rutina o no puedes dormir?',
                    color: Constants.kTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  subtitle: const MyText(
                    'Chatea en vivo con Sleepfy AI para recibir guía personalizada ahora mismo',
                    color: Constants.kTextSecondaryColor,
                    fontSize: 12,
                  ),
                  trailing: const Icon(Icons.chat_bubble_outline_rounded, color: Constants.kSecondaryColor, size: 18),
                  onTap: () => Get.to(() => const AiChatView()),
                ),
              ),
              const Gap(12),

              // Botón de reevaluación
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Constants.kSecondaryColor.withValues(alpha: 0.5)),
                  color: Constants.kSecondaryColor.withValues(alpha: 0.08),
                ),
                child: ListTile(
                  leading: const Icon(Icons.edit_note_rounded, color: Constants.kSecondaryColor, size: 28),
                  title: const MyText(
                    '¿Cambiaron tus hábitos de descanso?',
                    color: Constants.kTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  subtitle: const MyText(
                    'Reevalúa tus respuestas para que la IA adapte tu rutina a tus avances',
                    color: Constants.kTextSecondaryColor,
                    fontSize: 12,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Constants.kSecondaryColor, size: 16),
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
      backgroundColor: Constants.kSurfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Constants.kBorderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Gap(16),
                const Row(
                  children: [
                    Icon(Icons.history_rounded, color: Constants.kSecondaryColor, size: 22),
                    Gap(10),
                    MyText(
                      'Historial de Rutinas y Avances',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Constants.kTextColor,
                    ),
                  ],
                ),
                const Gap(6),
                const MyText(
                  'Consulta tus versiones anteriores de descanso generadas por la IA',
                  fontSize: 12.5,
                  color: Constants.kTextSecondaryColor,
                ),
                const Gap(16),
                if (history.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: const MyText(
                      'Esta es tu primera rutina. Al reevaluar tus respuestas podrás ver la evolución aquí.',
                      color: Constants.kTextSecondaryColor,
                      fontSize: 13,
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: history.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = history[index];
                        final isLatest = index == 0;
                        final dateStr = item.createdAt != null
                            ? '${item.createdAt!.day}/${item.createdAt!.month}/${item.createdAt!.year}'
                            : 'Versión ${history.length - index}';

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (isLatest ? Constants.kPrimaryColor : Constants.kSurfaceLightColor).withValues(alpha: 0.2),
                            ),
                            child: Icon(
                              isLatest ? Icons.auto_awesome : Icons.check_circle_outline_rounded,
                              size: 18,
                              color: isLatest ? Constants.kSecondaryColor : Constants.kTextSecondaryColor,
                            ),
                          ),
                          title: Row(
                            children: [
                              MyText(
                                'Rutina del $dateStr',
                                fontWeight: isLatest ? FontWeight.bold : FontWeight.w500,
                                fontSize: 14,
                                color: Constants.kTextColor,
                              ),
                              if (isLatest) ...[
                                const Gap(8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Constants.kMintColor.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const MyText(
                                    'ACTUAL',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Constants.kMintColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Constants.kTextSecondaryColor),
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
