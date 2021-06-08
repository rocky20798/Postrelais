import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lann/pages/dashboard.dart';
import 'package:flutter_lann/shop/providers/auth.dart';
import 'package:flutter_lann/shop/providers/messages.dart';
import 'package:flutter_lann/shop/providers/orders.dart';
import 'package:flutter_lann/shop/providers/orders_state.dart';
import 'package:flutter_lann/shop/providers/products.dart';
import 'package:flutter_lann/shop/screens/auth_screen.dart';
import 'package:flutter_lann/shop/screens/cart.dart';
import 'package:flutter_lann/shop/screens/chat_screen.dart';
import 'package:flutter_lann/shop/screens/edit_product.dart';
import 'package:flutter_lann/shop/screens/home_screen.dart';
import 'package:flutter_lann/shop/screens/orders.dart';
import 'package:flutter_lann/shop/screens/product_detail.dart';
import 'package:flutter_lann/shop/screens/products_overview.dart';
import 'package:flutter_lann/shop/screens/splash-screen.dart';
import 'package:flutter_lann/shop/screens/user_products.dart';
import 'package:flutter_lann/shop/widgets/cart_status.dart';
import 'package:provider/provider.dart';
import 'package:flutter_lann/shop/providers/cart.dart';

//https://github.com/Xenon-Labs/Flutter-Development/tree/master/chat_app

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: OrderState(),
        ),
        ChangeNotifierProvider.value(
          value: CartStatus(),
        ),
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Messages>(
          update: (ctx, auth, previousMessages) => Messages(
            auth.token,
            auth.userId,
            previousMessages == null ? [] : previousMessages.items,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.red,
              fontFamily: 'Lato',
              scaffoldBackgroundColor: Colors.black),
          home: auth.isAuth
              ? HomeScreen(1, null, null)
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : HomeScreen(2, null, null),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => HomeScreen(1, null, 1),
            OrdersScreen.routeName: (ctx) => HomeScreen(1, null, 2),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            ProductsOverviewScreen.routeName: (ctx) =>
                HomeScreen(1, null, null),
            AuthScreen.routeName: (ctx) => HomeScreen(2, null, null),
            Dashboard.routeName: (ctx) => HomeScreen(0, null, null),
            ChatScreen.routeName: (ctx) => ChatScreen(),
          },
        ),
      ),
    );
  }
}
