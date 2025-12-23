import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import fluttertoast
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'database_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class OpenClass extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const OpenClass({super.key, required this.imageUrls, required this.initialIndex});

  @override
  State<OpenClass> createState() => _OpenClassState();
}

class _OpenClassState extends State<OpenClass> {
  late PageController _pageController;
  late int _currentIndex;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Set<String> _favoriteWallpapers = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _loadFavorites();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _loadFavorites() async {
    final favorites = await _dbHelper.getFavorites();
    setState(() {
      _favoriteWallpapers = favorites.toSet();
    });
  }

  Future<void> _toggleFavorite(String imgUrl) async {
    if (_favoriteWallpapers.contains(imgUrl)) {
      await _dbHelper.removeFavorite(imgUrl);
      setState(() {
        _favoriteWallpapers.remove(imgUrl);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from Favorites!')),
      );
    } else {
      await _dbHelper.addFavorite(imgUrl);
      setState(() {
        _favoriteWallpapers.add(imgUrl);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to Favorites!')),
      );
    }
  }

  Future<void> _downloadImage(String imageUrl) async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      Fluttertoast.showToast(
        msg: "Download not started: Storage permission is required.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // Notify user that the download has started
    Fluttertoast.showToast(
      msg: "Downloading is started...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;
        final directory = await _getStorageDirectory();
        if (directory != null) {
          final filePath =
              '${directory.path}/wallpaper_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final file = File(filePath);
          await file.writeAsBytes(bytes);

          final saved = await GallerySaver.saveImage(file.path);
          if (saved == true) {
            Fluttertoast.showToast(
              msg: "Image saved to gallery successfully.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          } else {
            throw Exception('Failed to save the image to gallery.');
          }
        } else {
          throw Exception('Failed to access storage directory.');
        }
      } else {
        throw Exception('Failed to download image. HTTP status code: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error downloading image: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<Directory?> _getStorageDirectory() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        Fluttertoast.showToast(
          msg: "Storage permission is required to save images.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return null;
      }
      return await getExternalStorageDirectory();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.imageUrls[index],
                fit: BoxFit.cover,
              );
            },
          ),
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _toggleFavorite(widget.imageUrls[_currentIndex]),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      _favoriteWallpapers.contains(widget.imageUrls[_currentIndex])
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _downloadImage(widget.imageUrls[_currentIndex]),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.download,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _shareImage(widget.imageUrls[_currentIndex]),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 50, left: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _shareImage(String imageUrl) {
  Share.share(
    'Check out this wallpaper: $imageUrl',
    subject: 'Awesome Wallpaper!',
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.notification?.title}');
}
