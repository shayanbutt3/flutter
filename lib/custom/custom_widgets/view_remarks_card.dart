import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewRemarksCARD extends StatefulWidget {
  final OrderRemarksDataDist dist;
  final String transactionStatus;

  const ViewRemarksCARD({
    required this.dist,
    required this.transactionStatus,
    Key? key,
  }) : super(key: key);

  @override
  _ViewRemarksCARDState createState() => _ViewRemarksCARDState();
}

class _ViewRemarksCARDState extends State<ViewRemarksCARD> {
  SharedPreferences? localStorage;

  late OrderRemarksDataDist dist;
  late String transactionStatus;

  late String loggedInUserName;

  getLoggedInUserName() async {
    localStorage = await SharedPreferences.getInstance();
    await localStorage?.reload();
    setState(() {
      loggedInUserName = localStorage?.getString('fullName') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    getLoggedInUserName();
    dist = widget.dist;
    transactionStatus = widget.transactionStatus;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var titleColor = Colors.black54;

    var valueColor = Colors.green[600];

    var remarksColor = Colors.black;

    return Card(
      margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeVertical,
            horizontal: SizeConfig.blockSizeHorizontal * 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: MyTitleValueColumn(
                    title: 'Date',
                    value: dist.createDatetime == null
                        ? '-'
                        : myFormatDateTime(dist.createDatetime!),
                    titleColor: titleColor,
                    valueColor: valueColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical,
            ),
            Row(
              children: [
                Expanded(
                  child: MyTitleValueColumn(
                    title: 'User Name',
                    value: dist.username == null ? '-' : dist.username!,
                    titleColor: titleColor,
                    valueColor: valueColor,
                  ),
                ),
                Expanded(
                  child: MyTitleValueColumn(
                    title: 'Remarks',
                    value: dist.remarks == null ? '-' : dist.remarks!,
                    titleColor: titleColor,
                    valueColor: remarksColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
