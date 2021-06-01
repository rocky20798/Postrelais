import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/auth.dart';
import 'package:flutter_lann/shop/providers/cart.dart';
import 'package:flutter_lann/shop/providers/products.dart';
import 'package:flutter_lann/shop/screens/cart.dart';
import 'package:flutter_lann/shop/widgets/badge.dart';
import 'package:flutter_lann/shop/widgets/cart_status.dart';
import 'package:provider/provider.dart';

import 'auth_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final _auth = Provider.of<Auth>(context);
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
        backgroundColor: Color(0xff262f38),
        actions: <Widget>[
          _auth.isAnonym
              ? IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AuthScreen.routeName);
                  },
                )
              : Consumer<Cart>(
                  builder: (_, cart, ch) => Badge(
                    child: ch,
                    value: cart.itemCountTotal.toString(),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                  ),
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.white,
              child: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${loadedProduct.price.toStringAsFixed(2)}€',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            if (!_auth.isAnonym) CartStatus(),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
