import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/cart.dart';
import 'package:flutter_lann/shop/providers/products.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class CartStatus extends StatelessWidget with ChangeNotifier {

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Builder(
        builder: (context) =>Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:<Widget>[
        DecimalNumberPicker(
          value: 3.0,
          minValue: 0,
          maxValue: 10,
          decimalPlaces: 1,
          onChanged: (value){},
        ),
         IconButton(
          icon: Icon(
            Icons.add_shopping_cart,
          ),
          onPressed: () {
            cart.addItem(
                loadedProduct.id, loadedProduct.price, loadedProduct.title);
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                'Added item to cart!',
              ),
              duration: Duration(seconds: 2),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () {
                  cart.removeSingleItem(loadedProduct.id);
                },
              ),
            ));
          },
          color: Theme.of(context).accentColor,
        ),
      ]
      ),
    );
  }
}
