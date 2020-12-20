import 'dart:convert';
import '../screens/detailView.dart';

import '../models/photoSearch.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryListViewBuilder extends StatefulWidget {
  final String catergoryName;

  CategoryListViewBuilder({this.catergoryName});

  @override
  _CategoryListViewBuilderState createState() =>
      _CategoryListViewBuilderState();
}

class _CategoryListViewBuilderState extends State<CategoryListViewBuilder> {
  int page = 1;
  PhotoSearchModel jsonPhotoHTTPGet;
  List<Photo> photos = List();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getCatergoryListWallpapers(page);
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getCatergoryListWallpapers(page);
      }
    });
  }

  getCatergoryListWallpapers(int pageNo) async {
    await http.get(
      "https://api.pexels.com/v1/search?query=${widget.catergoryName}&per_page=50&page=${pageNo.toString()}",
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
    return Container(
      padding: EdgeInsets.all(8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 10.0,
            height: double.infinity,
          );
        },
        itemCount: photos.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 125.0,
            height: double.infinity,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailView(
                      imgPath: photos[index].src.portrait,
                      original: photos[index].src.original,
                      imgID: photos[index].id,
                      photoGrapher: photos[index].photographer,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  children: [
                    Hero(
                      tag: photos[index].src.portrait,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: photos[index].src.portrait,
                          placeholder: (context, url) => Container(
                            color: Color(0xFBCDFFD),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
