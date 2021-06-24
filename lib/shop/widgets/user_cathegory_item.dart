import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/products.dart';
import 'package:flutter_lann/shop/screens/edit_cathegory.dart';
import 'package:provider/provider.dart';

class UserCathegoryItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserCathegoryItem(this.id, this.title, this.imageUrl);

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
                    .pushNamed(EditCathegoryScreen.routeName, arguments: id);
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
                                    await Provider.of<Cathegorys>(context,
                                            listen: false)
                                        .deleteCathegory(id);
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
