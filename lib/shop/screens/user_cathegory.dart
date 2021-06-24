import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/products.dart';
import 'package:flutter_lann/shop/screens/cathegorys_overview.dart';
import 'package:flutter_lann/shop/screens/edit_cathegory.dart';
import 'package:flutter_lann/shop/screens/products_overview.dart';
import 'package:flutter_lann/shop/widgets/user_cathegory_item.dart';
import 'package:provider/provider.dart';

class UserCathegoryScreen extends StatelessWidget {
  static const routeName = '/user-cathegorys';

  Future<void> _refreshCathegorys(BuildContext context) async {
    await Provider.of<Cathegorys>(context, listen: false).fetchAndSetCathegorys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Kategorien'),
        backgroundColor: Color(0xff262f38),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(CathegorysOverviewScreen.routeName);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditCathegoryScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshCathegorys(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshCathegorys(context),
                    child: Consumer<Cathegorys>(
                      builder: (ctx, cathegorysData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: cathegorysData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserCathegoryItem(
                                cathegorysData.items[i].id,
                                cathegorysData.items[i].title,
                                cathegorysData.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
