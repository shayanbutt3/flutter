import 'package:auto_size_text/auto_size_text.dart';
import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/user_menu_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_post_data.dart';
import 'package:backoffice_new/views/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({required this.data, Key? key}) : super(key: key);

  final EmployeeProfileDataDist? data;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ApiPostData apiPostData = ApiPostData();
  String appVersion = '';

  final MenuController menuController = Get.find<MenuController>();

  getAppVersion() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
    });
  }

  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var appBar = PreferredSize(
      preferredSize: MyVariables.preferredSizeAppBar,
      child: SafeArea(
          child: AppBar(
        toolbarHeight: MyVariables.appbarHeight,
        backgroundColor: MyVariables.appBarBackgroundColor,
        elevation: 0,
        iconTheme: MyVariables.appBarIconTheme,
        flexibleSpace: const MyAppBarFlexibleContainer(),
        title: const MyTextWidgetAppBarTitle(text: 'Profile'),
      )),
    );

    var mySpaceBetweenListTiles = const MySpaceHeight(heightSize: 1.5);
    var profileContainer = Container(
      width: SizeConfig.safeScreenWidth,
      padding: EdgeInsets.all(SizeConfig.safeBlockSizeHorizontal * 4),
      child: Column(
        children: [
          MyListTileWidget(
            icon: Icons.person,
            title: 'Full Name',
            value: widget.data?.firstName ?? '',
          ),
          mySpaceBetweenListTiles,
          MyListTileWidget(
            icon: Icons.email,
            title: 'Email',
            value: widget.data?.email1 ?? '',
            valueColorCustom: Colors.blue,
          ),
          mySpaceBetweenListTiles,
          MyListTileWidget(
            icon: Icons.phone,
            title: 'Phone',
            value: widget.data?.phone1 == null
                ? widget.data?.phone2 ?? ''
                : widget.data!.phone1 ?? '',
          ),
          mySpaceBetweenListTiles,
          MyListTileWidget(
            icon: Icons.verified_sharp,
            title: 'Version',
            value: appVersion,
            valueColorCustom: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );

    var signOutBtn = MyElevatedButton(
      text: 'Sign Out',
      btnBackgroundColor: MyColors.btnColorGreen,
      btnTextSizeBlock: 5,
      btnPaddingHorizontalSize: 10,
      onPressed: () async {
        myShowLoadingDialog(context);
        apiPostData.logout().then((value) async {
          if (value != null) {
            Get.isDialogOpen! ? tryToPop(context) : null;

            SharedPreferences lc = await SharedPreferences.getInstance();
            lc.remove('jwtToken');
            lc.clear();
            menuController.menuList.value = [];
            myToastSuccess('Logged out successfully');
            Get.offAll(() => const Login());
          } else {}
        });
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.scaffoldBackgroundColor,
      appBar: appBar,
      body: Container(
        width: SizeConfig.safeScreenWidth,
        height: SizeConfig.safeScreenHeight,
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const MySpaceHeight(heightSize: 16),
            CircleAvatar(
              radius: SizeConfig.safeBlockSizeHorizontal * 8,
              backgroundColor: Colors.black,
              child: AutoSizeText(
                widget.data?.firstName == null
                    ? 'P'
                    : widget.data!.firstName![0],
                style:
                    TextStyle(fontSize: SizeConfig.safeBlockSizeHorizontal * 8),
              ),
            ),
            const MySpaceHeight(heightSize: 5),
            profileContainer,
            const MySpaceHeight(heightSize: 5),
            signOutBtn,
          ],
        ),
      ),
    );
  }
}

class MyListTileWidget extends StatelessWidget {
  const MyListTileWidget({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColorCustom,
    this.fontWeight,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String value;
  final Color? valueColorCustom;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        leading: Icon(
          icon,
          size: SizeConfig.safeBlockSizeHorizontal * 8,
          color: Colors.black54,
        ),
        title: MyTextWidgetCustom(
          text: title,
          sizeBlockHorizontalDigit: 2,
          color: Colors.black54,
        ),
        subtitle: MyTextWidgetCustom(
          text: value,
          color: valueColorCustom ?? Colors.black,
          fontWeight: fontWeight ?? FontWeight.normal,
        ));
  }
}
