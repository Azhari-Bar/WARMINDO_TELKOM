import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_screen.dart'; // Pastikan file ini ada

class TrackingScreen extends StatefulWidget {
  final String orderId;

  const TrackingScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  String status = "Menunggu Konfirmasi";
  String kurir = "-";

  @override
  void initState() {
    super.initState();
    _getOrderStatus();
  }

  void _getOrderStatus() {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        String newStatus = snapshot.data()?['status'] ?? "Menunggu Konfirmasi";
        String newKurir = snapshot.data()?['courier'] ?? "-";

        setState(() {
          status = newStatus;
          kurir = newKurir;
        });

        if (newStatus == "Diterima") {
          // Jika pesanan diterima, langsung navigasi ke OrderScreen
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OrderScreen(orderId: widget.orderId),
              ),
            );
          });
        }
      }
    });
  }

  void _markAsReceived() async {
    // Update status di Firestore
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .update({'status': 'Diterima'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lacak Pesanan"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Order ID: ${widget.orderId}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "Status Pesanan: $status",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Kurir: $kurir",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            
            // Tombol Pesanan Diterima
            if (status != "Diterima") 
              ElevatedButton(
                onPressed: _markAsReceived,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Pesanan Diterima", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            
            const SizedBox(height: 12), // Jarak antara tombol
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Kembali", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}




