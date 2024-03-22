import 'package:flutter/material.dart';
import 'package:lets_cook/MainPages/HomePage.dart';
import 'package:lets_cook/MainPages/NewProductPage.dart';
import 'package:lets_cook/MainPages/ProfilePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      title: "Let's Cook",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Let's Cook"),
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
          children: const [
            HomePage(key: PageStorageKey('HomePage')),
            NewProductPage(key: PageStorageKey('NewProductPage')),
            ProfilePage(key: PageStorageKey('ProfilePage')),
          ],
        ),
      ),
    );
  }
}
