import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:wallpaper_app/Categories%20Classes/ChainsawManClass.dart';
import 'package:wallpaper_app/Categories%20Classes/JujutsuKaisenClass.dart';
import 'package:wallpaper_app/Categories%20Classes/blackcloverClass.dart';
import 'package:wallpaper_app/Categories%20Classes/bleachClass.dart';
import 'package:wallpaper_app/Categories%20Classes/blue_lock_class.dart';
import 'package:wallpaper_app/Categories%20Classes/deathnoteClass.dart';
import 'package:wallpaper_app/Categories%20Classes/demonslayerClass.dart';
import 'package:wallpaper_app/Categories%20Classes/dragonballClass.dart';
import 'package:wallpaper_app/Categories%20Classes/haikyuuClass.dart';
import 'package:wallpaper_app/Categories%20Classes/kaiju%20Class.dart';
import 'package:wallpaper_app/Categories%20Classes/myheroClass.dart';
import 'package:wallpaper_app/Categories%20Classes/narutoClass.dart';
import 'package:wallpaper_app/Categories%20Classes/onepieceClass.dart';
import 'package:wallpaper_app/Categories%20Classes/onepunchClass.dart';
import 'package:wallpaper_app/Categories%20Classes/soloLevelingClass.dart';

import 'Categories Classes/CategoriesOpen.dart';

class Categoryclass extends StatefulWidget {
  const Categoryclass({super.key});

  @override
  State<Categoryclass> createState() => _CategoryclassState();
}

class _CategoryclassState extends State<Categoryclass> {
  final DatabaseReference _categoryRef =
  FirebaseDatabase.instance.ref('FlutterDatabase/Categories');
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    _categoryRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          categories.clear();
          data.forEach((key, value) {
            categories.add(Map<String, dynamic>.from(value));
          });
        });
      }
    });
  }

  void _navigateToCategory(BuildContext context, Map<String, dynamic> category) {
    final categoryName = category['category'] ?? 'No name';
    switch (categoryName) {
      case 'Attack on Titan':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Categoriesopen(
              categoryName: categoryName,
              categoryImageUrl: category['imgUrl'] ?? '',
            ),
          ),
        );
        break;
      case 'Blue lock ':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => blue_lock_class(categoryName: categoryName, categoryImageUrl: ['imgUrl']),
          ),
        );
        break;
      case 'Naruto ':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => narutoClass(categoryName: categoryName, categoryImageUrl: ['imgUrl']),
          ),
        );
        break;
      case 'Solo Leveling':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => soloLevelingClass(categoryName: categoryName, categoryImageUrl: ['imgUrl']),
          ),
        );
        break;
      case 'Demon Slayer':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => demonslayerClass(categoryName: categoryName, categoryImageUrl: ['imgUrl']),
          ),
        );
        break;
      case 'Kaiju No. 8':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => kaijuClass(categoryName: categoryName, categoryImageUrl: ['imgUrl']),
          ),
        );
        break;
      case 'My Hero Academia':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => myheroClass(categoryName: categoryName, categoryImageUrl: ['imgUrl']),
          ),
        );
        break;
      case 'Death Note':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => deathnoteClass(categoryName: categoryName, categoryImageUrl: ['imgUrl']),
          ),
        );
        break;
      case 'Black Clover':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => blackcloverClass(categoryName: categoryName, categoryImageUrl: ['imgUrl']),
          ),
        );
        break;
      case 'Bleach':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => bleachClass(categoryName: categoryName, categoryImageUrl: ['imgUrl']),
          ),
        );
        break;
      case 'Dragon Ball Z':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => dragonballClass(categoryName: categoryName, categoryImageUrl: ['imgUrl']),
          ),
        );
        break;
      case 'One Piece':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => onepieceClass(categoryName: categoryName, categoryImageUrl: ['imgUrl']),
          ),
        );
        break;
      case 'Jujutsu Kaisen':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JujutsuKaisenClass(categoryName: categoryName, categoryImageUrl: ['imgUrl']),
          ),
        );
        break;
      case 'Chainsaw Man':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChainsawManClass(categoryName: categoryName, categoryImageUrl: ['imgUrl']),
          ),
        );
        break;
      case 'Haikyu!!':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => haikyuuClass(categoryName: categoryName, categoryImageUrl: ['imgUrl']),
          ),
        );
        break;
      case 'One-Punch Man':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => onepunchClass(categoryName: categoryName, categoryImageUrl: ['imgUrl']),
          ),
        );
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No class available for $categoryName')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Categories', style: TextStyle(color: Colors.white,),),
          backgroundColor: Colors.grey.shade500, // Background color
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
          child: categories.isEmpty
              ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
          )
              : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return Card(
                color: Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Center(
                        child: InkWell(
                          child: Image.network(
                            cat['imgUrl'],
                            fit: BoxFit.contain,
                            width: 250,
                            height: 250,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.image,
                                    size: 50, color: Colors.white),
                              );
                            },
                          ),
                          onTap: () => _navigateToCategory(context, cat),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black54,
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            cat['category'] ?? 'No name',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
