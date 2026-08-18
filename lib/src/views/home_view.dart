import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/src/providers/test_provider.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/views/chart_view.dart';
import 'package:sleepfy/src/views/results_view.dart';
import 'package:sleepfy/src/views/settings_view.dart';
import 'package:sleepfy/src/views/test_view.dart';
import 'package:sleepfy/src/views/tools_view.dart';
import 'package:sleepfy/src/widgets/my_button.dart';
import 'package:sleepfy/src/widgets/my_card.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final TestProvider testProvider = Provider.of<TestProvider>(context);

    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    height: 256,
                    decoration: const BoxDecoration(
                      color: Constants.kBackgroundColor,
                      image: DecorationImage(
                        image: AssetImage('assets/images/icon.png'),
                        fit: BoxFit.fitHeight,
                      ),
                      // borderRadius: BorderRadius.only(
                      //   bottomLeft: Radius.circular(15),
                      //   bottomRight: Radius.circular(15),
                      // ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Builder(builder: (context) {
                    if (testProvider.isLoading) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: const Center(
                          child: CircularProgressIndicator(color: Constants.kPrimaryColor),
                        ),
                      );
                    }

                    if (testProvider.testFinished) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Color(0xFFCED4DA), width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                const MyText(
                                  'Has completado el cuestionario',
                                  color: Constants.kBackgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  textAlign: TextAlign.center,
                                ),
                                const Gap(10),
                                const MyText(
                                  'Puedes ver tu rutina personalizada',
                                  color: Constants.kBackgroundColor,
                                  fontSize: 16,
                                ),
                                const Gap(20),
                                MyButton(
                                  text: 'Ver resultados',
                                  onPressed: () {
                                    Get.to(() => const ResultsView());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Constants.kSecondaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: MyCard(
                        child: Column(
                          children: [
                            const MyText(
                              'Realiza tu cuestionario de análisis de sueño',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            const Gap(20),
                            MyButton(
                              text: 'Siguiente',
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyText('Click aquí'),
                                ],
                              ),
                              onPressed: () {
                                Get.to(() => const TestView());
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                SliverToBoxAdapter(
                  child: ChartView(),
                ),
                SliverToBoxAdapter(child: Gap(10)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: MyButton(
                      height: 80,
                      color: Constants.kBackgroundColor,
                      text: 'Adquiere tu kit aquí',
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart, color: Colors.white, size: 24),
                            const Gap(10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const MyText('¿Quieres adquirir tu kit de sueño?', fontSize: 15),
                                const MyText('Click aquí', fontSize: 10, fontWeight: FontWeight.bold),
                              ],
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
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
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: Gap(5)),
              ],
            ),
            Positioned(
              left: 10,
              top: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return Dialog(
                      //       insetPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1, right: 0),
                      //       child: const SettingsView(),
                      //     );
                      //   },
                      // );
                      Get.to(() => const SettingsView(), transition: Transition.leftToRight);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      Get.to(() => const ToolsView(), transition: Transition.rightToLeft);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialNetworkItem extends StatelessWidget {
  final String image;
  final String url;
  final String text;

  const SocialNetworkItem({super.key, required this.image, required this.url, required this.text});

  @override
  Widget build(BuildContext context) {
    return MyButton(
      color: Constants.kBackgroundColor.withValues(alpha: 0.7),
      text: text,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, width: 24),
          const Gap(10),
          MyText(text),
        ],
      ),
      onPressed: () {
        _launchURL(url);
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
