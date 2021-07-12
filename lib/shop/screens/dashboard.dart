import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/interentview.dart';
import 'package:flutter_lann/shop/screens/home_screen.dart';

class Dashboard extends StatelessWidget {
  static const routeName = '/dashboard';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomePage(),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatelessWidget {
  List<Mycard> mycard = [
    Mycard(Icons.car_rental, 'Mietfahrzeuge', false),
    Mycard(Icons.hot_tub, 'Sauna /\nWellness', false),
    Mycard(Icons.brunch_dining, 'Brunchsaal', false),
    Mycard(Icons.local_see, 'Sehenswürdigkeiten', false),
    Mycard(Icons.directions_walk, 'Wanderungen', false),
    Mycard(Icons.celebration, 'Veranstaltungen', false),
    Mycard(Icons.local_dining, 'Restaurants', false),
    Mycard(Icons.local_mall, 'Einkaufen', false),
    Mycard(Icons.local_atm, 'Bankautomaten', false),
    Mycard(Icons.local_pharmacy, 'Medizinische Versorgung', false),
    Mycard(Icons.directions_bus, 'Bus & Bahn', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: mycard
                    .map(
                      (e) => InkWell(
                        onTap: () {
                          int idx = mycard.indexOf(e);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => idx == 0
                                    ? HomeScreen(1, 'https://postrelais.eu/mietfahrzeuge/', null)
                                    : idx == 1
                                        ? HomeScreen(1,'https://www.postrelais.eu/equipment/sauna-wellness/', null)
                                        : idx == 2
                                            ? HomeScreen(1,'https://www.postrelais.eu/equipment/saalvermietung/', null)
                                            : idx == 3
                                                ?HomeScreen(1,'https://postrelais.eu/sehenswuerdigkeiten/', null)
                                                : idx == 4
                                                    ? HomeScreen(1,'https://postrelais.eu/wanderungen/', null)
                                                    : idx == 5
                                                        ? HomeScreen(1,'https://postrelais.eu/veranstaltungen/', null)
                                                        : idx == 6
                                                            ? HomeScreen(1,'https://postrelais.eu/restaurants/', null)
                                                            : idx == 7
                                                                ? HomeScreen(1,'https://postrelais.eu/einkaufen/', null)
                                                                : idx == 8
                                                                    ? HomeScreen(1,'https://postrelais.eu/bankautomaten/', null)
                                                                    : idx == 9
                                                                        ? HomeScreen(1,'https://postrelais.eu/medizinische-versorgung/', null)
                                                                        : idx ==
                                                                                10
                                                                            ? HomeScreen(1,'https://postrelais.eu/oepnv/', null)
                                                                            : HomeScreen(1,'https://postrelais.eu', null)),
                          );
                        },
                        child: Card(
                          color: e.isActive
                              ? Color(0xffc9a42c)
                              : Color(0xff262f38),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                e.icon,
                                size: 50,
                                color: e.isActive
                                    ? Colors.white
                                    : Color(0xffc9a42c),
                              ),
                              SizedBox(height: 10),
                              Text(
                                e.title,
                                style: TextStyle(
                                    color: e.isActive
                                        ? Colors.black
                                        : Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Mycard {
  final icon;
  final title;
  bool isActive = false;

  Mycard(this.icon, this.title, this.isActive);
}
