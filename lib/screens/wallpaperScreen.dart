import 'dart:convert';

import 'package:WallpaperWorld/widgets/gridPhotos.dart';

import '../models/photoSearch.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WallpaperScreen extends StatefulWidget {
  @override
  _WallpaperScreenState createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  int page = 1;
  PhotoSearchModel jsonPhotoHTTPGet;
  List<Photo> photos = List();
  ScrollController _sc = ScrollController();
  @override
  void initState() {
    getWallpapers("wallpaper", page);
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        getWallpapers("wallpaper", page);
      }
    });
  }

  getWallpapers(String searchQuery, int pageNo) async {
    await http.get(
      "https://api.pexels.com/v1/search?query=$searchQuery&per_page=30&page=$pageNo",
      headers: {
        "Authorization":
            "563492ad6f917000010000015dc59bf9060640a9a07d1c540adf0382"
      },
    ).then((value) {
      jsonPhotoHTTPGet = photoSearchModelFromJson(value.body);
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      jsonData["photos"].forEach((element) {
        Photo photosModel = new Photo();
        photosModel = Photo.fromJson(element);
        photos.add(photosModel);
      });
      setState(() {
        page++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _sc,
      child: Container(
        child: Column(
          children: [
            gridPhotosList(context, photos),
          ],
        ),
      ),
    );
  }
}
