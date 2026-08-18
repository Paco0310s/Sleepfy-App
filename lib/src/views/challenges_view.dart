import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:sleepfy/src/widgets/widgets.dart';

class ChallengesView extends StatelessWidget {
  ChallengesView({super.key});

  final List<Map<String, String>> challenges = [
    {
      "title": "Sin Pantallas Antes de Dormir",
      "goal": "Evitar el uso de dispositivos electrónicos 1 hora antes de dormir.",
      "solution": "Reemplaza el tiempo de pantalla por actividades relajantes como leer un libro, escribir en un diario o practicar meditación.",
    },
    {
      "title": "Hora Fija para Dormir",
      "goal": "Ir a la cama a la misma hora todos los días durante una semana.",
      "solution":
          "Programa un recordatorio 30 minutos antes y comienza tu rutina de sueño, como aplicar el bálsamo relajante o la vela aromática del kit Sleepfy.",
    },
    {
      "title": "Diario de Sueño",
      "goal": "Llevar un diario de sueño durante 7 días.",
      "solution": "Cada mañana, escribe cómo fue tu sueño y cómo te sientes al despertar.",
    },
    {
      "title": "Ambiente de Sueño Ideal",
      "goal": "Mantener el dormitorio oscuro, fresco y sin ruido durante 5 noches.",
      "solution": "Usa cortinas oscuras, un ventilador o regulador de temperatura y sonidos relajantes para enmascarar el ruido.",
    },
    {
      "title": "Desconexión Digital",
      "goal": "Apagar el teléfono o ponerlo en modo avión antes de dormir durante 5 noches.",
      "solution": "Configura un horario de 'No molestar' y guárdalo fuera de tu alcance en la noche.",
    },
    {
      "title": "Respiración para Dormir",
      "goal": "Practicar ejercicios de respiración profunda antes de dormir durante 5 noches.",
      "solution": "Utiliza ejercicios de respiración como el '4-7-8' (inhalar por 4 segundos, sostener por 7, y exhalar por 8).",
    },
    {
      "title": "Sin Cafeína Después del Mediodía",
      "goal": "No consumir cafeína después de las 12 pm durante una semana.",
      "solution": "Cambia tu café de la tarde por una infusión sin cafeína o agua.",
    },
    {
      "title": "Sábado de Sueño Completo",
      "goal": "Dedicarse una noche del fin de semana para dormir sin interrupciones ni alarmas.",
      "solution": "Establece una rutina de autocuidado antes de dormir, incluyendo el uso de tu kit Sleepfy.",
    },
    {
      "title": "Relajación Activa",
      "goal": "Hacer una actividad relajante antes de dormir durante 7 días.",
      "solution": "Cada noche, dedica de 5 a 10 minutos a una actividad tranquila antes de acostarte.",
    },
    {
      "title": "Día sin Estrés",
      "goal": "Tomar al menos 10 minutos para relajarte durante el día, reduciendo el estrés acumulado.",
      "solution": "Programa un descanso durante el día para meditar, dar una caminata o usar una técnica de relajación rápida.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Desafíos de Sueño'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: MyText(
                  'Al completar estos desafíos de sueño, podrás disfrutar de un sueño más reparador, '
                  'menos estrés, mejor estado de ánimo, mayor energía y concentración, además de hábitos '
                  'más saludables y un sistema inmunológico fortalecido. Estos beneficios promueven un '
                  'bienestar integral y un estilo de vida equilibrado.',
                  textAlign: TextAlign.justify,
                  fontSize: 15,
                ),
              ),
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: const Text(
                'Desafíos por cumplir',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212529),
                ),
              ),
            ),
            const Gap(5),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0xFFCED4DA), width: 1),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenges[index]["title"]!,
                          style: const TextStyle(
                            color: Constants.kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const Gap(15),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Objetivo: ",
                                style: TextStyle(
                                  color: Constants.kBackgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text: challenges[index]["goal"],
                                style: const TextStyle(color: Constants.kBackgroundColor, fontSize: 16),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const Gap(5),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Cómo lograrlo: ",
                                style: TextStyle(color: Constants.kBackgroundColor, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              TextSpan(
                                text: challenges[index]["solution"],
                                style: const TextStyle(color: Constants.kBackgroundColor, fontSize: 16),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}
