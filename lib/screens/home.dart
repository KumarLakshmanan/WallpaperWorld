import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'searchScreen.dart';
import 'categoryScreen.dart';
import 'wallpaperScreen.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  PageController controller = PageController();
  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  checkConnection() async {
    var listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          _showMyDialog();
          break;
      }
    });
    await Future.delayed(Duration(seconds: 30));
    await listener.cancel();
  }

  Future _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Connection Lost !!!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'This App Needs Internet Connection.Please Check Internet Connection and Try again.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text.rich(
          TextSpan(
            style: TextStyle(
              fontFamily: 'Raleway',
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Wallpaper',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'World',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                title: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Wallpaper',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'World',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              UserAccountsDrawerHeader(
                accountName: Text("Lakshmanan Kumar"),
                accountEmail: Text("klakshmanan48@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage("image/author.jpg"),
                  backgroundColor: Colors.transparent,
                ),
              ),
              ListTile(
                title: Text("Share"),
                subtitle: Text("Share this app with friends"),
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.share),
                ),
                onTap: () {
                  Share.share(
                      'Check Out This Cool Awesome Wallpaper App.\n\nChange Your Phone Walpaper in a seconds. \n\nhttps://www.codingfrontend.com/2020/12/wallpaper-world-android-app.html');
                },
              ),
              ListTile(
                title: Text("Contact"),
                subtitle: Text("admin@codingfrontend.com"),
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.email),
                ),
                onTap: () async {
                  await launch("mailto:admin@codingfronted.com");
                },
              ),
              ListTile(
                title: Text("Website"),
                subtitle: Text("https://codingfrontend.com"),
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.vpn_lock),
                ),
                onTap: () async {
                  await launch("https://codingfrontend.com");
                },
              ),
              ListTile(
                title: Text("App Version"),
                subtitle: Text("1.0.0"),
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.android_outlined),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Container(
                height: 40.0,
                width: double.infinity,
                child: Center(
                  child: Text(
                    "- Kumar Lakshmanan",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: PageView.builder(
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
        controller: controller,
        itemBuilder: (BuildContext context, int index) {
          return getScreen(index);
        },
        itemCount: 3,
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          controller.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text('Wallpaper'),
            activeColor: Colors.purple,
            inactiveColor: Colors.black,
            textAlign: TextAlign.center,
            icon: Icon(
              Icons.wallpaper_outlined,
            ),
          ),
          BottomNavyBarItem(
            title: Text('Categories'),
            activeColor: Colors.teal,
            inactiveColor: Colors.black,
            textAlign: TextAlign.center,
            icon: Icon(
              Icons.category_outlined,
            ),
          ),
          BottomNavyBarItem(
            title: Text('Search'),
            activeColor: Colors.deepOrange,
            inactiveColor: Colors.black,
            textAlign: TextAlign.center,
            icon: Icon(
              Icons.search,
            ),
          ),
        ],
      ),
    );
  }
}

getScreen(int selectedIndex) {
  if (selectedIndex == 0) {
    return WallpaperScreen();
  } else if (selectedIndex == 1) {
    return CategoryScreen();
  } else if (selectedIndex == 2) {
    return SearchScreen();
  }
}
