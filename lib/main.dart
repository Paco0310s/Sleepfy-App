import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sleepfy/src/providers/comments_provider.dart';
import 'package:sleepfy/src/providers/control_dreams_provider.dart';
import 'package:sleepfy/src/providers/test_provider.dart';
import 'package:sleepfy/src/providers/user_provider.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/views/home_view.dart';
import 'package:sleepfy/src/views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await UserPreferences.init();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: GetMaterialApp(
        defaultTransition: Transition.rightToLeft,
        debugShowCheckedModeBanner: false,
        title: 'Sleepfy',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primaryColor: Constants.kPrimaryColor,
          scaffoldBackgroundColor: Constants.kBackgroundColor,
          colorScheme: const ColorScheme.dark(
            primary: Constants.kPrimaryColor,
            secondary: Constants.kSecondaryColor,
            surface: Constants.kSurfaceColor,
            error: Constants.kErrorColor,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Constants.kBackgroundColor,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Constants.kTextColor),
            titleTextStyle: TextStyle(
              color: Constants.kTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          cardTheme: CardThemeData(
            color: Constants.kSurfaceColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Constants.kBorderColor, width: 1),
            ),
          ),
          dividerTheme: const DividerThemeData(
            color: Constants.kBorderColor,
            thickness: 1,
          ),
          listTileTheme: const ListTileThemeData(
            iconColor: Constants.kSecondaryColor,
            textColor: Constants.kTextColor,
          ),
        ),
        builder: (context, child) {
          return Container(
            color: Constants.kBackgroundColor,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 550),
                child: child ?? const SizedBox(),
              ),
            ),
          );
        },
        home: UserPreferences.token == null || UserPreferences.id == null ? const LoginView() : const HomeView(),
      ),
    );
  }

  List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TestProvider()),
        ChangeNotifierProvider(create: (_) => CommentsProvider()),
        ChangeNotifierProvider(create: (_) => ControlDreamsProvider()),
      ];
}
