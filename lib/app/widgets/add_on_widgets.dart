import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:testapp/app/widgets/text_style.dart';

enum SpinkitType {
  circle,
  fadingCube,
  wave,
  fadingGrid,
  chasingDots,
  pulse,
  dualRing,
  squareCircle,
  rotatingPlain,
  fadingFour,
  threeBounce,
  cubeGrid,
}

Widget customSpinkitLoaderWithType({
  required BuildContext context,
  SpinkitType type = SpinkitType.circle,
  Color color = Colors.blue,
  double size = 50.0,
}) {
  switch (type) {
    case SpinkitType.fadingCube:
      return SpinKitFadingCube(color: color, size: size);
    case SpinkitType.wave:
      return SpinKitWave(color: color, size: size);
    case SpinkitType.fadingGrid:
      return SpinKitFadingGrid(color: color, size: size);
    case SpinkitType.chasingDots:
      return SpinKitChasingDots(color: color, size: size);
    case SpinkitType.pulse:
      return SpinKitPulse(color: color, size: size);
    case SpinkitType.dualRing:
      return SpinKitDualRing(color: color, size: size);
    case SpinkitType.squareCircle:
      return SpinKitSquareCircle(color: color, size: size);
    case SpinkitType.rotatingPlain:
      return SpinKitRotatingPlain(color: color, size: size);
    case SpinkitType.fadingFour:
      return SpinKitFadingFour(color: color, size: size);
    case SpinkitType.threeBounce:
      return SpinKitThreeBounce(color: color, size: size);
    case SpinkitType.cubeGrid:
      return SpinKitCubeGrid(color: color, size: size);
    default:
      return SpinKitCircle(color: color, size: size);
  }
}

buildLoadingIndicator({
  required BuildContext context,
  SpinkitType type = SpinkitType.threeBounce,
  Color color = const Color(0xFF15384E),
  double size = 20.0,
}) {
  return Center(
    child: customSpinkitLoaderWithType(
      context: context,
      type: type,
      color: color,
      size: size,
    ),
  );
}

buildEmptyStateWidget({
  required String message,
  String? subMessage,
  String? imagePath,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
            imagePath ?? 'assets/animations/Animation - 1735364832916.json'),
        Text(message, style: AppTextStyles.bodyText.copyWith(fontSize: 14)),
        if (subMessage != null)
          Text(subMessage,
              style: AppTextStyles.bodyText.copyWith(fontSize: 14)),
      ],
    ),
  );
}

TextStyle headerStyling({
  String fontFamily = 'Montserrat',
  double fontSize = 20.0,
  FontWeight fontWeight = FontWeight.normal,
  Color color = const Color(0xFF000000),
  FontStyle fontStyle = FontStyle.normal,
  double letterSpacing = 0.0,
  double wordSpacing = 0.0,
  TextDecoration decoration = TextDecoration.none,
}) {
  return GoogleFonts.getFont(fontFamily).copyWith(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    decoration: decoration,
  );
}

TextStyle subHeaderStyling({
  String fontFamily = 'Poppins-SemiBold',
  double fontSize = 16.0,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.grey,
  FontStyle fontStyle = FontStyle.normal,
  double letterSpacing = 0.0,
  double wordSpacing = 0.0,
  TextDecoration decoration = TextDecoration.none,
}) {
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    decoration: decoration,
  );
}

TextStyle styling({
  String fontFamily = 'Poppins',
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.normal,
  Color? color = const Color(0xFF000000),
  FontStyle fontStyle = FontStyle.normal,
  double letterSpacing = 0.0,
  double wordSpacing = 0.0,
  TextDecoration decoration = TextDecoration.none,
  double? height,
}) {
  return GoogleFonts.getFont(fontFamily).copyWith(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    decoration: decoration,
  );
}
