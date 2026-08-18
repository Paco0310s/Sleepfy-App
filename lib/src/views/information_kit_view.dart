import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepfy/src/views/home_view.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class InformationKitView extends StatelessWidget {
  InformationKitView({super.key});

  final List<Map<String, String>> products = [
    {
      "title": "Spray de Magnesio",
      "description":
          "El Spray de Magnesio a base de Cloruro de Magnesio está enfocado a quienes buscan una alternativa natural para relajarse antes de dormir.",
      "benefits": "◆ Ayuda a relajar los músculos, alivia la tensión acumulada y reduce el estrés.",
      "usage": "Aplicar 3-5 sprays en la planta de los pies antes de dormir.",
      "warning": "Solo para uso externo. Evitar contacto con ojos y heridas abiertas.",
    },
    {
      "title": "Vela Aromática",
      "description": "Esta vela aromática combina aceites esenciales de lavanda y notas frescas de bosque, perfecta para la rutina nocturna.",
      "benefits": "◆ Lavanda: Relaja y reduce el estrés.\n◆ Bosque: Calma la mente y promueve un sueño profundo.",
      "usage": "Enciende la vela 30 minutos antes de acostarte. Asegúrate de apagarla antes de dormir.",
      "warning": "Nunca dejes una vela encendida sin supervisión.",
    },
    {
      "title": "Tés Anti Insomnio",
      "description": "Los Tés anti insomnio ayudan a calmar el sistema nervioso y digestivo, reduciendo el estrés y la ansiedad.",
      "benefits": "◆ Té de Manzanilla: Sedante y antiinflamatorio.\n◆ Té de 7 Azahares: Reduce ansiedad y mejora la calidad del sueño.",
      "usage": "Tomar una taza de té 30-45 minutos antes de dormir.",
      "warning": "Consérvese en un lugar fresco y seco.",
    },
    {
      "title": "Bálsamo Relajante",
      "description": "Este bálsamo se enfoca en el alivio de tensión y estrés mediante la estimulación de puntos de presión.",
      "benefits": "◆ Lavanda y Manzanilla: Relaja y mejora el descanso.\n◆ Vitamina E y Cera de Abeja: Nutren y protegen la piel.",
      "usage": "Aplicar en sienes, detrás de las orejas y muñecas. Usar antes de dormir.",
      "warning": "Uso tópico únicamente. Evitar el contacto con los ojos.",
    },
    {
      "title": "Aromatizante de Espacios",
      "description": "Aromatizante de espacios con aceites esenciales de lavanda, manzanilla, violeta y mandarina, ideal para crear un ambiente relajante.",
      "benefits": "◆ Lavanda: Reduce el estrés.\n◆ Manzanilla: Calma el nerviosismo.",
      "usage": "Rocía 2-4 veces en el ambiente antes de dormir.",
      "warning": "Mantener fuera del alcance de los niños.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyTitleAppBar(title: 'Kit de Relajación'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 90,
            child: ListView.builder(
              padding: EdgeInsets.all(15),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              },
            ),
          ),
          Flexible(
            flex: 10,
            child: InkWell(
              onTap: () {
                const urlInstagram = 'https://www.instagram.com/_sleepfy/';
                const String phone1 = '3921694141';
                const String phone2 = '3921219786';

                showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: MyTitleAppBar(title: 'Adquiere tu kit aquí'),
                        content: Wrap(
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
                    });
              },
              child: Container(
                color: Color(0xFF198754),
                child: Center(
                  child: Text(
                    'Adquiere tu Kit de Relajación',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
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

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Color(0xFFCED4DA), width: 1),
      ),
      child: ListTile(
        title: Text(
          product["title"]!,
          style: TextStyle(
            color: Color(0xFF212529),
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(Icons.arrow_forward, color: Color(0xFF198754)),
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
      appBar: AppBar(
        title: MyTitleAppBar(title: product["title"]!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product["description"]!,
              style: TextStyle(color: Color(0xFF6C757D), fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Beneficios:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF212529)),
            ),
            SizedBox(height: 5),
            Text(
              product["benefits"]!,
              style: TextStyle(color: Color(0xFF6C757D)),
            ),
            SizedBox(height: 20),
            Text(
              'Modo de Uso:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF212529)),
            ),
            SizedBox(height: 5),
            Text(
              product["usage"]!,
              style: TextStyle(color: Color(0xFF6C757D)),
            ),
            SizedBox(height: 20),
            Text(
              'Advertencias:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF212529)),
            ),
            SizedBox(height: 5),
            Text(
              product["warning"]!,
              style: TextStyle(color: Color(0xFF6C757D)),
            ),
          ],
        ),
      ),
    );
  }
}
