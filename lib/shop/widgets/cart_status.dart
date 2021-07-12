import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/cart.dart';
import 'package:flutter_lann/shop/providers/products.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class CartStatus extends StatelessWidget with ChangeNotifier {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => _IntegerExample(),
    );
  }
}

class _IntegerExample extends StatefulWidget {
  @override
  __IntegerExampleState createState() => __IntegerExampleState();
}

class __IntegerExampleState extends State<_IntegerExample> {
  int _currentIntValue = 0;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      NumberPicker(
        value: _currentIntValue,
        minValue: 0,
        maxValue: 20,
        step: 1,
        haptics: true,
        onChanged: (value) => setState(() => _currentIntValue = value),
      ),
      Text("x ${loadedProduct.price.toStringAsFixed(2)}€ = ${(loadedProduct.price * _currentIntValue).toStringAsFixed(2)}€", style: TextStyle(color: Colors.white, fontSize: 20),),
      if(_currentIntValue > 0)
      IconButton(
        icon: Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () {
          cart.addItems(
              loadedProduct.id, loadedProduct.price, loadedProduct.title, _currentIntValue);
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              'Added item to cart!',
            ),
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                cart.removeMultiItems(loadedProduct.id, _currentIntValue);
              },
            ),
          ));
        },
        color: Theme.of(context).accentColor,
      ),
    ]);
  }
}
