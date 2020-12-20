import 'dart:convert';
import '../models/photoSearch.dart';
import '../widgets/gridPhotos.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchView extends StatefulWidget {
  final String search;
  SearchView({@required this.search});
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  int page = 1;
  PhotoSearchModel jsonPhotoHTTPGet;
  List<Photo> photos = List();
  ScrollController _sc = ScrollController();

  @override
  void initState() {
    getWallpapers(widget.search, page);
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        getWallpapers(widget.search, page);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.search),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        controller: _sc,
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    "${jsonPhotoHTTPGet.totalResults} Photos Found for ${widget.search}."),
              ),
              gridPhotosList(context, photos),
            ],
          ),
        ),
      ),
    );
  }
}
