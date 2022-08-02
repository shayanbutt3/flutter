import 'package:backoffice_new/constants/urls.dart';
import 'package:backoffice_new/custom/custom_widgets/new_version_available.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/user/user_model.dart';
import 'package:backoffice_new/services/api_post_data.dart';
import 'package:backoffice_new/views/dashboard.dart';
import 'package:version_check/version_check.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ApiPostData apiPostData = ApiPostData();

  UserLoginRequestData requestData = UserLoginRequestData();

  final _formKey = GlobalKey<FormState>();

  bool obsecureText = true;

  // final newVersion = NewVersion(
  //   androidId: "com.postex.backoffice",
  // );

  // void _checkNewVersion() async {
  //   final status = await newVersion.getVersionStatus();

  //   if (status!.canUpdate) {
  //     newVersion.showUpdateDialog(
  //       context: context,
  //       versionStatus: status,
  //       allowDismissal: false,
  //       dialogTitle: 'New Version Available',
  //       dialogText:
  //           'Please update your app to continue.\n\nNote: In case you don\'t see update option at PlayStore please uninstall the app and install it again.\n\nThank you!',
  //       updateButtonText: 'Update Now',
  //     );
  //   } else {}
  // }

  final versionCheck = VersionCheck(
    packageName: 'com.postex.backoffice',
    showUpdateDialog: myCustomShowUpdateDialog,
  );

  checkVersion() async {
    await versionCheck.checkVersion(context);
  }

  @override
  void initState() {
    super.initState();
    // _checkNewVersion();
    checkVersion();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var headingImage = SizedBox(
      width: SizeConfig.screenWidth,
      child: Image.asset(
        "assets/logo/logo.png",
        width: SizeConfig.safeBlockSizeHorizontal * 8,
        height: SizeConfig.safeBlockSizeVertical * 8,
      ),
    );
    var signInText = SizedBox(
      width: SizeConfig.screenWidth,
      child: MyTextWidgetCustom(
        text: 'Sign in to BackOffice portal',
        color: MyColors.textColorGreen,
        fontWeight: FontWeight.w500,
        sizeBlockHorizontalDigit: 5,
      ),
    );

    var envName = SizedBox(
      width: SizeConfig.screenWidth,
      child: MyTextWidgetCustom(
        text: Urls.BASE_URL == Urls.DEV_URL
            ? 'DEV'
            : Urls.BASE_URL == Urls.QA_URL
                ? 'QA'
                : Urls.BASE_URL == Urls.STG_URL
                    ? 'STG'
                    : '',
        color: Colors.red,
        fontWeight: FontWeight.w500,
        sizeBlockHorizontalDigit: 5,
        textAlign: TextAlign.right,
      ),
    );
    var spaceBetweenField = const MySpaceHeight(heightSize: 3);

    var myCustomEmailTextField = MyTextFieldEmail(
      controller: emailController,
      onChanged: (a) {
        setState(() {});
      },
    );
    var myCustomPasswordTextField = MyTextFieldPassword(
        controller: passwordController,
        obsecureText: obsecureText,
        iconButtonOnPressed: () {
          setState(() {
            obsecureText = !obsecureText;
          });
        });

    var loginBtn = MyElevatedButton(
      text: 'Login',
      btnPaddingVerticalSize: 1.5,
      btnPaddingHorizontalSize: 16,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          setState(() {
            myShowLoadingDialog(context);
            requestData = UserLoginRequestData(
              applicationTypeId: 9, //New BackOffice App
              email: emailController.text.toString().trim(),
              password: passwordController.text.toString().trim(),
            );
            apiPostData.login(requestData).then((value) {
              if (value != null) {
                Get.isDialogOpen! ? tryToPop(context) : null;
                myToastSuccess('Logged in successfully');
                Get.off(() => const Dashboard(
                      needToLoadMenu: true,
                      needToLoadProfile: true,
                    ));
              } else {
                // Get.isDialogOpen! ? tryToPop(context) : null;
              }
            });
          });
        } else {
          myToastError('Please enter credentials to login');
        }
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: SizeConfig.safeScreenWidth,
          height: SizeConfig.safeScreenHeight,
          padding: EdgeInsets.all(SizeConfig.safeBlockSizeHorizontal * 3),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.safeBlockSizeVertical * 8,
              ),
              headingImage,
              Urls.BASE_URL == Urls.DEV_URL ||
                      Urls.BASE_URL == Urls.QA_URL ||
                      Urls.BASE_URL == Urls.STG_URL
                  ? envName
                  : Container(),
              const MySpaceHeight(heightSize: 8),
              signInText,
              const MySpaceHeight(heightSize: 4),
              Form(
                key: _formKey,
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const MySpaceHeight(heightSize: 5),
                        myCustomEmailTextField,
                        spaceBetweenField,
                        myCustomPasswordTextField,
                        const MySpaceHeight(heightSize: 4),
                        loginBtn,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
