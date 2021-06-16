import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [];
  List<String> _cathegory = [];
  List<String> _cathegoryId = [];
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<String> get cathegory {
    return [..._cathegory];
  }

  List<String> get cathegoryId {
    return [..._cathegoryId];
  }

  String getCathegoryId(String Cathegory) {
    int position = _cathegory.indexOf(Cathegory);
    return _cathegoryId[position];
  }

  List<Product> favCatItems(bool favorite, String cathegory) {
    if (favorite) {
      return _items.where((prodItem) => prodItem.isFavorite).toList();
    } else {
      if (cathegory != '') {
        return _items
            .where((prodItem) => prodItem.cathegory == cathegory)
            .toList();
      } else {
        return _items.toList();
      }
    }
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<String> fetchAndSetProducts([bool filterByUser = false]) async {
    fetchAndSetCathegory();
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      Map<String, dynamic> extractedData = null;
      if (response == null) {
        print("Data == null Products");
        return null;
      } else {
        extractedData = json.decode(response.body) as Map<String, dynamic>;
        if (extractedData == null) {
          return null;
        }
      }
      url =
          'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: double.parse(prodData['price'].toString()),
          cathegory: prodData['cathegory'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      return "Error";
    }
  }

  Future<String> fetchAndSetCathegory() async {
    var url =
        'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/cathegory.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      Map<String, dynamic> extractedData = null;
      if (response == null) {
        print("Data == null Cathegory");
        return null;
      } else {
        extractedData = json.decode(response.body) as Map<String, dynamic>;
        if (extractedData == null) {
          return null;
        }
      }
      List<String> _cat = [];
      List<String> _catId = [];
      extractedData.forEach((catId, catData) {
        _cat.add(catData);
        _catId.add(catId);
      });
      _cathegory = _cat;
      _cathegoryId = _catId;
      notifyListeners();
    } catch (error) {
      print(error);
      return "Error";
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'cathegory': product.cathegory,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        cathegory: product.cathegory,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addCathegory(String cathegory) async {
    final url =
        'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/cathegory.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(cathegory),
      );
      fetchAndSetCathegory();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'cathegory': newProduct.cathegory,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> updateCathegory(String id, String newCathegory) async {
    int catIndex = _cathegoryId.indexOf(id);
    print(catIndex);
    print(id);
    print(newCathegory);
    if (catIndex >= 0) {
      final url =
          'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/cathegory.json?auth=$authToken';
      await http.patch(
        Uri.parse(url),
        body: json.encode({id:newCathegory}),
      );
      _cathegory[catIndex] = newCathegory;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      //throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  Future<void> deleteCathegory(String id) async {
    final url =
        'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/cathegory/$id.json?auth=$authToken';
    final existingCathegoryIndex = _cathegoryId.indexOf(id);
    final existingCathegory = _cathegory[existingCathegoryIndex];
    _cathegory.removeAt(existingCathegoryIndex);
    _cathegoryId.removeAt(existingCathegoryIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      addCathegory(existingCathegory);
      notifyListeners();
      //throw HttpException('Could not delete product.');
    }
  }
}
