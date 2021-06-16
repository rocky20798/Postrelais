import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/products.dart';
import 'package:flutter_lann/shop/screens/products_overview.dart';
import 'package:provider/provider.dart';

class UserCathegoryScreen extends StatefulWidget {
  static const routeName = '/user-cathegory';

  @override
  _UserCathegoryScreenState createState() => _UserCathegoryScreenState();
}

class _UserCathegoryScreenState extends State<UserCathegoryScreen> {
  @override
  Widget build(BuildContext context) {
    final _productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Kategorien'),
        backgroundColor: Color(0xff262f38),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(ProductsOverviewScreen.routeName);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                _productsData.addCathegory("Neue Gruppe");
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _productsData.cathegory.length,
        itemBuilder: (_, i) => Column(
          children: [
            editCathegoryWidget(
                _productsData.cathegoryId[i], _productsData.cathegory[i])
          ],
        ),
      ),
    );
  }
}

class editCathegoryWidget extends StatefulWidget {
  String id;
  String title;

  editCathegoryWidget(this.id, this.title);

  @override
  _editCathegoryWidgetState createState() => _editCathegoryWidgetState();
}

class _editCathegoryWidgetState extends State<editCathegoryWidget> {
  bool _editMode = false;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final _productsData = Provider.of<Products>(context, listen: false);
    return Column(
      children: [
        ListTile(
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(_editMode ? Icons.save : Icons.edit),
                  onPressed: () async {
                    try {
                      if (_editMode) {
                        await Provider.of<Products>(context, listen: false)
                            .updateCathegory(widget.id, _controller.text);
                      }
                      setState(() {
                        _editMode = !_editMode;
                      });
                    } catch (error) {
                      // ignore: deprecated_member_use
                      SnackBar(
                          content: Text(
                        'deleting failed',
                        textAlign: TextAlign.center,
                      ));
                    }
                  },
                  color: Colors.blue,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    try {
                      await Provider.of<Products>(context, listen: false)
                          .deleteCathegory(widget.id);
                      setState(() {});
                    } catch (error) {
                      // ignore: deprecated_member_use
                      SnackBar(
                          content: Text(
                        'deleting failed',
                        textAlign: TextAlign.center,
                      ));
                    }
                  },
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
        _editMode
            ? TextFormField(
                style: TextStyle(color: Colors.white),
                controller: _controller,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    labelText: 'Test Label',
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    hintStyle: TextStyle(color: Colors.blueGrey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xffc9a42c), width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0))),
                keyboardType: TextInputType.name,
                validator: (value) {},
                onSaved: (value) {},
              )
            : Divider()
      ],
    );
  }
}
