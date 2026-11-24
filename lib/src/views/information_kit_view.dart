import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sleepfy/controllers/kit_product_controller.dart';
import 'package:sleepfy/models/kit_product_model.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/views/home_view.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class InformationKitView extends StatefulWidget {
  const InformationKitView({super.key});

  @override
  State<InformationKitView> createState() => _InformationKitViewState();
}

class _InformationKitViewState extends State<InformationKitView> {
  List<KitProductModel> _products = [];
  KitSettingsModel _settings = KitSettingsModel.defaults();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final results = await Future.wait([
      KitProductController.getActiveProducts(),
      KitProductController.getSettings(),
    ]);
    if (!mounted) return;
    setState(() {
      _products = results[0] as List<KitProductModel>;
      _settings = results[1] as KitSettingsModel;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Kit Sleepfy de Relajación'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Constants.primary(context),
                    ),
                  )
                : RefreshIndicator(
                    color: Constants.kSageGreen,
                    onRefresh: _loadProducts,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: _products[index], index: index);
                      },
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Constants.surface(context),
              border: Border(top: BorderSide(color: Constants.border(context))),
            ),
            child: SafeArea(
              child: MyButton(
                text: 'Adquirir mi Kit Sleepfy',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined, color: Constants.primaryContent(context), size: 19),
                    const Gap(8),
                    MyText(
                      'Adquirir mi Kit Sleepfy',
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                      color: Constants.primaryContent(context),
                    ),
                  ],
                ),
                onPressed: () {
                  final urlInstagram = _settings.instagramUrl.trim();
                  final phone1 = _settings.whatsapp1.trim();
                  final phone2 = _settings.whatsapp2.trim();

                  showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Constants.surface(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(color: Constants.border(context)),
                        ),
                        title: const MyTitleAppBar(title: 'Adquiere tu kit Sleepfy'),
                        content: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            if (urlInstagram.isNotEmpty)
                              SocialNetworkItem(
                                image: 'assets/images/instagram.png',
                                url: urlInstagram,
                                text: 'Instagram',
                              ),
                            if (phone1.isNotEmpty)
                              SocialNetworkItem(
                                image: 'assets/images/whatsapp.png',
                                url: 'https://wa.me/52$phone1',
                                text: 'WhatsApp 1',
                              ),
                            if (phone2.isNotEmpty)
                              SocialNetworkItem(
                                image: 'assets/images/whatsapp.png',
                                url: 'https://wa.me/52$phone2',
                                text: 'WhatsApp 2',
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final KitProductModel product;
  final int index;

  const ProductCard({super.key, required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.imageUrl;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Constants.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Constants.border(context)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _fallbackIcon(context),
                ),
              )
            : _fallbackIcon(context),
        title: Row(
          children: [
            Expanded(
              child: MyText(
                product.title,
                fontWeight: FontWeight.w600,
                fontSize: 14.5,
                color: Constants.textPrimary(context),
              ),
            ),
            if (product.stock <= 0)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: Constants.kSoftRose.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const MyText(
                  'Agotado',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Constants.kSoftRose,
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: MyText(
            product.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            fontSize: 12,
            color: Constants.textSecondary(context),
          ),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: Constants.textSecondary(context), size: 20),
        onTap: () {
          Get.to(() => ProductDetailScreen(product: product));
        },
      ),
    );
  }

  Widget _fallbackIcon(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Constants.surfaceLight(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.spa_outlined,
        color: Constants.kSageGreen,
        size: 21,
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final KitProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.imageUrl;

    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: MyTitleAppBar(title: product.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 210,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
              const Gap(16),
            ],
            Container(
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
                  MyText(
                    product.description,
                    fontSize: 14,
                    color: Constants.textPrimary(context),
                    height: 1.5,
                  ),
                  const Gap(12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: (product.stock > 0 ? Constants.kSageGreen : Constants.kSoftRose)
                          .withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: MyText(
                      product.stock > 0
                          ? 'Disponible en stock (${product.stock})'
                          : 'Temporalmente agotado',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: product.stock > 0 ? Constants.kSageGreen : Constants.kSoftRose,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),
            _buildDetailSection(
              context,
              title: 'Beneficios',
              icon: Icons.check_circle_outline_rounded,
              iconColor: Constants.kSageGreen,
              content: product.benefits,
            ),
            const Gap(12),
            _buildDetailSection(
              context,
              title: 'Modo de uso',
              icon: Icons.touch_app_outlined,
              iconColor: Constants.accent(context),
              content: product.usage,
            ),
            if (product.warning != null && product.warning!.trim().isNotEmpty) ...[
              const Gap(12),
              _buildDetailSection(
                context,
                title: 'Precauciones',
                icon: Icons.info_outline_rounded,
                iconColor: const Color(0xFFD49E3D),
                content: product.warning!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
              Icon(icon, color: iconColor, size: 18),
              const Gap(8),
              MyText(
                title,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Constants.textPrimary(context),
              ),
            ],
          ),
          const Gap(8),
          MyText(
            content,
            fontSize: 13,
            color: Constants.textSecondary(context),
            height: 1.45,
          ),
        ],
      ),
    );
  }
}
