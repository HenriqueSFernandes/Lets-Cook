import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_cook/Components/HomePage/ProductCard.dart';

List<String> ingredients = [];
List<String> cooks = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  List<Product> products = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool matchesSearchCriteria(String searchText, Product product) {
    return product.dishName.toLowerCase().contains(searchText.toLowerCase()) ||
        product.userName.toLowerCase().contains(searchText.toLowerCase()) ||
        product.description.toLowerCase().contains(searchText.toLowerCase());
  }

  double minPrice = 0;
  double maxPrice = 1000;
  String _cook = '';

  Widget build(BuildContext context) {
    final collectionRef = db.collection("dishes");
    collectionRef.snapshots().listen(
      (event) {
        List<Product> updatedProducts = [];
        for (var element in event.docs) {
          updatedProducts.add(Product(
            userName: element["username"],
            dishName: element["mealname"],
            price: double.parse(element["price"].toString()),
            description: element["description"],
            userID: element["userid"],
            mealID: element.id,
            imageURLs: List<String>.from(element["images"]),
            ingredients: List<String>.from(element["ingredients"]),
          ));
        }
        if (!mounted) return;
        setState(() {
          products = updatedProducts;
        });
      },
      onError: (error) => print("Listen failed: $error"),
    );
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
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {}); // Trigger rebuild to apply filter
            },
            decoration: InputDecoration(
              hintText: 'Search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                // Set the border radius to a bigger value
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2.0,
                ), // Set border color to green and width to 2.0
              ),
              prefixIcon: PopupMenuButton<String>(
                icon: PopupMenuButton<String>(
                  icon: Icon(Icons.settings,
                      color: Theme.of(context).primaryColor),
                  onSelected: (value) async {
                    switch (value) {
                      case 'Ingredient':
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  IngredientSelectionScreen()),
                        );
                        setState(() {
                          ingredients = result;
                          for (var ingredient in ingredients) {
                            print(ingredient);
                          }
                        });
                        break;
                      case 'Cook':
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CookSelectionScreen()),
                        );
                        setState(() {
                          _cook = result;
                        });
                        break;
                      case 'Price':
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PriceSelectionScreen()),
                        );
                        if (result != null) {
                          // Check if result is not null to handle case where user cancels the selection
                          double minPrice_ = result[0];
                          double maxPrice_ = result[1];
                          setState(() {
                            minPrice = minPrice_;
                            maxPrice = maxPrice_;
                          });
                          // Now you can use minPrice and maxPrice as needed
                          print('Minimum Price: $minPrice');
                          print('Maximum Price: $maxPrice');
                        }
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Ingredient',
                      child: SizedBox(
                        height: 70,
                        child: ListTile(
                          leading: Icon(Icons.fastfood),
                          title: Text('Filter by Ingredient'),
                        ),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Cook',
                      child: SizedBox(
                        height: 70,
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Filter by Cook'),
                        ),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Price',
                      child: SizedBox(
                        height: 70,
                        child: ListTile(
                          leading: Icon(Icons.attach_money),
                          title: Text('Filter by Price'),
                        ),
                      ),
                    ),
                  ],
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Ingredient',
                    child: SizedBox(
                      height: 70,
                      child: ListTile(
                        leading: Icon(Icons.fastfood),
                        title: Text('Filter by Ingredient'),
                      ),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Cook',
                    child: SizedBox(
                      height: 70,
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Filter by Cook'),
                      ),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Price',
                    child: SizedBox(
                      height: 70,
                      child: ListTile(
                        leading: Icon(Icons.attach_money),
                        title: Text('Filter by Price'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: RawScrollbar(
              radius: const Radius.circular(20),
              child: SingleChildScrollView(
                child: Column(
                  children: products,
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
