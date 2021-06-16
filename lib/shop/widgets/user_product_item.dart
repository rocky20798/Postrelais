import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/products.dart';
import 'package:flutter_lann/shop/screens/edit_product.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        backgroundColor: Colors.white,
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Colors.blue,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
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
                                onPressed: () async {
                                  Navigator.of(context).pop(false);
                                  try {
                                    await Provider.of<Products>(context,
                                            listen: false)
                                        .deleteProduct(id);
                                  } catch (error) {
                                    // ignore: deprecated_member_use
                                    scaffold.showSnackBar(SnackBar(
                                        content: Text(
                                      'deleting failed',
                                      textAlign: TextAlign.center,
                                    )));
                                  }
                                }),
                          ],
                        ));
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
