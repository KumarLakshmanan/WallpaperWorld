import 'dart:convert';
import '../models/photoSearch.dart';
import '../widgets/gridPhotos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = new TextEditingController();
  int page = 1;
  int searching = 0;
  String searchText;
  PhotoSearchModel jsonPhotoHTTPGet;
  List<Photo> photos = List();
  ScrollController _searchScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchScrollController.addListener(() {
      if (_searchScrollController.position.pixels ==
          _searchScrollController.position.maxScrollExtent) {
        getSearchScreenWallpapers(searchText, page);
      }
    });
  }

  void _clearAllItems() {
    for (var i = 0; i <= photos.length; i++) {
      photos.remove(i);
    }
    photos.clear();
    setState(() {});
  }

  getSearchScreenWallpapers(String searchQuery, int pageNo) async {
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
        searching = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _searchScrollController,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.circular(30),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search ...",
                      border: InputBorder.none,
                    ),
                    onEditingComplete: () {
                      setState(() {
                        page = 1;
                        searchText = searchController.text;
                        searching = 1;
                      });
                      _clearAllItems();
                      getSearchScreenWallpapers(searchController.text, 1);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      page = 1;
                      searchText = searchController.text;
                      searching = 1;
                    });
                    _clearAllItems();
                    getSearchScreenWallpapers(searchController.text, 1);
                  },
                ),
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              SizedBox(height: 40.0),
              photos.length == 0
                  ? Container(
                      height: MediaQuery.of(context).size.height -
                              (kToolbarHeight * 2),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: searching == 0
                            ? Text("Search Your Own Photos")
                            : SizedBox(
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                      ),
                                    ),
                                    SizedBox(width: 20.0),
                                    Text("Loading ..."),
                                  ],
                                ),
                              ),
                      ),
                    )
                  : Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                                "${jsonPhotoHTTPGet.totalResults} Photos Found for $searchText."),
                          ),
                          gridPhotosList(context, photos),
                        ],
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
