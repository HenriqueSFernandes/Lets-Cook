import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/Components/HomePage/MealCard.dart';

List<String> ingredients = [];
List<String> cooks = [];
var allProducts = [];

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
    if (user.data()!.containsKey('totalRating') &&
        user.data()!.containsKey('ratingCount')) {
      return (user['totalRating'] / user['ratingCount']);
    } else {
      return 0.0;
    }
  }

  Future<void> fetchDocuments(Query collection) async {
    collection.get().then((value) {
      collectionState = value;
      bool alreadyExists = false;
      value.docs.forEach((element) async {
        alreadyExists = false;
        double rating = await getMealRating(element["userid"]);
        setState(() {
          for (var mealID in products){
            if (mealID.mealID == element.id){
              alreadyExists = true;
              break;
            }
          }
          if (!alreadyExists){
            products.add(MealCard(
              userName: element["username"],
              dishName: element["mealname"],
              price: double.parse(element["price"].toString()),
              description: element["description"],
              userID: element["userid"],
              mealID: element.id,
              imageURLs: List<String>.from(element["images"]),
              ingredients: List<String>.from(element["ingredients"]),
              rating : rating,
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
            (product) => product.price >= minPrice && product.price <= maxPrice)
        .toList();

    if (!ingredients.isEmpty) {
      products = products.where((product) {
        return ingredients.any((ingredient) {
          return product.ingredients.any((productIngredient) {
            return productIngredient
                .toLowerCase()
                .contains(ingredient.toLowerCase());
          });
        });
      }).toList();
    }
    if (!cooks.isEmpty) {
      products = products.where((product) {
        return cooks.any((cook) {
          return product.userName.toLowerCase().contains(cook.toLowerCase());
        });
      }).toList();
    }
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
                prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
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

class IngredientSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Ingredient'),
      ),
      body: IngredientForm(), // Display the form
    );
  }
}

class IngredientForm extends StatefulWidget {
  @override
  _IngredientFormState createState() => _IngredientFormState();
}

class _IngredientFormState extends State<IngredientForm> {
  final TextEditingController _ingredientController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(ingredients[index]),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              ingredients.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showAddIngredientDialog(context);
              },
              child: const Text('Add Ingredient'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddIngredientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Ingredient'),
        content: TextField(
          controller: _ingredientController,
          decoration: const InputDecoration(labelText: 'Enter Ingredient'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                ingredients.add(_ingredientController.text);
                _ingredientController.clear();
              });
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class CookSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Cook'),
      ),
      body: CookForm(), // Display the form
    );
  }
}

class CookForm extends StatefulWidget {
  @override
  _CookFormState createState() => _CookFormState();
}

class _CookFormState extends State<CookForm> {
  final TextEditingController _cookController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cooks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(cooks[index]),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              cooks.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showAddCookDialog(context);
              },
              child: const Text('Add Cook'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCookDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Cook'),
        content: TextField(
          controller: _cookController,
          decoration: const InputDecoration(labelText: 'Enter Cook'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                cooks.add(_cookController.text);
                _cookController.clear();
              });
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cookController.dispose();
    super.dispose();
  }
}

class PriceSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Price'),
      ),
      body: PriceForm(), // Display the form
    );
  }
}

class PriceForm extends StatefulWidget {
  @override
  _PriceFormState createState() => _PriceFormState();
}

class _PriceFormState extends State<PriceForm> {
  double _minPrice = 0;
  double _maxPrice = 50;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Min : ${_minPrice.toStringAsFixed(2)} Max: ${_maxPrice.toStringAsFixed(2)}', // Round to 2 decimal places
            style: const TextStyle(fontSize: 16),
          ),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 0,
            max: 50,
            divisions: 50,
            onChanged: (RangeValues values) {
              setState(() {
                _minPrice = double.parse(values.start
                    .toStringAsFixed(2)); // Round to 2 decimal places
                _maxPrice = double.parse(
                    values.end.toStringAsFixed(2)); // Round to 2 decimal places
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Pass the selected minimum and maximum prices back to the previous screen
              Navigator.pop(context, [_minPrice, _maxPrice]);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
