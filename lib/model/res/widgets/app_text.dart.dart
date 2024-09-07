
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../constant.dart';
import '../../../provider/theme/theme_provider.dart';
import '../components/responsive.dart';
import '../constant/app_colors.dart';

class AppTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final int maxLines;
  final FontWeight fontWeight;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final bool softWrap;
  final Color color;
  final Color underlinecolor;
  final TextDecoration textDecoration;
  const AppTextWidget({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.normal,
    this.color = AppColors.appBlackColor,
    this.textAlign = TextAlign.center,
    this.textDecoration = TextDecoration.none,
    this.fontSize = 12,
    this.softWrap = true,
     this.maxLines  = 2,  this.underlinecolor = primaryColor,  this.overflow = TextOverflow.clip,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDarkMode = Provider.of<ThemeLanguageProvider>(context).isDarkMode;
    return AutoSizeText(
      maxFontSize: isMobile ?8: isTablet? 10: fontSize,
      minFontSize: 4.0,
      //AppLocalizations.of(context)?.translate(text) ?? text,
      text,
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      style: GoogleFonts.poppins(
        decoration: textDecoration,
          decorationColor: underlinecolor,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: isDarkMode ? Colors.white : color,
      ),
    );
  }
}
class AppTextWidgetNunito extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final bool softWrap;
  final Color color;
  final TextDecoration textDecoration;
  const AppTextWidgetNunito({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.normal,
    this.color = AppColors.appBlackColor,
    this.textAlign = TextAlign.center,
    this.textDecoration = TextDecoration.none,
    this.fontSize = 12,
    this.softWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeLanguageProvider>(context).isDarkMode;
    return AutoSizeText(
      maxFontSize: fontSize,
      minFontSize: 8.0,
      //AppLocalizations.of(context)?.translate(text) ?? text,
      text,
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.nunitoSans(
        decoration: textDecoration,
          decorationColor: AppColors.appWhiteColor,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: isDarkMode ? Colors.white : color,
      ),
    );
  }
}
class AppTextWidgetFira extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final bool softWrap;
  final Color color;
  final TextDecoration textDecoration;
  const AppTextWidgetFira({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.normal,
    this.color = AppColors.appBlackColor,
    this.textAlign = TextAlign.center,
    this.textDecoration = TextDecoration.none,
    this.fontSize = 12,
    this.softWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeLanguageProvider>(context).isDarkMode;
    return AutoSizeText(
      maxFontSize: fontSize,
      minFontSize: 8.0,
      //AppLocalizations.of(context)?.translate(text) ?? text,
      text,
      textAlign: textAlign,
      softWrap: softWrap,
      style: GoogleFonts.firaSans(
        decoration: textDecoration,
          decorationColor: AppColors.appWhiteColor,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: isDarkMode ? Colors.white : color,
      ),
    );
  }
}
