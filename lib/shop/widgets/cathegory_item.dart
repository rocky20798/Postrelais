import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/auth.dart';
import 'package:flutter_lann/shop/providers/product.dart';
import 'package:flutter_lann/shop/screens/product_detail.dart';
import 'package:flutter_lann/shop/screens/products_overview.dart';
import 'package:provider/provider.dart';

class CathegoryItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final cathegory = Provider.of<Cathegory>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.white,
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductsOverviewScreen.routeName,
                arguments: cathegory.id,
              );
            },
            child: FadeInImage(
                placeholder: AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(cathegory.imageUrl),
                fit: BoxFit.cover,
              ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              cathegory.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
