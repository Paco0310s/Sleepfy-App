import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/controllers/content_controller.dart';
import 'package:sleepfy/models/content_item_model.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class PodcastsView extends StatefulWidget {
  const PodcastsView({super.key});

  @override
  State<PodcastsView> createState() => _PodcastsViewState();
}

class _PodcastsViewState extends State<PodcastsView> {
  List<ContentItemModel> _podcastList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final list = await ContentController.getActiveBySection(ContentSections.podcast);
    if (!mounted) return;
    setState(() {
      _podcastList = list;
      _isLoading = false;
    });
  }

  void _launchURL(String? url) async {
    final trimmed = url?.trim() ?? '';
    if (trimmed.isEmpty) {
      MySnackBar.showSnackBarError('Enlace no disponible');
      return;
    }
    final Uri? uri = Uri.tryParse(trimmed);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      MySnackBar.showSnackBarError('No se pudo abrir el enlace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Podcasts de Relajación'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Constants.primary(context)))
          : RefreshIndicator(
              color: Constants.kSageGreen,
              onRefresh: _loadContent,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                children: [
                  // Banner
                  Container(
                    padding: const EdgeInsets.all(18),
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
                            Icon(Icons.mic_none_rounded, color: Constants.accent(context), size: 22),
                            const Gap(10),
                            MyText(
                              'Narrativa y Calma Auditiva',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Constants.textPrimary(context),
                            ),
                          ],
                        ),
                        const Gap(8),
                        MyText(
                          'Escuchar voces suaves y narraciones tranquilizadoras ayuda al cerebro a detener el monólogo interno de preocupaciones y facilitar la somnolencia natural.',
                          fontSize: 13,
                          color: Constants.textSecondary(context),
                          height: 1.45,
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),

                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: MyText(
                      'Podcasts seleccionados',
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      color: Constants.textPrimary(context),
                    ),
                  ),
                  const Gap(12),

                  ..._podcastList.map((item) {
                    final imageUrl = item.resolvedImageUrl;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Constants.surface(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Constants.border(context)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        onTap: () => _launchURL(item.url),
                        leading: imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  imageUrl,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _podcastIconBox(context),
                                ),
                              )
                            : _podcastIconBox(context),
                        title: MyText(
                          item.title,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Constants.textPrimary(context),
                        ),
                        subtitle: (item.subtitle ?? '').isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: MyText(
                                  item.subtitle!,
                                  fontSize: 12.5,
                                  color: Constants.textSecondary(context),
                                ),
                              )
                            : null,
                        trailing: Icon(
                          Icons.open_in_new_rounded,
                          color: Constants.textSecondary(context),
                          size: 18,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }

  Widget _podcastIconBox(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Constants.surfaceLight(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.headphones_rounded,
        color: Constants.kSageGreen,
        size: 22,
      ),
    );
  }
}
