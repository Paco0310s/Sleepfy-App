import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/src/providers/test_provider.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final TestProvider testProvider = Provider.of<TestProvider>(context);
    final routine = testProvider.routine;

    return Scaffold(
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Resultados'),
      ),
      body: Builder(builder: (context) {
        if (testProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Constants.kPrimaryColor),
          );
        }

        if (routine == null) {
          return const Center(
            child: Text('No se ha cargado la rutina, reinicie la aplicación'),
          );
        }

        return Card(
          margin: const EdgeInsets.all(10),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFFCED4DA), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Markdown(
              data: routine,
            ),
          ),
        );
      }),
    );
  }
}
