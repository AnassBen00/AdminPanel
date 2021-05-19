import 'package:flutter/material.dart';
import 'package:adminpaneltechshopp/utils/splash.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../db/sales.dart';

class EditSale extends StatefulWidget {
  final id;
  final uid;
  final couleur;
  final quantite;
  final montant;
  final nomProd;

  const EditSale({Key key, this.id, this.uid, this.couleur, this.quantite, this.montant, this.nomProd}) : super(key: key);
  @override
  _EditSaleState createState() => _EditSaleState();
}

class _EditSaleState extends State<EditSale> {
  SaleService saleService = SaleService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController IdCarte = TextEditingController();
  TextEditingController IdUtilisateur = TextEditingController();
  TextEditingController prodName = TextEditingController();
  TextEditingController color = TextEditingController();
  final priceController = TextEditingController();
  final quantiteController = TextEditingController();
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  bool isLoading = false;
  String _date = "Non défini";
  String _time = "Non défini";
  @override
  void initState() {

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
          "Modifier Commande",
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

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(hintText: '${widget.uid}'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: prodName,
                  decoration: InputDecoration(hintText: '${widget.nomProd}'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Vous devez entrer le nom de produit';
                    }
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: '${widget.montant}'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Vous devez entrer le montant';
                    }
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: quantiteController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: '${widget.quantite}'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Vous devez entrer la quantité';
                    }
                  },
                ),
              ),

              Container(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: color,
                    decoration: InputDecoration(
                      hintText: '${widget.couleur}',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '';
                      }
                    },
                  ),
                ),
              ),

        RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)),
          elevation: 4.0,
          onPressed: () {
            DatePicker.showDatePicker(context,
                theme: DatePickerTheme(
                  containerHeight: 210.0,
                ),
                showTitleActions: true,
                minTime: DateTime(2000, 01, 01),
                maxTime: DateTime(2021, 12, 31), onConfirm: (date) {
                  print('confirm $date');
                  _date = '${date.year}-0${date.month}-${date.day}';
                  setState(() {});
                }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
          child: Container(
            alignment: Alignment.center,
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.date_range,
                            size: 18.0,
                            color: Colors.black,
                          ),
                          Text(
                            " $_date",
                            style: TextStyle(
                                color: Colors.black,
                               ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Text(
                  "  Changer",
                  style: TextStyle(
                      color: Colors.black,
                     ),
                ),
              ],
            ),
          ),
          color: Colors.white,
        ),

              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true, onConfirm: (time) {
                        print('confirm $time');
                        _time = '${time.hour}:${time.minute}:${time.second}';
                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  color: Colors.black,
                                ),
                                Text(
                                  " $_time",
                                  style: TextStyle(
                                      color: Colors.black,
                                      ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Changer",
                        style: TextStyle(
                            color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),

              FlatButton(
                color: red,
                textColor: white,
                child: Text('Confirmer'),
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

  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      //print("--------------------------here");
      setState(() => isLoading = true);
     String dt = "${_date.toString()} ${_time.toString()}";
      saleService.updateSale(uid: widget.uid, nomP: prodName.text, color: color.text, montant: int.parse(priceController.text), date: dt, quantity: int.parse(quantiteController.text), id: widget.id);
      _formKey.currentState.reset();
      setState(() => isLoading = false);

      Navigator.pop(context);
    }
  }
}

