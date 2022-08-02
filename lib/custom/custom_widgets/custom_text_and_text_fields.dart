import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:flutter/services.dart';

class MyTextWidgetNormal extends StatelessWidget {
  const MyTextWidgetNormal({required this.text, Key? key}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AutoSizeText(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: SizeConfig.safeBlockSizeHorizontal * 4,
      ),
    );
  }
}

class MyTextWidgetTitle extends StatelessWidget {
  const MyTextWidgetTitle({required this.text, Key? key}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AutoSizeText(
      text,
      style: const TextStyle(
        color: Colors.black45,
        // fontSize: SizeConfig.safeBlockSizeHorizontal * 2,
      ),
    );
  }
}

class MyTextWidgetHeading extends StatelessWidget {
  const MyTextWidgetHeading({required this.text, this.textAlign, Key? key})
      : super(key: key);
  final String text;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AutoSizeText(text,
        style: TextStyle(
          color: MyColors.headerTextBlueShadeColor,
          fontSize: SizeConfig.safeBlockSizeHorizontal * 5.5,
        ),
        textAlign: textAlign ?? TextAlign.left);
  }
}

class MyTextWidgetCustom extends StatelessWidget {
  const MyTextWidgetCustom(
      {required this.text,
      this.color,
      this.sizeBlockHorizontalDigit,
      this.fontWeight,
      this.maxLines,
      this.textAlign,
      Key? key})
      : super(key: key);

  final String text;
  final Color? color;
  final double? sizeBlockHorizontalDigit;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AutoSizeText(
      text,
      style: TextStyle(
        color: color ?? Colors.black,
        fontSize: sizeBlockHorizontalDigit == null
            ? SizeConfig.safeBlockSizeHorizontal * 4
            : SizeConfig.safeBlockSizeHorizontal * sizeBlockHorizontalDigit,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class MyTextWidgetAppBarTitle extends StatelessWidget {
  const MyTextWidgetAppBarTitle(
      {required this.text,
      this.color,
      this.sizeBlockHorizontalDigit,
      this.fontWeight,
      Key? key})
      : super(key: key);

  final String text;
  final Color? color;
  final double? sizeBlockHorizontalDigit;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AutoSizeText(
      text,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: sizeBlockHorizontalDigit == null
            ? SizeConfig.safeBlockSizeHorizontal * 5
            : SizeConfig.safeBlockSizeHorizontal * sizeBlockHorizontalDigit,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}

class MyAppBarFlexibleContainer extends StatelessWidget {
  const MyAppBarFlexibleContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.safeScreenWidth,
      height: MyVariables.appbarHeight,
      color: MyVariables.appBarFlexibleConatinerColor,
    );
  }
}

class MyTextFieldCustom extends StatelessWidget {
  const MyTextFieldCustom(
      {required this.controller,
      this.hintText,
      this.labelText,
      this.needValidator,
      this.validatorText,
      this.onChanged,
      this.needToHideIcon,
      this.icon,
      this.iconCustomColor,
      this.needToDisableField,
      this.textInputType,
      this.inputFormatters,
      this.maxlength,
      this.counterText,
      Key? key})
      : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final bool? needValidator;
  final String? validatorText;
  final bool? needToHideIcon;
  final IconData? icon;
  final Color? iconCustomColor;
  final bool? needToDisableField;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxlength;
  final String? counterText;

  final Function(String a)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxlength,
      controller: controller,
      enabled: needToDisableField == true ? false : true,
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        counterText: counterText,
        hintText: hintText,
        labelText: labelText,
        hintStyle: TextStyle(color: MyColors.tetxFieldIconsColor),
        border: MyVariables.textFormFieldBorder,
        fillColor: needToDisableField == true
            ? MyColors.textFieldFillColor
            : Colors.transparent,
        filled: needToDisableField == true ? true : false,
        suffixIcon: needToHideIcon == true
            ? null
            : Icon(
                icon ?? Icons.email,
                color: MyColors.tetxFieldIconsColor,
              ),
      ),
      validator: needValidator == true
          ? (text) {
              if (text == null || text.trim().isEmpty) {
                return validatorText ?? "Field is required";
              }
            }
          : null,
      onChanged: onChanged ?? (a) {},
    );
  }
}

