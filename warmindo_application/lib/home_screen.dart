import 'package:flutter/material.dart';
import 'menu_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Warmindo Online")),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          buildWarungCard(context, "Warung A", [
            "assets/warmindo_A.png",
          
          ]),
          buildWarungCard(context, "Warung B", [
            "assets/warmindo_B.png",
  
          ]),
          buildWarungCard(context, "Warung C", [
            "assets/warmindo_C.png",
            
          ]),
        ],
      ),
    );
  }

  Widget buildWarungCard(BuildContext context, String name, List<String> imagePaths) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuScreen(warung: name),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Gambar-gambar dalam 1 baris
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: imagePaths.map((imagePath) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      imagePath,
                      width: 90,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 12),
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


