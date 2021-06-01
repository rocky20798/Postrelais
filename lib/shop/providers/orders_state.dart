import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/orders.dart';

class OrderState with ChangeNotifier {
  Color getMessageColor(String stateOrder) {
    if (stateOrder == "Erstellt" || stateOrder == "Offen") {
      return Colors.orange;
    }
    if (stateOrder == "Abgebrochen" || stateOrder == "Verfallen") {
      return Colors.red;
    }
    if (stateOrder == "Zugelassen") {
      return Colors.lightGreen;
    }
    if (stateOrder == "Bezahlt" || stateOrder == "Abgeschlossen") {
      return Colors.green;
    }
    return Colors.yellow;
  }

  static List<String> _choiceListTitle = [
    "Alles",
    "Erstellt",
    "Bezahlt",
    "Offen",
    "Zugelassen",
    "Abgeschlossen",
    "Abgebrochen",
    "Verfallen"
  ];

  static List<String> _choiceListDescription = [
    "Alles",
    "Ihre Bestellung wird verarbeitet",
    "Die Online Zahlung war erfolgreich!",
    "",
    "Alle bestellten Wahren sind im Shop verfügbar. Bitte Zahlen Sie Online oder vor Ort.",
    "Vielen Dank für Ihren Einkauf!",
    "Bestellung wurde stoniert!",
    "Die Bestellung ist nicht mehr verfügbar!"
  ];

  List<String> get choiceList {
    return _choiceListTitle;
  }

  List<String> get choiceListDesc {
    return _choiceListDescription;
  }

  int choiceListPosition(String choiceListItem) {
    return _choiceListTitle.indexOf(choiceListItem);
  }

  String choiceListName(int pos) {
    return _choiceListTitle[pos];
  }

  List<OrderItem> sortOrders(int choice, List<OrderItem> orderList) {
    if (choice == 0) {
      return [...orderList];
    } else {
      return [...orderList.where((element) => element.stateOrder == choiceListName(choice))];
    }
  }
}
