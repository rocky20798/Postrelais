import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lann/shop/providers/product.dart';
import 'package:flutter_lann/shop/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditCathegoryScreen extends StatefulWidget {
  static const routeName = '/edit-cathegory';

  @override
  _EditCathegoryScreenState createState() => _EditCathegoryScreenState();
}

class _EditCathegoryScreenState extends State<EditCathegoryScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedCathegory = Cathegory(
    id: null,
    title: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final cathegoryId = ModalRoute.of(context).settings.arguments as String;
      if (cathegoryId != null) {
        _editedCathegory =
            Provider.of<Cathegorys>(context, listen: false).findById(cathegoryId);
        _initValues = {
          'title': _editedCathegory.title,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedCathegory.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedCathegory.id != null) {
      await Provider.of<Cathegorys>(context, listen: false)
          .updateCathegory(_editedCathegory.id, _editedCathegory);
    } else {
      try {
        await Provider.of<Cathegorys>(context, listen: false)
            .addCathegory(_editedCathegory);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title:
                Text('An error occurred!', style: TextStyle(color: Colors.red)),
            content: Text('Something went wrong.',
                style: TextStyle(color: Colors.red)),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: Text('Okay', style: TextStyle(color: Colors.green)),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategorie bearbeiten'),
        backgroundColor: Color(0xff262f38),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      initialValue: _initValues['title'],
                      maxLines: 2,
                      decoration: InputDecoration(
                          labelText: 'Titel',
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(color: Color(0xffc9a42c))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(color: Colors.white))),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCathegory = Cathegory(
                            title: value,
                            imageUrl: _editedCathegory.imageUrl,
                            id: _editedCathegory.id,);
                      },
                    ),
                    SizedBox(height: 20),
                    ImageUploadWidget(),
                  ],
                ),
              ),
            ),
    );
  }

  var currentSelectedValue;

  //Image Upload
  var _image;
  bool isLoading = false;
  Reference ref = FirebaseStorage.instance.ref();

  Widget ImageUploadWidget() {
    return Column(
      children: [
        ElevatedButton(
            child: Text("Change Image"),
            onPressed: () async {
              await getImage();
              if (_image != null) {
                setState(() {
                  isLoading = true;
                });
                TaskSnapshot addImg = await ref
                    .child("image/${_editedCathegory.title}")
                    .putFile(_image);
                if (addImg.state == TaskState.success) {
                  _editedCathegory = Cathegory(
                      title: _editedCathegory.title,
                      imageUrl: await ref
                          .child("image/${_editedCathegory.title}")
                          .getDownloadURL(),
                      id: _editedCathegory.id);
                  setState(() {
                    isLoading = false;
                  });
                  print("added to Firebase Storage");
                }
              }
            }),
        isLoading
            ? CircularProgressIndicator()
            : _editedCathegory.imageUrl == null
                ? Text(
                    'No image selected.',
                    style: TextStyle(color: Colors.white),
                  )
                : Image.network(
                    _editedCathegory.imageUrl,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
      ],
    );
  }

  Future getImage() async {
    final _picker = ImagePicker();
    var image = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
  }
}
