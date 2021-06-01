import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Sind Sie sicher?'),
                  content: Text('Möchten Sie diesen Artikel löschen?'),
                  actions: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                        child: Text('Nein'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        }),
                    // ignore: deprecated_member_use
                    FlatButton(
                        child: Text('Ja'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        }),
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        color: Colors.grey,
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xffc9a42c),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('${price.toStringAsFixed(2)}€', style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
            title: Text(title, style: TextStyle(color: Colors.white)),
            subtitle: Text('Total: ${(price * quantity).toStringAsFixed(2)}€', style: TextStyle(color: Colors.white70)),
            trailing: Text('$quantity x', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
