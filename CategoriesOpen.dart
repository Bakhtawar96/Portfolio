import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/openClass.dart';

class Categoriesopen extends StatefulWidget {
  const Categoriesopen({super.key, required categoryName, required categoryImageUrl});

  @override
  State<Categoriesopen> createState() => _HomeClassState();
}

class _HomeClassState extends State<Categoriesopen> {
  List<String> imageUrls = [];
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchImageUrls();
  }

  Future<void> _fetchImageUrls() async {
    if (isDataLoaded) return;
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref("FlutterDatabase/titan");
    try {
      DataSnapshot snapshot = await databaseReference.get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        List<String> fetchedUrls = [];
        values.forEach((key, value) {
          if (value['imgUrl'] != null) {
            fetchedUrls.add(value['imgUrl']);
          }
        });
        setState(() {
          imageUrls = fetchedUrls;
          isDataLoaded = true;
        });
      } else {
        print("No data available");
        setState(() {
          isDataLoaded = true;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isDataLoaded = true;
      });
    }
  }

  void _openWallpaperViewer(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OpenClass(imageUrls: imageUrls, initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attack on Titan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
        child: imageUrls.isEmpty
            ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        )
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: 1 / 2,
          ),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _openWallpaperViewer(index),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/loadingfull.gif",
                    image: imageUrls[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
