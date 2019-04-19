import 'package:flutter/material.dart';
import '../widgets/helpers/ensure-visible.dart';

class ProductEditPage extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final Map<String, dynamic> product;
  final int productIndex;

  ProductEditPage(
      {this.addProduct, this.updateProduct, this.product, this.productIndex});

  @override
  State createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg'
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  Widget _buildTitleTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        focusNode: _titleFocusNode,
        decoration: InputDecoration(
          labelText: 'Product title',
        ),
        initialValue: widget.product == null ? '' : widget.product['title'],
        // show error at once
//      autovalidate: true,
        validator: (String value) {
//        if (value.trim().length <= 0) {
          if (value.isEmpty || value.length <= 4) {
            return 'Title is required and should be 5+ characters long';
          }
        },
        onSaved: (String value) {
          this._formData['title'] = value;
        },
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
      decoration: InputDecoration(
        labelText: 'Product description',
      ),
      initialValue: widget.product == null ? '' : widget.product['description'],
      validator: (String value) {
        if (value.isEmpty || value.length <= 9) {
          return 'Description is required and should be 10+ characters long';
        }
      },
      maxLines: 4,
      onSaved: (String value) {
        this._formData['description'] = value;
      },
    ),
    );
  }

  Widget _buildPriceTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        focusNode: _priceFocusNode,
      decoration: InputDecoration(
        labelText: 'Product price',
      ),
      initialValue:
      widget.product == null ? '' : widget.product['price'].toString(),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$'
            ).hasMatch(value
            )) {
          return 'Price is required and should be number';
        }
      },
      onSaved: (String value) {
        this._formData['price'] =
            double.parse(value.replaceFirst(RegExp(r','
            ), '.'
            )
            );
      },
    ),);
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (widget.product == null) {
      widget.addProduct(_formData
      );
    } else {
      widget.updateProduct(widget.productIndex, _formData
      );
    }

    Navigator.pushReplacementNamed(context, '/products'
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery
        .of(context
    )
        .size
        .width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    final Widget pageContent = Container(
        width: targetWidth,
        margin: EdgeInsets.all(10.0
        ),
        child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: targetPadding / 2
              ),
              children: <Widget>[
                _buildTitleTextField(),
                _buildDescriptionTextField(),
                _buildPriceTextField(),
                // occupied some space ~ height & width
                SizedBox(
                  height: 10.0,
                ),
                RaisedButton(
                    child: Text('Save'
                    ),
                    // without ()  = call on pressed
                    onPressed: _submitForm
                ),
                //            GestureDetector(
                //              child:  Container(
                //                color: Colors.green,
                //                child: Text('custom button'),
                //              ),
                //              onTap: _submitForm,
                //            )
              ],
            )
        )
    );

    return widget.product == null
        ? pageContent
        : Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'
        ),
      ),
      body: pageContent,
    );
  }
}
