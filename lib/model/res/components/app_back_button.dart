import 'package:flutter/material.dart';

import '../../../constant.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> Navigator.pop(context),
      child: Container(
        width: 35.0,
        height: 35.0,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Center(child: Icon(Icons.arrow_back_ios_new,color: Colors.white,size: 15.0,)),
      ),
    );
  }
}
