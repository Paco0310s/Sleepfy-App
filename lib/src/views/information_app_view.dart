import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/controllers/content_controller.dart';
import 'package:sleepfy/models/content_item_model.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationAppView extends StatefulWidget {
  const InformationAppView({super.key});

  @override
  State<InformationAppView> createState() => _InformationAppViewState();
}

class _InformationAppViewState extends State<InformationAppView> {
  List<ContentItemModel> _cards = [];
  List<ContentItemModel> _links = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final results = await Future.wait([
      ContentController.getActiveBySection(ContentSections.insomniaCard),
      ContentController.getActiveBySection(ContentSections.insomniaLink),
    ]);
    if (!mounted) return;
    setState(() {
      _cards = results[0];
      _links = results[1];
      _isLoading = false;
    });
  }

  IconData _resolveIcon(String? iconKey) {
    switch (iconKey) {
      case 'help':
        return Icons.help_outline_rounded;
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'healing':
        return Icons.healing_rounded;
      case 'spa':
        return Icons.spa_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  Color _resolveColor(BuildContext context, String? iconKey) {
    switch (iconKey) {
      case 'warning':
        return const Color(0xFFD49E3D);
      case 'healing':
        return Constants.kSoftRose;
      case 'spa':
        return Constants.kSageGreen;
      default:
        return Constants.accent(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Conoce más sobre el insomnio'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Constants.primary(context)))
          : RefreshIndicator(
              color: Constants.kSageGreen,
              onRefresh: _loadContent,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._cards.map((card) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildInfoCard(
                            context,
                            title: card.title,
                            icon: _resolveIcon(card.iconKey),
                            iconColor: _resolveColor(context, card.iconKey),
                            content: card.body ?? card.subtitle ?? '',
                          ),
                        )),
                    if (_links.isNotEmpty) ...[
                      const Gap(10),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: MyText(
                          'Fuentes y recursos médicos recomendados',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Constants.textPrimary(context),
                        ),
                      ),
                      const Gap(10),
                      ..._links.map((link) => LinkButton(
                            title: link.title,
                            url: link.url ?? '',
                          )),
                    ],
                    const Gap(20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Constants.surface(context),
        borderRadius: BorderRadius.circular(16),
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
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const Gap(12),
              Expanded(
                child: MyText(
                  title,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Constants.textPrimary(context),
                ),
              ),
            ],
          ),
          const Gap(10),
          MyText(
            content,
            fontSize: 13.5,
            color: Constants.textSecondary(context),
            height: 1.45,
          ),
        ],
      ),
    );
  }
}

class LinkButton extends StatelessWidget {
  final String title;
  final String url;

  const LinkButton({super.key, required this.title, required this.url});

  Future<void> _launchURL() async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      MySnackBar.showSnackBarError('Enlace no disponible');
      return;
    }
    final uri = Uri.tryParse(trimmed);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      MySnackBar.showSnackBarError('No se pudo abrir el enlace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: MyButton(
        outlined: true,
        text: title,
        onPressed: _launchURL,
        child: Row(
          children: [
            Expanded(
              child: MyText(
                title,
                color: Constants.textPrimary(context),
                fontWeight: FontWeight.w500,
                fontSize: 13.5,
              ),
            ),
            const Gap(10),
            Icon(
              Icons.open_in_new_rounded,
              color: Constants.textSecondary(context),
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}
