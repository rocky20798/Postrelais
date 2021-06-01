import 'package:flutter/material.dart';
import 'package:flutter_lann/pages/info.dart';
import 'package:flutter_lann/pages/dashboard.dart';
import 'package:flutter_lann/pages/chat.dart';
import 'package:flutter_lann/shop/screens/products_overview.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{

  //Einstellungen

  int currentTab = 2;
  final List<Widget> screens = [
    Dashboard(),
    Info(),
    ProductsOverviewScreen(),
    //AuthScreen(),
    Chat(),
  ];

  // Aktive Seite (Tab)

  Widget currentScreen = ProductsOverviewScreen();  //initial screen in viewport

  final PageStorageBucket bucket = PageStorageBucket();


  @override
  Widget build(BuildContext context){
    return Scaffold(
      extendBody: true,
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      //FAB Button
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        backgroundColor: Color(0xffc9a42c),
        foregroundColor: Colors.black,
        onPressed: (){
          setState(() {
            currentScreen = ProductsOverviewScreen();
            currentTab = 2;
          },);
        },
      ),
      //FAB Position
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //BottomAppBar
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Color(0xff262f38),
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = Dashboard();
                        currentTab = 0;
                      },);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      Icon(
                        Icons.dashboard,
                        color: currentTab == 0 ? Color(0xffc9a42c): Colors.white,
                      ),
                      Text(
                        'Aktivitäten',
                        style: TextStyle(
                          color: currentTab == 0 ? Color(0xffc9a42c): Colors.white,
                        ),
                      )
                    ],),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = Info();
                        currentTab = 1;
                      },);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      Icon(
                        Icons.info,
                        color: currentTab == 1 ? Color(0xffc9a42c): Colors.white,
                      ),
                      Text(
                        'Info',
                        style: TextStyle(
                          color: currentTab == 1 ? Color(0xffc9a42c): Colors.white,
                        ),
                      )
                    ],),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        //currentScreen = AuthScreen();
                        currentTab = 3;
                      },);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color: currentTab == 3 ? Color(0xffc9a42c): Colors.white,
                        ),
                        Text(
                          'Profil',
                          style: TextStyle(
                            color: currentTab == 3 ? Color(0xffc9a42c): Colors.white,
                          ),
                        )
                      ],),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = Chat();
                        currentTab = 4;
                      },);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.chat,
                          color: currentTab == 4 ? Color(0xffc9a42c): Colors.white,
                        ),
                        Text(
                          'Kontakt',
                          style: TextStyle(
                            color: currentTab == 4 ? Color(0xffc9a42c): Colors.white,
                          ),
                        )
                      ],),
                  )
                ],
              )
            ]
          ),
        ),
      ),
    );
  }
}