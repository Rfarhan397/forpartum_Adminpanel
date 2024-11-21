import 'package:flutter/material.dart';

import '../../../constant.dart';
import '../constant/app_colors.dart';
import '../widgets/app_text.dart.dart';

class AppButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final double height,width;
  final FontWeight fontWeight;
  final Alignment alignment ;
  final String text;
  final Color? buttonColor, textColor;
  final double? radius, fontSize;
  final bool loader;

  const AppButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    this.buttonColor,
    this.radius,
    this.loader = false,
    this.textColor,
    this.fontSize,
    this.height = 40,
    this.width = 150,
     this.fontWeight = FontWeight.w400,
    this.alignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap : onPressed,
      child: Align(
        alignment: alignment ,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius?? 0),
            color: primaryColor ,
          ),
          child: (loader)
              ? const CircularProgressIndicator(
                  color: AppColors.appBackgroundColor,
                )
              : Center(
                child: AppTextWidget(
                    text: text,
                    fontSize: fontSize ?? 14,
                    fontWeight: fontWeight,
                    color: textColor ?? AppColors.appWhiteColor,
                  ),
              ),
        ),
      ),
    );
  }
}
