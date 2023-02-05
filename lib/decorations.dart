import 'package:flutter/material.dart';

import 'dimens.dart';

class MyDecorations{
  MyDecorations._();


  static  BoxDecoration mainCardDecoration = BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 18,
                        offset: Offset(3, 3))
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimens.medium));

}