import 'package:flutter/material.dart';
import 'payment_screen.dart'; // Import PaymentScreen di sini

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final double totalPrice;

  const CheckoutScreen({Key? key, required this.cart, required this.totalPrice})
    : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late List<Map<String, dynamic>> cart;
  late double totalPrice;

  @override
  void initState() {
    super.initState();
    cart =
        widget.cart.map((item) {
          // Menambahkan data untuk quantity jika belum ada
          item["quantity"] = item["quantity"] ?? 1;
          item["price"] = item["price"] ?? 0.0;
          return item;
        }).toList();

    totalPrice = cart.fold(0.0, (sum, item) {
      return sum + ((item["price"] ?? 0.0) * (item["quantity"] ?? 1));
    });
  }

  void updateQuantity(int index, int newQuantity) {
    setState(() {
      cart[index]["quantity"] = newQuantity;
      totalPrice = cart.fold(0.0, (sum, item) {
        return sum + ((item["price"] ?? 0.0) * (item["quantity"] ?? 1));
      });
    });
  }

  void removeItem(int index) {
    setState(() {
      cart.removeAt(index);
      totalPrice = cart.fold(0.0, (sum, item) {
        return sum + ((item["price"] ?? 0.0) * (item["quantity"] ?? 1));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  var item = cart[index];
                  return Card(
                    elevation: 4.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        item["menu"],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Jumlah pesanan dan harga per item
                          Text(
                            "Jumlah: ${item["quantity"] ?? 1}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Harga per Item: Rp${(item["price"] ?? 0.0) / (item["quantity"] ?? 1)}",
                            style: TextStyle(fontSize: 16),
                          ),

                          // Detail Topping dan Level Pedas untuk makanan
                          if (item["menu"].contains("Indomie")) ...[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Level Pedas: ${item["spicyLevel"] ?? 'Tidak Ada'}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "Topping: ${item["toppings"]?.join(", ") ?? 'Tidak Ada'}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],

                          // Detail Minuman
                          if (item["drink"] != "Tidak Ada") ...[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Minuman: ${item["drink"]}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (item["quantity"] > 1) {
                                updateQuantity(index, item["quantity"] - 1);
                              }
                            },
                          ),
                          Text(
                            "${item["quantity"]}",
                            style: TextStyle(fontSize: 18),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              updateQuantity(index, item["quantity"] + 1);
                            },
                          ),
                          // Tombol Hapus
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              removeItem(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Menampilkan Total Harga
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Total: Rp$totalPrice",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // Button untuk melanjutkan ke proses pembayaran
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman Pembayaran
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            PaymentScreen(cart: cart, totalPrice: totalPrice),
                  ),
                );
              },
              child: Text(
                "Lanjutkan ke Pembayaran",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
