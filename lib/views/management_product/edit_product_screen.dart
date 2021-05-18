import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/models/products.dart';
import '/viewmodel/product_viewmodel.dart';

class EditProduct extends StatefulWidget {
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final ProductViewModel productViewModel = Get.find();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _fromFocusNode = FocusNode();
  final _controllerImage = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isLoading = false;
  var _editProduct = ProductModel(
    id: null,
    title: '',
    description: '',
    from: '',
    price: 0,
    imageUrl: '',
  );
  var _initValue = {
    //bien khoi tao value
    'title': '',
    'id': '',
    'from': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      var productId = Get.arguments;
      print(productId);
      if (productId != null) {
        _editProduct = productViewModel.findById(productId);
        _initValue = {
          'title': _editProduct.title,
          'id': _editProduct.id,
          'from': _editProduct.from,
          'price': _editProduct.price.toString(),
          'description': _editProduct.description,
          'imageUrl': '',
        };
        _controllerImage.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _fromFocusNode.dispose();
    _controllerImage.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _saveFrom() async {
    final inValid = _form.currentState.validate();
    if (!inValid) {
      print('co loi');
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editProduct.id != null) {
      print('update');
      await productViewModel.updateProduct(_editProduct.id, _editProduct);
      setState(() {
        _isLoading = false;
      });
      Get.back();
    } else if (_editProduct.id == null) {
      print('add new');
      print(_editProduct.title);
      print(_editProduct.price);
      print(_editProduct.description);
      await productViewModel.addNewProduct(_editProduct);
      setState(() {
        _isLoading = false;
      });
      Get.back();
      // await Provider.of<Products>(context, listen: false).addProducts(_editProduct).then((_){
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pushReplacementNamed(ProductManagerScreen.routeName);
      // });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15)),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Your Products',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15)),
              child: IconButton(icon: Icon(Icons.add), onPressed: _saveFrom),
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: ListView(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: TextFormField(
                      initialValue: _initValue['title'],
                      decoration: InputDecoration(labelText: 'title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editProduct = ProductModel(
                          id: _editProduct.id,
                          title: value,
                          from: _editProduct.from,
                          description: _editProduct.description,
                          price: _editProduct.price,
                          imageUrl: _editProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: TextFormField(
                      initialValue: _initValue['from'],
                      decoration: InputDecoration(labelText: 'from'),
                      textInputAction: TextInputAction.next,
                      focusNode: _fromFocusNode,
                      onSaved: (value) {
                        _editProduct = ProductModel(
                          id: _editProduct.id,
                          title: _editProduct.title,
                          from: value,
                          description: _editProduct.description,
                          price: _editProduct.price,
                          imageUrl: _editProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Where is It from ?';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: TextFormField(
                      initialValue: _initValue['price'],
                      decoration: InputDecoration(labelText: 'price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onSaved: (value) {
                        _editProduct = ProductModel(
                          id: _editProduct.id,
                          title: _editProduct.title,
                          from: _editProduct.from,
                          description: _editProduct.description,
                          price: double.parse(value),
                          imageUrl: _editProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: TextFormField(
                      initialValue: _initValue['description'],
                      decoration: InputDecoration(labelText: 'description'),
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      maxLines: 3,
                      onSaved: (value) {
                        _editProduct = ProductModel(
                          id: _editProduct.id,
                          title: _editProduct.title,
                          from: _editProduct.from,
                          description: value,
                          price: _editProduct.price,
                          imageUrl: _editProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Have no description';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          child: _controllerImage.text.isEmpty
                              ? Text('No Image')
                              : Image.network(_controllerImage.text),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'imageUrl'),
                            textInputAction: TextInputAction.done,
                            controller: _controllerImage,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveFrom();
                            },
                            onSaved: (value) {
                              _editProduct = ProductModel(
                                id: _editProduct.id,
                                title: _editProduct.title,
                                from: _editProduct.from,
                                description: _editProduct.description,
                                price: _editProduct.price,
                                imageUrl: value,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a image-url';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
