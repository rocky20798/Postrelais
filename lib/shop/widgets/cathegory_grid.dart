import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/products.dart';
import 'package:flutter_lann/shop/widgets/cathegory_item.dart';
import 'package:flutter_lann/shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

class CathegorysGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final cathegorysData = Provider.of<Cathegorys>(context);
    final cathegorys = cathegorysData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: cathegorys.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: cathegorys[i],
        child: CathegoryItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
