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
      backgroundColor: Constants.kBackgroundColor,
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
            decoration: const BoxDecoration(
              color: Constants.kSurfaceColor,
              border: Border(top: BorderSide(color: Constants.kBorderColor)),
            ),
            child: SafeArea(
              child: MyButton(
                color: Constants.kSecondaryColor,
                text: 'Adquirir mi Kit Sleepfy',
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined, color: Constants.kBackgroundColor, size: 20),
                    Gap(8),
                    MyText(
                      'Adquirir mi Kit Sleepfy',
                      fontWeight: FontWeight.bold,
                      color: Constants.kBackgroundColor,
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
                        backgroundColor: Constants.kSurfaceColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Constants.kBorderColor),
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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Constants.kSurfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Constants.kBorderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Constants.kSecondaryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.spa_outlined,
            color: Constants.kSecondaryColor,
            size: 22,
          ),
        ),
        title: MyText(
          product["title"]!,
          fontWeight: FontWeight.bold,
          fontSize: 15.5,
          color: Constants.kTextColor,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: MyText(
            product["description"]!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            fontSize: 12.5,
            color: Constants.kTextSecondaryColor,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Constants.kSecondaryColor),
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
      backgroundColor: Constants.kBackgroundColor,
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
                color: Constants.kSurfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Constants.kBorderColor),
              ),
              child: MyText(
                product["description"]!,
                fontSize: 15,
                color: Constants.kTextColor,
              ),
            ),
            const Gap(18),
            _buildDetailSection(
              title: 'Beneficios',
              icon: Icons.check_circle_outline_rounded,
              iconColor: Constants.kMintColor,
              content: product["benefits"]!,
            ),
            const Gap(14),
            _buildDetailSection(
              title: 'Modo de Uso',
              icon: Icons.lightbulb_outline_rounded,
              iconColor: Constants.kSecondaryColor,
              content: product["usage"]!,
            ),
            const Gap(14),
            _buildDetailSection(
              title: 'Advertencias',
              icon: Icons.warning_amber_rounded,
              iconColor: const Color(0xFFF59E0B),
              content: product["warning"]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Constants.kSurfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Constants.kBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const Gap(10),
              MyText(
                title,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: iconColor,
              ),
            ],
          ),
          const Gap(10),
          MyText(
            content,
            fontSize: 14,
            color: Constants.kTextColor,
          ),
        ],
      ),
    );
  }
}
