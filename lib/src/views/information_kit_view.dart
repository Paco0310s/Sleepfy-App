import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/views/home_view.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class InformationKitView extends StatelessWidget {
  InformationKitView({super.key});

  final List<Map<String, String>> products = [
    {
      "title": "Spray de Magnesio",
      "description":
          "El Spray de Magnesio a base de Cloruro de Magnesio está enfocado a quienes buscan una alternativa natural para relajar músculos y calmar el sistema nervioso.",
      "benefits": "◆ Ayuda a relajar los músculos, alivia la tensión acumulada y reduce el estrés nocturno.",
      "usage": "Aplicar 3-5 atomizaciones en la planta de los pies o cuello antes de dormir.",
      "warning": "Solo para uso externo. Evitar contacto con ojos y heridas abiertas.",
    },
    {
      "title": "Vela Aromática",
      "description": "Combina aceites esenciales de lavanda y notas frescas de bosque, perfecta para acompañar la desconexión nocturna.",
      "benefits": "◆ Lavanda: Relaja y reduce el estrés.\n◆ Bosque: Calma la mente y promueve un sueño profundo.",
      "usage": "Enciende la vela 30 minutos antes de acostarte. Asegúrate de apagarla antes de dormir.",
      "warning": "Nunca dejes una vela encendida sin supervisión.",
    },
    {
      "title": "Tés Anti Insomnio",
      "description": "Infusiones naturales seleccionadas para apaciguar el sistema digestivo y nervioso.",
      "benefits": "◆ Té de Manzanilla: Sedante natural y antiinflamatorio.\n◆ Té de 7 Azahares: Reduce la ansiedad y propicia el sueño profundo.",
      "usage": "Tomar una taza tibia 30-45 minutos antes de dormir.",
      "warning": "Consérvese en un lugar fresco y seco.",
    },
    {
      "title": "Bálsamo Relajante",
      "description": "Bálsamo botánico formulado para liberar tensión mediante aromaterapia y digitopuntura suave.",
      "benefits": "◆ Lavanda y Manzanilla: Inducen tranquilidad.\n◆ Vitamina E y Cera de Abeja: Nutren la piel.",
      "usage": "Aplica suavemente en sienes, detrás de las orejas y en las muñecas antes de acostarte.",
      "warning": "Uso tópico únicamente. Evitar el contacto con los ojos.",
    },
    {
      "title": "Aromatizante de Espacios",
      "description": "Bruma ambiental con aceites esenciales de lavanda, manzanilla, violeta y mandarina.",
      "benefits": "◆ Transforma tu habitación en un santuario oscuro, fresco y aromatizado para el descanso.",
      "usage": "Rocía 2-4 veces en la almohada y en el ambiente unos minutos antes de dormir.",
      "warning": "Mantener fuera del alcance de los niños.",
    },
  ];

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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: products[index], index: index);
              },
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
                  const urlInstagram = 'https://www.instagram.com/_sleepfy/';
                  const String phone1 = '3921694141';
                  const String phone2 = '3921219786';

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
                        content: const Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            SocialNetworkItem(
                              image: 'assets/images/instagram.png',
                              url: urlInstagram,
                              text: 'Instagram',
                            ),
                            SocialNetworkItem(
                              image: 'assets/images/whatsapp.png',
                              url: 'https://wa.me/52$phone1',
                              text: 'WhatsApp 1',
                            ),
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
  final Map<String, String> product;
  final int index;

  const ProductCard({super.key, required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Constants.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Constants.border(context)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Constants.surfaceLight(context),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.spa_outlined,
            color: Constants.kSageGreen,
            size: 21,
          ),
        ),
        title: MyText(
          product["title"]!,
          fontWeight: FontWeight.w600,
          fontSize: 14.5,
          color: Constants.textPrimary(context),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: MyText(
            product["description"]!,
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
}

class ProductDetailScreen extends StatelessWidget {
  final Map<String, String> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: MyTitleAppBar(title: product["title"]!),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Constants.surface(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Constants.border(context)),
              ),
              child: MyText(
                product["description"]!,
                fontSize: 14,
                color: Constants.textPrimary(context),
                height: 1.5,
              ),
            ),
            const Gap(16),
            _buildDetailSection(
              context,
              title: 'Beneficios',
              icon: Icons.check_circle_outline_rounded,
              iconColor: Constants.kSageGreen,
              content: product["benefits"]!,
            ),
            const Gap(12),
            _buildDetailSection(
              context,
              title: 'Modo de uso',
              icon: Icons.touch_app_outlined,
              iconColor: Constants.accent(context),
              content: product["usage"]!,
            ),
            const Gap(12),
            _buildDetailSection(
              context,
              title: 'Precauciones',
              icon: Icons.info_outline_rounded,
              iconColor: const Color(0xFFD49E3D),
              content: product["warning"]!,
            ),
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
