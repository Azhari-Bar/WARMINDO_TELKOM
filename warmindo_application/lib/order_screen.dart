import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'home_screen.dart';  // Pastikan untuk mengimpor HomeScreen

class OrderScreen extends StatefulWidget {
  final String orderId;

  const OrderScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  double _rating = 0.0;
  TextEditingController _reviewController = TextEditingController();

  // Fungsi untuk menampilkan dialog ulasan
  void _showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Beri Ulasan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Rating bar dengan 5 bintang
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 40.0,
                itemBuilder: (context, index) {
                  return const Icon(
                    Icons.star,
                    color: Colors.amber,
                  );
                },
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              const SizedBox(height: 12),
              // TextField untuk memasukkan ulasan
              TextField(
                controller: _reviewController,
                decoration: const InputDecoration(hintText: 'Tuliskan ulasan Anda'),
                maxLines: 4,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Logika untuk menyimpan review ke Firestore bisa ditambahkan di sini
                _saveReview();
                Navigator.of(context).pop(); // Menutup dialog setelah mengirim
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menyimpan review ke Firestore
  void _saveReview() {
    if (_reviewController.text.isNotEmpty && _rating > 0) {
      FirebaseFirestore.instance.collection('reviews').add({
        'order_id': widget.orderId,
        'rating': _rating,
        'review': _reviewController.text,
        'created_at': Timestamp.now(),
      });
      // Reset rating dan ulasan setelah disimpan
      setState(() {
        _rating = 0.0;
        _reviewController.clear();
      });
    } else {
      // Tampilkan pesan error jika rating atau ulasan kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rating dan Ulasan tidak boleh kosong')),
      );
    }
  }

  // Fungsi untuk membuat dan mengunduh PDF struk
  Future<void> _createPdf() async {
    // Ambil data pesanan
    var orderDoc = await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).get();
    var orderData = orderDoc.data() as Map<String, dynamic>;

    String productName = orderData['product_name'] ?? 'Tidak tersedia';
    int totalPrice = orderData['total_price'] ?? 0;
    String courier = orderData['courier'] ?? 'Tidak tersedia';
    String status = orderData['status'] ?? 'Tidak diketahui';
    Timestamp? completedAt = orderData['completed_at'];

    String formattedTime = completedAt != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(completedAt.toDate())
        : 'Belum tersedia';

    // Membuat PDF
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text('Struk Pembelian', style: pw.TextStyle(fontSize: 24)),
            pw.Text('Produk: $productName'),
            pw.Text('Total Harga: Rp $totalPrice'),
            pw.Text('Kurir: $courier'),
            pw.Text('Status: $status'),
            pw.Text('Waktu Selesai: $formattedTime'),
          ],
        );
      },
    ));

    // Menyimpan PDF ke penyimpanan perangkat
    final outputDir = await getApplicationDocumentsDirectory();
    final file = File('${outputDir.path}/struk_${widget.orderId}.pdf');
    await file.writeAsBytes(await pdf.save());

    // Tampilkan lokasi penyimpanan file
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Struk berhasil disimpan di ${file.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pesanan Selesai"),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('orders').doc(widget.orderId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Pesanan tidak ditemukan"));
          }

          var orderData = snapshot.data!.data() as Map<String, dynamic>;

          // Mengambil data dan memastikan tidak null
          String productName = orderData['product_name'] ?? 'Tidak tersedia';
          int totalPrice = orderData['total_price'] ?? 0;
          String courier = orderData['courier'] ?? 'Tidak tersedia';
          String status = orderData['status'] ?? 'Tidak diketahui';
          Timestamp? completedAt = orderData['completed_at'];

          // Format waktu selesai jika tersedia
          String formattedTime = completedAt != null
              ? DateFormat('dd MMM yyyy, HH:mm').format(completedAt.toDate())
              : 'Belum tersedia';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order ID: ${widget.orderId}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Produk: $productName", style: const TextStyle(fontSize: 16)),
                Text("Total Harga: Rp $totalPrice", style: const TextStyle(fontSize: 16)),
                Text("Kurir: $courier", style: const TextStyle(fontSize: 16)),
                Text("Status: $status", style: const TextStyle(fontSize: 16, color: Colors.green)),
                Text("Waktu Selesai: $formattedTime", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke HomeScreen dan hapus semua halaman sebelumnya
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()), // Arahkan ke HomeScreen
                      (Route<dynamic> route) => false, // Menghapus semua halaman sebelumnya
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Kembali ke Beranda", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 12),
                
                ElevatedButton(
                  onPressed: () {
                    _showReviewDialog(context); // Panggil fungsi popup di sini
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text("Beri Review", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 12),
                
                ElevatedButton(
                  onPressed: () {
                    _createPdf(); // Cetak PDF
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("Cetak Struk", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