class MyTextFieldEmail extends StatelessWidget {
  const MyTextFieldEmail({required this.controller, this.onChanged, Key? key})
      : super(key: key);
  final TextEditingController controller;
  final void Function(String e)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: MyColors.tetxFieldIconsColor),
        border: MyVariables.textFormFieldBorder,
        suffixIcon: Icon(
          Icons.email,
          color: MyColors.tetxFieldIconsColor,
        ),
      ),
      validator: (text) {
        if (text == null || text.trim().isEmpty) {
          return "Email is required";
        }
      },
      onChanged: onChanged ?? (a) {},
    );
  }
}

class MyTextFieldPassword extends StatelessWidget {
  const MyTextFieldPassword(
      {required this.controller,
      this.onChanged,
      required this.obsecureText,
      required this.iconButtonOnPressed,
      Key? key})
      : super(key: key);

  final TextEditingController controller;
  final bool obsecureText;
  final void Function(String s)? onChanged;
  final Function() iconButtonOnPressed;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecureText,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: MyColors.tetxFieldIconsColor),
        border: MyVariables.textFormFieldBorder,
        suffixIcon: IconButton(
          icon: Icon(obsecureText ? Icons.visibility_off : Icons.visibility),
          color: MyColors.tetxFieldIconsColor,
          onPressed: iconButtonOnPressed,
        ),
      ),
      validator: (text) {
        if (text == null || text.trim().isEmpty) {
          return "Password is required";
        }
      },
      onChanged: onChanged ?? (t) {},
    );
  }
}

class MyTextFieldDatePicker extends StatelessWidget {
  const MyTextFieldDatePicker(
      {required this.text,
      required this.controller,
      this.onChanged,
      required this.iconButtonOnPressed,
      Key? key})
      : super(key: key);

  final String text;
  final TextEditingController controller;
  final void Function(String s)? onChanged;
  final Function() iconButtonOnPressed;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: '2021/09/17',
        hintStyle: TextStyle(color: MyColors.tetxFieldIconsColor),
        labelText: text,
        labelStyle: TextStyle(color: MyColors.tetxFieldIconsColor),
        border: MyVariables.textFormFieldBorder,
        suffixIcon: IconButton(
          icon: const Icon(Icons.date_range_outlined),
          color: Colors.blue,
          onPressed: iconButtonOnPressed,
        ),
      ),
      validator: (text) {
        if (text == null || text.trim().isEmpty) {
          return "Date is required";
        }
      },
      onChanged: onChanged ?? (t) {},
    );
  }
}

class MyTitleValueColumn extends StatelessWidget {
  const MyTitleValueColumn(
      {required this.title,
      required this.value,
      this.titleColor,
      this.valueColor,
      Key? key})
      : super(key: key);

  final String title;
  final String value;
  final Color? titleColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextWidgetCustom(
          text: title,
          color: titleColor ?? Colors.green,
          sizeBlockHorizontalDigit: 3,
        ),
        const MySpaceHeight(heightSize: 0.3),
        MyTextWidgetCustom(
          text: value,
          color: valueColor ?? Colors.black,
          sizeBlockHorizontalDigit: 4,
        ),
      ],
    );
  }
}

class MyTitleValueRow extends StatelessWidget {
  const MyTitleValueRow(
      {required this.title,
      required this.value,
      this.titleColor,
      this.valueColor,
      Key? key})
      : super(key: key);

  final String title;
  final String value;
  final Color? titleColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextWidgetCustom(
            text: title,
            color: titleColor ?? Colors.black45,
            sizeBlockHorizontalDigit: 3,
          ),
          const MySpaceWidth(widthSize: 2),
          MyTextWidgetCustom(
            text: value,
            color: valueColor ?? Colors.black,
            sizeBlockHorizontalDigit: 4,
          ),
        ],
      ),
    );
  }
}
