import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaperplugin/wallpaperplugin.dart';

class DetailView extends StatefulWidget {
  final String imgPath;
  final String original;
  final String photoGrapher;
  final int imgID;

  DetailView({
    @required this.imgPath,
    @required this.original,
    @required this.photoGrapher,
    @required this.imgID,
  });

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  bool downloadImage = false;
  double appBarDownloading = 0;
  bool appBarDownloadingImage = false;
  String downPer = "0%";
  var filePath;
  String dropdownValue = "HomeScreen";
  Dio dio = new Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imgPath,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(
                imageUrl: widget.imgPath,
                placeholder: (context, url) => Container(
                  color: Color(0xfff5f8fd),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            child: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                widget.photoGrapher,
                overflow: TextOverflow.ellipsis,
              ),
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                downloadImage
                    ? Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            "Downloading.. $downPer",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    : Container(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _askPermission();
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white60,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Text(
                                    "Set Wallpaper",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _askPermission() async {
    var requestForStorage = await Permission.storage.status;
    if (requestForStorage.isUndetermined) {
      await Permission.storage.request();
    } else if (await Permission.storage.isPermanentlyDenied) {
      _showAlertAndOpenSettings(
          'Open Settings to Allow the Storage permission');
    } else if (await Permission.storage.isRestricted) {
      _showAlertDialog('Allow the Storage permission to Download the Image');
    }
    _save();
  }

  _save() async {
    var tmpPath = await getExternalStorageDirectory();
    String imageName = "${tmpPath.path}/Wallpaper_${widget.imgID}.png";
    dio.download(
      widget.original,
      imageName,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          String downloadingPer =
              ((received / total * 100).toStringAsFixed(0) + "%");
          setState(() {
            downPer = downloadingPer;
          });
        }
        setState(() {
          downloadImage = true;
        });
      },
    ).whenComplete(() {
      setState(() {
        downloadImage = false;
      });
      initPlatformState(imageName, dropdownValue);
    });
  }

  Future<void> _showAlertAndOpenSettings(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Denied '),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('Not Now'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Accept'),
              onPressed: () async {
                await openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAlertDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning !'),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                await Permission.storage.request();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> initPlatformState(String path, String dropdownValue) async {
    try {
      Wallpaperplugin.setWallpaperWithCrop(localFile: path);
    } on PlatformException {
      print("Platform exception");
    }
  }
}
// 8925372883
// @@tamil123
