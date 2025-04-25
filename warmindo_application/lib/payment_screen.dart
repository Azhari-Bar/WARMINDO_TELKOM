import 'package:flutter/material.dart';
import 'tracking_screen.dart'; // Import TrackingScreen

class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final double totalPrice;

  const PaymentScreen({Key? key, required this.cart, required this.totalPrice})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = "Transfer Bank";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pembayaran")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rincian Pesanan",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  var item = widget.cart[index];
                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        item["menu"],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jumlah: ${item["quantity"] ?? 1}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Harga per Item: Rp${(item["price"] ?? 0.0) / (item["quantity"] ?? 1)}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          if (item["menu"].contains("Indomie")) ...[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Level Pedas: ${item["spicyLevel"] ?? 'Tidak Ada'}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "Topping: ${item["toppings"]?.join(", ") ?? 'Tidak Ada'}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                          if (item["drink"] != "Tidak Ada") ...[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Minuman: ${item["drink"]}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Total: Rp${widget.totalPrice}",
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            const Text(
              "Metode Pembayaran",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text("Transfer Bank"),
              leading: Radio<String>(
                value: "Transfer Bank",
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Kartu Kredit/Debit"),
              leading: Radio<String>(
                value: "Kartu Kredit/Debit",
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Gopay"),
              leading: Radio<String>(
                value: "Gopay",
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Notifikasi pembayaran berhasil
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Pembayaran berhasil dengan metode $selectedPaymentMethod!"),
                    duration: const Duration(seconds: 2),
                  ),
                );

                // Navigasi ke halaman TrackingScreen setelah pembayaran berhasil
                Navigator.push(
                  context,
                  MaterialPageRoute(
                     builder: (context) => TrackingScreen(orderId: "order123"),
                  ),
                );
              },
              child: const Text(
                "Selesaikan Pembayaran",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

