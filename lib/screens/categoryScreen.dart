import '../widgets/categoryPhotos.dart';
import 'package:flutter/material.dart';
import '../models/categoryModel.dart';
import 'searchView.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categoryList.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      categoryList[index].name,
                      style: TextStyle(
                        fontFamily: "Raleway",
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_outlined,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SearchView(search: categoryList[index].name),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Container(
                height: 200.0,
                child: CategoryListViewBuilder(
                  catergoryName: categoryList[index].name,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
