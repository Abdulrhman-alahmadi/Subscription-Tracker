
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Subscription {
  String _name;
  double _price;
  String _desc;
  DateTime _startDate;
  DateTime _endDate;
  String _img;
  Color _color;

  Map<String, dynamic> toMap() {
    return {
      'name': _name,
      'price': _price,
      'desc': _desc,
      'date' : DateFormat('yyyy-MM-dd').format(_startDate),
      'img': _img,
      'color': '#${color.value.toRadixString(16).substring(2, 8)}',
    };
  }

  Color get color => _color;

  set color(Color value) {
    _color = value;
  }

  String get img => _img;

  set img(String value) {
    _img = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  Subscription(this._name, this._price, this._desc, this._startDate,
      this._endDate, this._img, this._color);

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  String get desc => _desc;

  set desc(String value) {
    _desc = value;
  }

  DateTime get startDate => _startDate;

  set startDate(DateTime value) {
    _startDate = value;
  }

  DateTime get endDate => _endDate;

  set endDate(DateTime value) {
    _endDate = value;
  }
}
