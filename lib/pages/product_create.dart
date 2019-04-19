import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  State createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String _titleValue;
  String _descriptionValue;
  double _priceValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Product title',
      ),
      onSaved: (String value) {
        setState(() {
          this._titleValue = value;
        });
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Product description',
      ),
      maxLines: 4,
      onSaved: (String value) {
        setState(() {
          this._descriptionValue = value;
        });
      },
    );
  }

  Widget _buildPriceTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Product price',
      ),
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        setState(() {
          this._priceValue = double.parse(value);
        });
      },
    );
  }

  void _submitForm() {
    _formKey.currentState.save();
    final Map<String, dynamic> product = {
      'title': this._titleValue,
      'description': this._descriptionValue,
      'price': this._priceValue,
      'image': 'assets/food.jpg'
    };
    widget.addProduct(product);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return Container(
        width: targetWidth,
        margin: EdgeInsets.all(10.0),
        child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
              children: <Widget>[
                _buildTitleTextField(),
                _buildDescriptionTextField(),
                _buildPriceTextField(),
                // occupied some space ~ height & width
                SizedBox(
                  height: 10.0,
                ),
                RaisedButton(
                    child: Text('Save'),
                    // without ()  = call on pressed
                    onPressed: _submitForm),
    //            GestureDetector(
    //              child:  Container(
    //                color: Colors.green,
    //                child: Text('custom button'),
    //              ),
    //              onTap: _submitForm,
    //            )
              ],
        )));
  }
}
