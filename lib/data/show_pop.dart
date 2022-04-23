import 'package:flutter/cupertino.dart';

class ShowPop {
  var _isShow = false;

  bool get getShow {
    return _isShow;
  }

  void IsShow() {
    _isShow = !_isShow;
  }
}
