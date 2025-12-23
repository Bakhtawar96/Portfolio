import 'package:flutter/material.dart';
import 'package:wallpaper_app/openClass.dart';
import 'database_helper.dart';
class FavouriteClass extends StatefulWidget {
  @override
  State<FavouriteClass> createState() => _FavouriteClassState();
}
class _FavouriteClassState extends State<FavouriteClass> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<String> _favoriteWallpapers = [];
  List<String> imageUrls = [];
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }
  Future<void> _loadFavorites() async {
    final favorites = await _dbHelper.getFavorites();
    setState(() {
      _favoriteWallpapers = favorites;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Wallpapers',style: TextStyle(color: Colors.white,),),
      backgroundColor: Colors.grey.shade500,
    ),
      body: _favoriteWallpapers.isEmpty
          ? Center(child: Text(
          'No favorites added yet.', style: TextStyle(fontSize: 18))
      )
          : Padding(
            padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
            child: GridView.builder(
                    itemCount: _favoriteWallpapers.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        childAspectRatio: 1/2
                    ),
                    itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _openWallpaperViewer(index),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        12),
                ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/loadingfull.gif",
                      image: _favoriteWallpapers[index],
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
  void _openWallpaperViewer(int index) {
  Navigator.push(context, MaterialPageRoute(builder: (context)=> OpenClass(imageUrls: _favoriteWallpapers, initialIndex: index))
  );

  }
}
