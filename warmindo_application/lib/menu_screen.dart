import 'package:flutter/material.dart';
import 'checkout_screen.dart';

class MenuScreen extends StatefulWidget {
  final String warung;

  const MenuScreen({Key? key, required this.warung}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Map<String, dynamic>> cart = []; // Daftar pesanan
  double totalPrice = 0.0;

  String? selectedDrink;
  String? selectedDrinkType;
  List<String> selectedToppings = [];
  String? selectedSpicyLevel; // Level pedas untuk makanan

  final List<Map<String, dynamic>> drinks = [
    {"name": "Teh Manis", "price": 5000},
    {"name": "Jeruk", "price": 7000},
    {"name": "Kopi", "price": 8000},
    {"name": "Susu Coklat", "price": 10000},
    {"name": "Jus Alpukat", "price": 15000},
    {"name": "Jus Mangga", "price": 14000},
    {"name": "Jus Stroberi", "price": 16000},
    {"name": "Jus Sirsak", "price": 13000},
    {"name": "Wedang Jahe", "price": 11000},
    {"name": "Es Lemon Tea", "price": 9000},
  ];

  final List<String> drinkTypes = ["Es", "Hangat"]; // Pilihan untuk minuman

  final List<Map<String, dynamic>> indomieGoreng = [
    {"name": "Indomie Goreng Original", "price": 12000},
    {"name": "Indomie Goreng Rendang", "price": 13000},
    {"name": "Indomie Goreng Aceh", "price": 14000},
    {"name": "Indomie Goreng AFrika", "price": 13000},
    
  ];

  final List<Map<String, dynamic>> indomieRebus = [
    {"name": "Indomie Rebus Ayam Bawang", "price": 11000},
    {"name": "Indomie Rebus Soto Mie", "price": 11500},
  ];

  final List<String> spicyLevels = [
    "Tidak Pedas",
    "Pedas",
    "Sangat Pedas",
  ]; // Level pedas

  void addToCart(String foodName, double price) {
    setState(() {
      cart.add({
        "menu": foodName,
        "toppings": List<String>.from(selectedToppings),
        "drink":
            selectedDrink != null && selectedDrinkType != null
                ? "$selectedDrink ($selectedDrinkType)"
                : "Tidak Ada",
        "spicyLevel": selectedSpicyLevel ?? "Tidak Ada",
        "price": price,
      });
      totalPrice += price;
      selectedToppings.clear();
      selectedSpicyLevel = null;
      selectedDrink = null;
      selectedDrinkType = null;
    });
  }

  // Fungsi untuk memilih jenis minuman (Es atau Hangat)
  void showDrinkSelection(
    BuildContext context,
    String foodName,
    double basePrice,
  ) {
    selectedDrinkType = null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Pilih Jenis Minuman"),
              content: Column(
                children: [
                  Text("Jenis Minuman:"),
                  DropdownButton<String>(
                    value: selectedDrinkType,
                    hint: Text("Pilih Es/Hangat"),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedDrinkType = value;
                      });
                    },
                    items:
                        drinkTypes
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text("Tambah ke Pesanan"),
                  onPressed: () {
                    if (selectedDrinkType != null) {
                      addToCart(foodName, basePrice);
                      Navigator.pop(context);
                    } else {
                      // Menampilkan pesan error jika minuman belum dipilih
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Pilih jenis minuman terlebih dahulu!"),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Fungsi untuk memilih topping dan level pedas pada makanan
  void showFoodSelection(
    BuildContext context,
    String foodName,
    double basePrice,
  ) {
    selectedToppings = [];
    selectedSpicyLevel = null;

    // Konfirmasi Pesanan untuk Makanan
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Pilih Topping dan Level Pedas"),
              content: Column(
                children: [
                  // Pilihan Topping
                  Text("Pilih Topping:"),
                  ...[
                    "Keju",
                    "Sosis",
                    "Telur",
                    "Bakso",
                    "Kornet",
                    "Ayam Suwir",
                    "Ceker",
                    "Jamur",
                    "Tahu Crispy",
                    "Udang",
                  ].map((topping) {
                    return CheckboxListTile(
                      title: Text(topping),
                      value: selectedToppings.contains(topping),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            selectedToppings.add(topping);
                          } else {
                            selectedToppings.remove(topping);
                          }
                        });
                      },
                    );
                  }).toList(),
                  // Pilihan Level Pedas
                  Text("Pilih Level Pedas:"),
                  DropdownButton<String>(
                    value: selectedSpicyLevel,
                    hint: Text("Pilih Level Pedas"),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedSpicyLevel = value;
                      });
                    },
                    items:
                        spicyLevels
                            .map(
                              (level) => DropdownMenuItem(
                                value: level,
                                child: Text(level),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text("Tambah ke Pesanan"),
                  onPressed: () {
                    if (selectedToppings.isNotEmpty ||
                        selectedSpicyLevel != null) {
                      addToCart(foodName, basePrice);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Pilih topping dan level pedas!"),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildMenuList(String title, List<Map<String, dynamic>> menuList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...menuList.map((menu) {
          return ListTile(
            title: Text(menu["name"]),
            subtitle: Text("Rp${menu["price"]}"),
            trailing: Icon(Icons.add_circle, color: Colors.black),
            onTap: () {
              if (title == "🥤 Minuman") {
                // Memilih minuman dengan jenis Es atau Hangat
                selectedDrink = menu["name"];
                showDrinkSelection(
                  context,
                  menu["name"],
                  menu["price"].toDouble(),
                );
              } else {
                // Menampilkan dialog topping dan level pedas untuk makanan
                showFoodSelection(
                  context,
                  menu["name"],
                  menu["price"].toDouble(),
                );
              }
            },
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu - ${widget.warung}")),
      body: ListView(
        children: [
          buildMenuList("🍜 Indomie Goreng", indomieGoreng),
          buildMenuList("🍜 Indomie Rebus", indomieRebus),
          buildMenuList("🥤 Minuman", drinks),
        ],
      ),
      floatingActionButton:
          cart.isNotEmpty
              ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CheckoutScreen(
                            cart: cart,
                            totalPrice: totalPrice,
                          ),
                    ),
                  );
                },
                label: Text("Checkout (${cart.length})"),
                icon: Icon(Icons.shopping_cart),
              )
              : null,
    );
  }
}
