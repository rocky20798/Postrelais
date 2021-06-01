import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/screens/products_overview.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

enum AuthMode { Angestellter, Gast }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.black,
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Image.asset(
                      "assets/images/postrelais.png",
                      height: deviceSize.height * 0.25,
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _formKey2 = GlobalKey();
  AuthMode _authMode = AuthMode.Gast;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Auth>(context, listen: false).signInWithEmailAndPassword(
      _authData['email'],
      _authData['password'],
    );
    setState(() {
      _isLoading = false;
      Navigator.of(context)
          .pushReplacementNamed(ProductsOverviewScreen.routeName);
    });
  }

  Future<void> _submitSMS() async {
    if (!_formKey2.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey2.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .verifyPhoneNumber(_authData['phone']);
    } catch (error) {
      setState(() {
        _isLoading = false;
        Navigator.of(context)
            .pushReplacementNamed(ProductsOverviewScreen.routeName);
      });
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
  }

  Future<void> _submitAnonym() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).signInAnonymously();
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
      Navigator.of(context)
          .pushReplacementNamed(ProductsOverviewScreen.routeName);
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Gast) {
      setState(() {
        _authMode = AuthMode.Angestellter;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Gast;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        color: Color(0xff262f38),
        height: 260,
        constraints: BoxConstraints(minHeight: 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (_authMode != AuthMode.Angestellter)
                  Form(
                    key: _formKey2,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          labelText: 'Handynummer',
                          hintText: '+32470000000',
                          labelStyle: TextStyle(color: Colors.blueGrey),
                          hintStyle: TextStyle(color: Colors.blueGrey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffc9a42c), width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0))),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Leeres Eingabefeld!';
                        } else if (!value.contains('+')) {
                          return '00 -> + !!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['phone'] = value;
                      },
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
                if (_isLoading && _authMode != AuthMode.Angestellter)
                  CircularProgressIndicator()
                else if (_authMode != AuthMode.Angestellter)
                  RaisedButton(
                    child: Text('Login'),
                    onPressed: _submitSMS,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Color(0xffc9a42c),
                    textColor: Colors.black,
                  ),
                if (_authMode != AuthMode.Angestellter && !_isLoading)
                  RaisedButton(
                    child: Text('Nur schauen'),
                    onPressed: _submitAnonym,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Color(0xffc9a42c),
                    textColor: Colors.black,
                  ),
                if (_authMode == AuthMode.Angestellter)
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        labelText: 'E-Mail',
                        labelStyle: TextStyle(color: Colors.blueGrey),
                        hintStyle: TextStyle(color: Colors.blueGrey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xffc9a42c), width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0))),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Fehlerhafte E-Mail!';
                      }
                    },
                    onSaved: (value) {
                      _authData['email'] = value;
                    },
                  ),
                SizedBox(
                  height: 10,
                ),
                if (_authMode == AuthMode.Angestellter)
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        labelText: 'Passwort',
                        labelStyle: TextStyle(color: Colors.blueGrey),
                        hintStyle: TextStyle(color: Colors.blueGrey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xffc9a42c), width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0))),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Passwort ist zu kurz!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                SizedBox(
                  height: 10,
                ),
                if (_isLoading && _authMode == AuthMode.Angestellter)
                  CircularProgressIndicator()
                else if (_authMode == AuthMode.Angestellter)
                  RaisedButton(
                    child: Text('Login'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Color(0xffc9a42c),
                    textColor: Colors.black,
                  ),
                if (!_isLoading)
                  FlatButton(
                    child: Text(
                        '${_authMode == AuthMode.Gast ? 'Angestellte' : 'Gäste'}'),
                    onPressed: _switchAuthMode,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Color(0xffc9a42c),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
