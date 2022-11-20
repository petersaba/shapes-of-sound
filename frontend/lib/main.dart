import 'package:flutter/material.dart';
import 'package:frontend/providers/login_info.dart';
import 'package:frontend/providers/selected_page.dart';
import 'package:frontend/providers/signup_info.dart';
import 'package:frontend/providers/user_info.dart';
import 'package:frontend/screens/signup.dart';
import 'package:frontend/widgets/app_bars.dart';
import 'package:provider/provider.dart';
import 'utilities.dart';
import 'package:frontend/widgets/translate.dart';
import 'widgets/edit_profile.dart';
import 'screens/login.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => SelectedPage()),
      ChangeNotifierProvider(create: (context) => UserInfo()),
      ChangeNotifierProvider(create: (context) => LoginInfo()),
      ChangeNotifierProvider(create: (context) => SignUpInfo()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shapes Of Sound',
      theme: ThemeData(
        primarySwatch: buildMaterialColor(const Color(0xFF355085)),
      ),

      initialRoute: '/login',
      routes: {
        '/login':(context) => const LoginPage(),
        '/signup':(context) => const SignUpPage(),
        '/home': (context) => const MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    int selectedPage = context.watch<SelectedPage>().selectedPage;
    if (selectedPage == 0) {
      return const Scaffold(
        appBar: CustomAppBar(),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: HomepageMainSection());
    }
    return const Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: EditProfile());
}
}
