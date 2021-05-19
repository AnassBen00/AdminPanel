
import 'dart:io';

import 'package:adminpaneltechshopp/db/brands.dart';
import 'package:adminpaneltechshopp/db/categories.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:adminpaneltechshopp/db/product.dart';
import 'package:adminpaneltechshopp/utils/splash.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService productService = ProductService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  final priceController = TextEditingController();
  List<DocumentSnapshot> listbrands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;
  String _currentBrand;
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  List<String> selectedSizes = <String>[];
  File _image1;
  bool isLoading = false;

  @override
  void initState() {
    _getCategories();
    _getBrands();
  }

  List<DropdownMenuItem<String>> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(categories[i].data['nom']),
                value: categories[i].data['nom']));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getBrandosDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < listbrands.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(listbrands[i].data['nom']),
                value: listbrands[i].data['nom']));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: IconButton(
          onPressed:() => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close,
            color: black,
          ),
        ),
        title: Text(
          "Ajouter produit",
          style: TextStyle(color: black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: isLoading
              ? Splash()
              : Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlineButton(
                                borderSide: BorderSide(
                                    color: grey.withOpacity(0.5), width: 2.5),
                                onPressed: () {
                                  _selectImage(
                                      ImagePicker.pickImage(
                                          source: ImageSource.gallery),
                                      1);
                                },
                                child: _displayChild1()),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'entrez un nom de produit avec 50 caractères au maximum',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: red, fontSize: 12),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: productNameController,
                        decoration: InputDecoration(hintText: 'nom du produit'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Vous devez saisir le nom du produit';
                          } else if (value.length > 50) {
                            return 'Le nom du produit ne peut pas contenir plus de 50 lettres';
                          }
                        },
                      ),
                    ),

                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          controller: DescriptionController,
                          decoration: InputDecoration(
                            hintText: 'Description',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Vous devez saisir la description du produit';
                            }
                          },
                        ),
                      ),
                    ),

//              select category
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Catégorie: ',
                            style: TextStyle(color: red),
                          ),
                        ),
                        DropdownButton(
                          items: categoriesDropDown,
                          onChanged: changeSelectedCategory,
                          value: _currentCategory,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Marque: ',
                            style: TextStyle(color: red),
                          ),
                        ),
                        DropdownButton(
                          items: brandsDropDown,
                          onChanged: changeSelectedBrand,
                          value: _currentBrand,
                        ),
                      ],
                    ),


                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Prix',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Vous devez saisir le prix du produit';
                          }
                        },
                      ),
                    ),

                    Row(
                      children: <Widget>[
                        Checkbox(value: selectedSizes.contains('Noire'), onChanged: (value) => changeSelectedSize('Noire')),
                        Text('Noire'),

                        Checkbox(value: selectedSizes.contains('Gris'), onChanged: (value) => changeSelectedSize('Gris')),
                        Text('Gris'),

                        Checkbox(value: selectedSizes.contains('Blanc'), onChanged: (value) => changeSelectedSize('Blanc')),
                        Text('Blanc'),

                        Checkbox(value: selectedSizes.contains('Gold'), onChanged: (value) => changeSelectedSize('Gold')),
                        Text('Gold'),

                        Checkbox(value: selectedSizes.contains('rouge'), onChanged: (value) => changeSelectedSize('rouge')),
                        Text('rouge'),

                      ],
                    ),

                    FlatButton(
                      color: red,
                      textColor: white,
                      child: Text('Ajouter le produit'),
                      onPressed: () {
                        validateAndUpload();
                      },
                    )
                  ],
                ),
        ),
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    print(data.length);
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropdown();
      _currentCategory = categories[0].data['nom'];
    });
  }

  _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getbrand();
    print(data.length);
    setState(() {
      listbrands = data;
      brandsDropDown = getBrandosDropDown();
      _currentBrand = listbrands[0].data['nom'];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  changeSelectedBrand(String selectedBrand) {
    setState(() => _currentBrand = selectedBrand);
  }

  void changeSelectedSize(String color) {
    if(selectedSizes.contains(color)){
      setState(() {
        selectedSizes.remove(color);
      });
    }else{
      setState(() {
        selectedSizes.insert(0, color);
      });
    }
  }


  void _selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
    switch (imageNumber) {
      case 1:
        setState(() => _image1 = tempImg);
        break;
    }
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image1,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      if (_image1 != null ) {
        if (selectedSizes.isNotEmpty) {
          String imageUrl1;

          final FirebaseStorage storage = FirebaseStorage.instance;
          final String picture1 =
              "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task1 =
              storage.ref().child(picture1).putFile(_image1);


          StorageTaskSnapshot snapshot1 =
              await task1.onComplete.then((snapshot) => snapshot);

          task1.onComplete.then((snapshot) async {
            imageUrl1 = await snapshot1.ref.getDownloadURL();


            productService.uploadProduct({
              "nom":productNameController.text,
              "description": DescriptionController.text,
              "prix":priceController.text.toString(),
              "couleurs":selectedSizes,
              "image":imageUrl1,
              "marque":_currentBrand,
              "catégorie":_currentCategory,
              "dateCreation": DateTime.now() ,
            });
            _formKey.currentState.reset();
            setState(() => isLoading = false);
//            Fluttertoast.showToast(msg: 'Product added');
            Navigator.pop(context);
          });
        } else {
          setState(() => isLoading = false);

//          Fluttertoast.showToast(msg: 'select atleast one size');
        }
      } else {
        setState(() => isLoading = false);

//        Fluttertoast.showToast(msg: 'all the images must be provided');
      }
    }
  }
}

