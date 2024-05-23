import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_cook/MainPages/ChatListPage.dart';
import 'package:lets_cook/MainPages/HomePage.dart';
import 'package:lets_cook/MainPages/LoginPage.dart';
import 'package:lets_cook/MainPages/NewProductPage.dart';
import 'package:lets_cook/MainPages/ProfilePage.dart';
import 'package:lets_cook/firebase_options.dart';
import 'package:lets_cook/MainPages/SearchPage.dart';

import 'MainPages/SearchPage.dart';

List<Map<String, dynamic>> chatrooms = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final Color aquaGreen = const Color(0xFF1B8587);
  bool done = false;
  String route = "/sign-in";
  int currentPageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPageIndex);
    _fetchChatrooms();
  }

  Future<void> _fetchChatrooms() async {
    final userRef = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    final doc = await userRef.get();
    final data = doc.data() as Map<String, dynamic>;
    setState(() {
      chatrooms = List.from(data["chatrooms"]);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String truncateString(String text, int maxLength) {
    return text.length <= maxLength
        ? text
        : '${text.substring(0, maxLength - 3)}...';
  }

  void setIndex(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Future<QuerySnapshot> _checkUserData(String uid) async {
    return FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, isEqualTo: uid)
        .get();
  }

  Widget build(BuildContext context) {
    if (done) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.ubuntuCondensedTextTheme(),
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
                toolbarHeight: 80,
                title: Image.asset(
                  'lib/resources/LetsCookOfc.png', // Replace with your image path
                  fit: BoxFit.cover, // You can remove this if you don't want to fit the image
                  height: 80.0, // You can adjust the height as needed
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
                      icon: Icon(Icons.message, size: 30),
                      label: "Messages"),
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
                  ChatListPage(key: const PageStorageKey('MessagesPage'), rooms: chatrooms),
                  ProfilePage(
                      userID: FirebaseAuth.instance.currentUser!.uid,
                      key: const PageStorageKey('ProfilePage')),
                ],
              ),
            );
          },
        },
      );
    } else {
      route = FirebaseAuth.instance.currentUser == null ? "/sign-in" : "/home";
      if (route == "/home") {
        if (_checkUserData(FirebaseAuth.instance.currentUser!.uid) != null) {
          route = "/home";

          WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                done = true;
              }));
        } else {
          route = "/extra-page";
          WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                done = true;
              }));
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
              done = true;
            }));
      }
    }

    return Center(
      child: CircularProgressIndicator(
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      ),
    );
  }
}
