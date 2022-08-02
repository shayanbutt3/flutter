import 'package:auto_size_text/auto_size_text.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:backoffice_new/constants/size_config.dart';

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton(
      {required this.text,
      this.btnTextColor,
      this.btnTextSizeBlock,
      this.btnBackgroundColor,
      this.btnPaddingHorizontalSize,
      this.btnPaddingVerticalSize,
      this.btnRadiusBlockSize,
      this.onPressed,
      Key? key})
      : super(key: key);

// final Function onPressed;
  final VoidCallback? onPressed;
  final String text;
  final Color? btnTextColor;
  final Color? btnBackgroundColor;
  final double? btnTextSizeBlock;
  final double? btnPaddingHorizontalSize;
  final double? btnPaddingVerticalSize;
  final double? btnRadiusBlockSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(btnBackgroundColor ?? Colors.black),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            horizontal: btnPaddingHorizontalSize == null
                ? SizeConfig.safeBlockSizeHorizontal * 8
                : SizeConfig.safeBlockSizeHorizontal * btnPaddingHorizontalSize,
            vertical: btnPaddingVerticalSize == null
                ? SizeConfig.safeBlockSizeVertical * 1.2
                : SizeConfig.safeBlockSizeVertical * btnPaddingVerticalSize,
          )),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(
                  btnRadiusBlockSize == null
                      ? SizeConfig.safeBlockSizeHorizontal * 1
                      : SizeConfig.blockSizeHorizontal * btnRadiusBlockSize)))),
        ),
        onPressed: onPressed,
        child: AutoSizeText(
          text,
          style: TextStyle(
              color: btnTextColor ?? Colors.white,
              fontSize: btnTextSizeBlock == null
                  ? SizeConfig.safeBlockSizeHorizontal * 4
                  : SizeConfig.safeBlockSizeHorizontal * btnTextSizeBlock),
        ));
  }
}

class MySpaceHeight extends StatelessWidget {
  const MySpaceHeight({required this.heightSize, Key? key}) : super(key: key);
  final double heightSize;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(height: SizeConfig.safeBlockSizeVertical * heightSize);
  }
}

class MySpaceWidth extends StatelessWidget {
  const MySpaceWidth({required this.widthSize, Key? key}) : super(key: key);
  final double widthSize;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(width: SizeConfig.safeBlockSizeHorizontal * widthSize);
  }
}

class MySpaceBetweenTitleAndInputField extends StatelessWidget {
  const MySpaceBetweenTitleAndInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      height: SizeConfig.safeBlockSizeVertical,
    );
  }
}

class MySpaceBetweenFormField extends StatelessWidget {
  const MySpaceBetweenFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      height: SizeConfig.safeBlockSizeVertical * 2,
    );
  }
}

class MyLoadingIndicator extends StatelessWidget {
  final bool? centerIt;
  const MyLoadingIndicator({this.centerIt, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return centerIt == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : const CircularProgressIndicator();
  }
}

class ShowOrdersCount extends StatelessWidget {
  final String? text;
  final int? listLength;
  final int? totalElements;
  final Alignment? alignment;

  const ShowOrdersCount(
      {this.text,
      required this.listLength,
      this.totalElements,
      this.alignment,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.centerLeft,
      // padding:
      //     EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 3),
      child: AutoSizeText(
        // '${text == null ? 'Showing' : text}:  ${listLength == null ? '-' : listLength} ${totalElements == null ? '' : 'of'} ${totalElements == null ? '' : totalElements}',
        '${text ?? 'Showing'}:  ${listLength ?? '-'} ${totalElements == null ? '' : 'of'} ${totalElements ?? ''}',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}

class MyNoDataToShowWidget extends StatelessWidget {
  const MyNoDataToShowWidget({this.customTxt, Key? key}) : super(key: key);
  final String? customTxt;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MyTextWidgetNormal(text: customTxt ?? 'No data to show'),
    );
  }
}

class MyNoMoreDataContainer extends StatelessWidget {
  const MyNoMoreDataContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(MyVariables.noMoreDataMSG);
  }
}

class MyListTileBottomSheetMenuItem extends StatelessWidget {
  const MyListTileBottomSheetMenuItem({
    required this.titleTxt,
    required this.icon,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String titleTxt;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: MyColors.bottomSheetIconColor,
      ),
      title: Text(
        titleTxt,
        style: TextStyle(color: MyColors.bottomSheetTextColor),
      ),
      onTap: onTap,
    );
  }
}

class MyDialogContainer extends StatelessWidget {
  const MyDialogContainer({
    required this.listOfItems,
    this.crossAxisAlignment,
    Key? key,
  }) : super(key: key);

  final List<Widget> listOfItems;
  final CrossAxisAlignment? crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Center(
        child: FittedBox(
            child: Container(
      width: SizeConfig.safeBlockSizeHorizontal * 80,
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.blockSizeHorizontal * 2))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment == null
            ? CrossAxisAlignment.start
            : crossAxisAlignment!,
        children: listOfItems,
      ),
    )));
  }
}
