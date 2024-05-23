import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_cook/MainPages/ChatListPage.dart';
import 'package:lets_cook/MainPages/ExtraInfoPage.dart';
import 'package:lets_cook/MainPages/HomePage.dart';
import 'package:lets_cook/MainPages/LoginPage.dart';
import 'package:lets_cook/MainPages/NewProductPage.dart';
import 'package:lets_cook/MainPages/ProfilePage.dart';
import 'package:lets_cook/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.ubuntuCondensedTextTheme(),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff015e5c)),
      ),
      title: "Let's Cook",
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  _AuthGateState createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool isLoading = true;
  bool isUserValid = false;
  String initialRoute = "/sign-in";

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userData.exists) {
        isUserValid = true;
        initialRoute = "/home";
      } else {
        initialRoute = "/extra-page";
      }
    } else {
      initialRoute = "/sign-in";
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.ubuntuCondensedTextTheme(),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff015e5c)),
        ),
        title: "Let's Cook",
        initialRoute: initialRoute,
        routes: {
          "/sign-in": (context) => const LoginPage(),
          "/home": (context) => const HomeScreen(),
          "/extra-page": (context) => const ExtraInfoPage(),  // You need to create this page
        },
      );
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  void setIndex(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Image.asset(
          'lib/resources/LetsCookOfc.png',
          fit: BoxFit.cover,
          height: 80.0,
        ),
        centerTitle: true,
        elevation: 500,
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
              icon: Icon(Icons.message, size: 30), label: "Messages"),
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
              curve: Curves.ease,
            );
          });
        },
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: setIndex,
        children: [
          const HomePage(key: PageStorageKey('HomePage')),
          NewProductPage(key: const PageStorageKey('NewProductPage')),
          ChatListPage(),
          ProfilePage(
              userID: FirebaseAuth.instance.currentUser!.uid,
              key: const PageStorageKey('ProfilePage')),
        ],
      ),
    );
  }
}
