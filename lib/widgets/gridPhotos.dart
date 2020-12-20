import '../screens/detailView.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/photoSearch.dart';
import 'package:flutter/material.dart';

Widget gridPhotosList(BuildContext context, List<Photo> listPhotos) {
  var size = MediaQuery.of(context).size;
  final double itemHeight = (size.height - kToolbarHeight) / 2;
  final double itemWidth = (size.width / 2);
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
      padding: const EdgeInsets.all(5.0),
      childAspectRatio: (itemWidth / itemHeight),
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      children: listPhotos.map((Photo photoModel) {
        return GridTile(
          footer: GridTileBar(
            subtitle: Text(photoModel.photographer),
            backgroundColor: Colors.black38,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailView(
                    imgPath: photoModel.src.portrait,
                    original: photoModel.src.original,
                    imgID: photoModel.id,
                    photoGrapher: photoModel.photographer,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Hero(
                    tag: photoModel.src.portrait,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: photoModel.src.portrait,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
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
      }).toList(),
    ),
  );
}
