import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class CustomElevatedButton extends StatelessWidget {
  String text;
  IconData? icon;
  double fontSize;
  Color? fontColor;
  double? width;
  double? height;
  final Function()? onPressed;
  BoxBorder? border;
  Color? buttonBackgroundColor;
  SvgPicture? suffixIcon;
  SvgPicture? preffixIcon;

  CustomElevatedButton(
      {super.key,
      required this.text,
      required this.fontSize,
      this.onPressed,
      this.icon,
      this.border,
      this.fontColor,
      this.buttonBackgroundColor,
      this.width,
      this.height,
      this.suffixIcon,
      this.preffixIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(buttonBackgroundColor),
            shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              suffixIcon ?? Container(),
              const SizedBox(width: 4),
              Text(
                text,
                style: TextStyle(
                  color: fontColor,
                  fontSize: fontSize,
                ),
              ),
              const SizedBox(width: 6),
              preffixIcon ?? Container()
            ],
          )),
    );
  }
}
