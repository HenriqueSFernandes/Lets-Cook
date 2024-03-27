import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/MainPages/HomePage.dart';
import 'package:lets_cook/MainPages/NewProductPage.dart';
import 'package:lets_cook/MainPages/ProfilePage.dart';
import 'package:lets_cook/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_cook/MainPages/LoginPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final Color aquaGreen = const Color(0xFF1B8587);
  int currentPageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff015e5c)),
      ),
      title: "Let's Cook",
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? "/sign-in" : "/home",
      routes: {
        "/sign-in": (context) {
          return const LoginPage();
        },
        "/home": (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Let's Cook"),
              elevation: 4,
            ),
            bottomNavigationBar: NavigationBar(
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home, size: 30),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: Icon(Icons.add, size: 30),
                  label: "Add",
                ),
                NavigationDestination(
                  icon: Icon(Icons.person, size: 30),
                  label: "Profile",
                ),
              ],
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              selectedIndex: currentPageIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
// Adjust duration as needed
                    curve: Curves.ease,
                  );
                });
              },
            ),
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              children: [
                HomePage(key: const PageStorageKey('HomePage')),
                const NewProductPage(key: PageStorageKey('NewProductPage')),
                const ProfilePage(key: PageStorageKey('ProfilePage')),
              ],
            ),
          );
        },
      },
    );
  }
}
