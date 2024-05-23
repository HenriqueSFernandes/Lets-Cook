import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/Components/HomePage/MealCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  List<MealCard> products = [];
  late QuerySnapshot collectionState;
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getMeals();
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0) {
        getNextMeals();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<double> getMealRating(String userID) async {
    final userRef = db.collection("users").doc(userID);
    final user = await userRef.get();
    if (user.data() != null) {
      if (user.data()!.containsKey('totalRating') &&
          user.data()!.containsKey('ratingCount')) {
        return (user['totalRating'] / user['ratingCount']);
      }
    }
    return 0.0;
  }

  Future<void> fetchDocuments(Query collection) async {
    collection.get().then((value) {
      collectionState = value;
      bool alreadyExists = false;
      value.docs.forEach((element) async {
        alreadyExists = false;
        double rating = await getMealRating(element["userid"]);
        setState(() {
          for (var mealID in products) {
            if (mealID.mealID == element.id) {
              alreadyExists = true;
              break;
            }
          }
          if (!alreadyExists) {
            products.add(MealCard(
              userName: element["username"],
              dishName: element["mealname"],
              price: double.parse(element["price"].toString()),
              description: element["description"],
              userID: element["userid"],
              mealID: element.id,
              imageURLs: List<String>.from(element["images"]),
              ingredients: List<String>.from(element["ingredients"]),
              rating: rating,
            ));
          }
        });
      });
    });
  }

  Future<void> getMeals() async {
    // TODO change the limit later
    final collection = FirebaseFirestore.instance
        .collection("dishes")
        .orderBy("mealname")
        .limit(4);
    await fetchDocuments(collection);
  }

  Future<void> getNextMeals() async {
    final lastVisible = collectionState.docs[collectionState.docs.length - 1];
    final collection = FirebaseFirestore.instance
        .collection("dishes")
        .orderBy("mealname")
        .startAfterDocument(lastVisible)
        .limit(3);
    await fetchDocuments(collection);
  }

  bool matchesSearchCriteria(String searchText, MealCard product) {
    return product.dishName.toLowerCase().contains(searchText.toLowerCase()) ||
        product.userName.toLowerCase().contains(searchText.toLowerCase()) ||
        product.description.toLowerCase().contains(searchText.toLowerCase());
  }

  double minPrice = 0;
  double maxPrice = 1000;
  String _cook = '';
  bool reload = false;

  Widget build(BuildContext context) {
    products = products
        .where(
            (product) => matchesSearchCriteria(_searchController.text, product))
        .toList();
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                if (value.isEmpty) {
                  FocusScope.of(context).unfocus();
                }
                getMeals();
                setState(() {}); // Trigger rebuild to apply filter
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero, // Add this line
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  ),
                ),
                prefixIcon:
                    Icon(Icons.search, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          products.isNotEmpty
              ? Expanded(
                  child: RefreshIndicator(
                    onRefresh: getMeals,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return products[index];
                      },
                    ),
                  ),
                )
              : const Expanded(
                  child: Center(
                    child: Text(
                      'No meals available, maybe add your own?',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
