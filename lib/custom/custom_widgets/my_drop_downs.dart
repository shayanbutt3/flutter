import 'package:auto_size_text/auto_size_text.dart';
import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDropDownRider extends StatelessWidget {
  const MyDropDownRider(
      {this.isExpanded,
      this.selectedValue,
      required this.onChanged,
      required this.listOfItems,
      Key? key})
      : super(key: key);

  final bool? isExpanded;
  final String? selectedValue;
  final Function(String?)? onChanged;
  final List listOfItems;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return
          // SizedBox(
          //   height: MyVariables.searchDropDownHeight * 1.45,
          // child:

          //   IgnorePointer(
          // ignoring: listOfItems.isEmpty ? true : false,
          // child:
          DropdownSearch<String>(
              // dropDownButton: DropdownButtonHideUnderline(
              //   child: DropdownButton(
              //     icon: Icon(
              //       Icons.arrow_drop_down_sharp,
              //       color: listOfItems.isEmpty ? Colors.grey : Colors.black,
              //     ),
              //     items: [],
              //   ),
              // ),
              enabled: listOfItems.isEmpty ? false : true,
              showAsSuffixIcons: true,
              mode: Mode.MENU,
              maxHeight: MyVariables.dropDownHeight,
              showSearchBox: true,
              items: listOfItems.map((rider) {
                return "${rider.riderName!}";
              }).toList(),
              dropdownSearchDecoration: InputDecoration(
                hintText: MyVariables.riderDropdownHintText,
              ),
              onChanged: onChanged,
              selectedItem: selectedValue);
      // ),
      // );
    });
  }
}

class MyDropDownMerchant extends StatelessWidget {
  const MyDropDownMerchant(
      {this.isExpanded,
      this.selectedValue,
      required this.onChanged,
      required this.listOfItems,
      Key? key})
      : super(key: key);

  final bool? isExpanded;
  final String? selectedValue;
  final Function(String?)? onChanged;
  // final List<MerchantLookupDataDist> listOfItems;
  final List listOfItems;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownSearch<String>(
        items: listOfItems.map((merchant) {
          return "${merchant.merchantName!}";
        }).toList(),
        enabled: listOfItems.isEmpty ? false : true,
        mode: Mode.MENU,
        maxHeight: MyVariables.dropDownHeight,
        showAsSuffixIcons: true,
        showSearchBox: true,
        selectedItem: selectedValue,
        onChanged: onChanged,
        dropdownSearchDecoration: InputDecoration(
          hintText: MyVariables.merchantDropdownHintText,
        ),
      );
    });
  }
}

class MyDropDownMuTag extends StatelessWidget {
  const MyDropDownMuTag(
      {this.isExpanded,
      this.selectedValue,
      required this.onChanged,
      required this.listOfItems,
      Key? key})
      : super(key: key);

  final bool? isExpanded;
  final String? selectedValue;
  final Function(Object?)? onChanged;
  final List listOfItems;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownSearch<String>(
        items: listOfItems.map((muTag) {
          return "${muTag.masterUnitNumber!}";
        }).toList(),
        enabled: listOfItems.isEmpty ? false : true,
        mode: Mode.MENU,
        maxHeight: MyVariables.dropDownHeight,
        showAsSuffixIcons: true,
        showSearchBox: true,
        selectedItem: selectedValue,
        onChanged: onChanged,
        dropdownSearchDecoration:
            InputDecoration(hintText: MyVariables.muTagDropdownHintText),
      );
    });
  }
}

class MyDropDownWareHouse extends StatelessWidget {
  const MyDropDownWareHouse(
      {this.isExpanded,
      this.selectedValue,
      required this.onChanged,
      required this.listOfItems,
      this.needToHideUnderline,
      Key? key})
      : super(key: key);

  final bool? isExpanded;
  final String? selectedValue;
  final Function(Object?)? onChanged;
  // final List<WareHouseDataDist> listOfItems;
  final List listOfItems;
  final bool? needToHideUnderline;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Obx(() {
      return
          // DropdownSearch<String>(
          //   items: listOfItems.map((wareHouse) {
          //     return "${wareHouse.wareHouseName!}";
          //   }).toList(),
          //   enabled: listOfItems.isEmpty ? false : true,
          //   mode: Mode.MENU,
          //   maxHeight: MyVariables.dropDownHeight,
          //   showAsSuffixIcons: true,
          //   showSearchBox: true,
          //   onChanged: onChanged,
          //   selectedItem: selectedValue,
          //   dropdownSearchDecoration: const InputDecoration(
          //     hintText: 'Select WareHouse',
          //   ),
          // );
          DropdownButton(
        hint: AutoSizeText(MyVariables.wareHouseDropdownHintText),
        isExpanded: isExpanded == null ? true : isExpanded!,
        underline: needToHideUnderline == true
            ? Container(
                height: 0,
                color: Colors.transparent,
              )
            : null,
        menuMaxHeight: MyVariables.dropDownHeight,
        value: selectedValue,
        onChanged: onChanged,
        items: listOfItems.map((wareHouse) {
          return DropdownMenuItem(
            child: AutoSizeText(wareHouse.wareHouseName!),
            value: wareHouse.wareHouseName!,
          );
        }).toList(),
      );
    });
  }
}

class MyDropDownMerchantCity extends StatelessWidget {
  const MyDropDownMerchantCity(
      {this.isExpanded,
      this.selectedValue,
      required this.onChanged,
      required this.listOfItems,
      this.needtoHideSearchBox,
      Key? key})
      : super(key: key);

  final bool? isExpanded;
  final String? selectedValue;
  final Function(Object?)? onChanged;
  final List listOfItems;
  final bool? needtoHideSearchBox;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownSearch<String>(
          showAsSuffixIcons: true,
          mode: Mode.MENU,
          showSearchBox: needtoHideSearchBox == true ? false : true,
          items: listOfItems.map((city) {
            return "${city.cityName!}";
          }).toList(),
          enabled: listOfItems.isEmpty ? false : true,
          dropdownSearchDecoration: InputDecoration(
            hintText: MyVariables.merchantCityDropdownHintText,
          ),
          onChanged: onChanged,
          selectedItem: selectedValue);
    });
  }
}

class MyDropDownMerchantPickupAddress extends StatelessWidget {
  const MyDropDownMerchantPickupAddress(
      {this.isExpanded,
      this.selectedValue,
      required this.onChanged,
      required this.listOfItems,
      this.needToHideSearchBox,
      Key? key})
      : super(key: key);

  final bool? isExpanded;
  final String? selectedValue;
  final Function(Object?)? onChanged;
  final List listOfItems;
  final bool? needToHideSearchBox;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownSearch<String>(
          enabled: listOfItems.isEmpty ? false : true,
          showAsSuffixIcons: true,
          mode: Mode.MENU,
          showSearchBox: needToHideSearchBox == true ? false : true,
          items: listOfItems.map((address) {
            return "${address.address!}";
          }).toList(),
          dropdownSearchDecoration: InputDecoration(
            hintText: MyVariables.merchantPickupAddressDropdownHintText,
          ),
          onChanged: onChanged,
          selectedItem: selectedValue);
    });
  }
}

class MyDropDownLoadSheetsNew extends StatelessWidget {
  const MyDropDownLoadSheetsNew(
      {this.isExpanded,
      this.selectedValue,
      required this.onChanged,
      required this.listOfItems,
      Key? key})
      : super(key: key);

  final bool? isExpanded;
  final String? selectedValue;
  final Function(String?)? onChanged;
  final List listOfItems;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownSearch<String>(
          enabled: listOfItems.isEmpty ? false : true,
          showAsSuffixIcons: true,
          mode: Mode.MENU,
          maxHeight: MyVariables.dropDownHeight,
          showSearchBox: true,
          items: listOfItems.map((loadSheet) {
            return "${loadSheet.loadSheetName!} - [${loadSheet.merchantName}]";
          }).toList(),
          dropdownSearchDecoration: InputDecoration(
            hintText: MyVariables.loadSheetDropdownHintText,
          ),
          onChanged: onChanged,
          selectedItem: selectedValue);
    });
  }
}

class MyDropDownSheetStatus extends StatelessWidget {
  const MyDropDownSheetStatus(
      {this.isExpanded,
      this.selectedValue,
      required this.onChanged,
      required this.listOfItems,
      Key? key})
      : super(key: key);

  final bool? isExpanded;
  final String? selectedValue;
  final Function(Object?)? onChanged;
  final List listOfItems;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownSearch<String>(
          enabled: listOfItems.isEmpty ? false : true,
          showAsSuffixIcons: true,
          mode: Mode.MENU,
          showSearchBox: true,
          items: listOfItems.map((status) {
            return "${status.sheetStatus!}";
          }).toList(),
          dropdownSearchDecoration: InputDecoration(
            hintText: MyVariables.sheetStatusDropdownHintText,
          ),
          onChanged: onChanged,
          selectedItem: selectedValue);
    });
  }
}

class MyDropDownSheetNumbers extends StatelessWidget {
  const MyDropDownSheetNumbers(
      {this.isExpanded,
      this.selectedValue,
      required this.onChanged,
      required this.listOfItems,
      Key? key})
      : super(key: key);

  final bool? isExpanded;
  final String? selectedValue;
  final Function(String?)? onChanged;
  final List listOfItems;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownSearch<String>(
          enabled: listOfItems.isEmpty ? false : true,
          showAsSuffixIcons: true,
          mode: Mode.MENU,
          maxHeight: MyVariables.dropDownHeight,
          showSearchBox: true,
          items: listOfItems.map((sheet) {
            return "${sheet.sheetNumber!!} - [${sheet.sheetTag}]";
          }).toList(),
          dropdownSearchDecoration: InputDecoration(
            hintText: MyVariables.sheetNumberDropdownHintText,
          ),
          onChanged: onChanged,
          selectedItem: selectedValue);
    });
  }
}

class MyDropDownOrderStatus extends StatelessWidget {
  const MyDropDownOrderStatus(
      {this.isExpanded,
      this.selectedValue,
      required this.onChanged,
      required this.listOfItems,
      Key? key})
      : super(key: key);

  final bool? isExpanded;
  final String? selectedValue;
  final Function(String?)? onChanged;
  final List listOfItems;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownSearch<String>(
          enabled: listOfItems.isEmpty ? false : true,
          showAsSuffixIcons: true,
          mode: Mode.MENU,
          maxHeight: MyVariables.dropDownHeight,
          showSearchBox: true,
          items: listOfItems.map((orderStatus) {
            return "${orderStatus.transactionStatus!}";
          }).toList(),
          dropdownSearchDecoration: InputDecoration(
            hintText: MyVariables.orderStatusDropdownHintText,
          ),
          onChanged: onChanged,
          selectedItem: selectedValue);
    });
  }
}

class MyDropDownDateFilter extends StatelessWidget {
  const MyDropDownDateFilter(
      {this.isExpanded,
      this.selectedValue,
      required this.onChanged,
      required this.listOfItems,
      Key? key})
      : super(key: key);

  final bool? isExpanded;
  final String? selectedValue;
  final Function(String?)? onChanged;
  final List listOfItems;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
        enabled: listOfItems.isEmpty ? false : true,
        showAsSuffixIcons: true,
        mode: Mode.MENU,
        maxHeight: MyVariables.dropDownHeight,
        showSearchBox: true,
        items: listOfItems.map((dateFilter) {
          return "$dateFilter";
        }).toList(),
        dropdownSearchDecoration: InputDecoration(
          hintText: MyVariables.dateFilterDropdownHintText,
        ),
        onChanged: onChanged,
        selectedItem: selectedValue);
  }
}

class MyDropDownOrderType extends StatelessWidget {
  final bool? isExpanded;
  final String? selectedValue;
  final Function(String?)? onChanged;
  final List listOfItems;
  const MyDropDownOrderType(
      {this.isExpanded,
      this.selectedValue,
      this.onChanged,
      required this.listOfItems,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownSearch<String>(
        items: listOfItems.map((orders) {
          return "${orders.orderType!}";
        }).toList(),
        enabled: listOfItems.isEmpty ? false : true,
        mode: Mode.MENU,
        maxHeight: MyVariables.dropDownHeight,
        showAsSuffixIcons: true,
        showSearchBox: true,
        selectedItem: selectedValue,
        onChanged: onChanged,
        dropdownSearchDecoration: InputDecoration(
          hintText: MyVariables.orderTypeDropdownHintText,
        ),
      );
    });
  }
}

class MyDropDownOperationalCity extends StatelessWidget {
  final bool? isExpanded;
  final String? selectedValue;
  final Function(String?)? onChanged;
  final List listOfItems;
  const MyDropDownOperationalCity(
      {this.isExpanded,
      this.selectedValue,
      this.onChanged,
      required this.listOfItems,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownSearch<String>(
        items: listOfItems.map((operationalCity) {
          return "${operationalCity.name!}";
        }).toList(),
        enabled: listOfItems.isEmpty ? false : true,
        mode: Mode.MENU,
        maxHeight: MyVariables.dropDownHeight,
        showAsSuffixIcons: true,
        showSearchBox: true,
        selectedItem: selectedValue,
        onChanged: onChanged,
        dropdownSearchDecoration: InputDecoration(
          hintText: MyVariables.operationalCityDropdownHintText,
        ),
      );
    });
  }
}

class MyDropDownMasterUnit extends StatelessWidget {
  final bool? isExpanded;
  final String? selectedValue;
  final Function(String?)? onChanged;
  final List listOfItems;
  const MyDropDownMasterUnit(
      {this.isExpanded,
      this.selectedValue,
      this.onChanged,
      required this.listOfItems,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownSearch<String>(
        items: listOfItems.map((masterUnit) {
          return "${masterUnit.masterUnitNumber!}";
        }).toList(),
        enabled: listOfItems.isEmpty ? false : true,
        mode: Mode.MENU,
        maxHeight: MyVariables.dropDownHeight,
        showAsSuffixIcons: true,
        showSearchBox: true,
        selectedItem: selectedValue,
        onChanged: onChanged,
        dropdownSearchDecoration: InputDecoration(
          hintText: MyVariables.masterUnitNumberDropdownHintText,
        ),
      );
    });
  }
}

class MyDropDownUserRolesLookup extends StatelessWidget {
  final bool? isExpanded;
  final String? selectedValue;
  final Function(String?)? onChanged;
  final List listOfItems;
  const MyDropDownUserRolesLookup(
      {this.isExpanded,
      this.selectedValue,
      this.onChanged,
      required this.listOfItems,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownSearch<String>(
        items: listOfItems.map((userrole) {
          return "${userrole.roleName!}";
        }).toList(),
        enabled: listOfItems.isEmpty ? false : true,
        mode: Mode.MENU,
        maxHeight: MyVariables.dropDownHeight,
        showAsSuffixIcons: true,
        showSearchBox: true,
        selectedItem: selectedValue,
        onChanged: onChanged,
        dropdownSearchDecoration: InputDecoration(
          hintText: MyVariables.hintTextSelectFromTeam,
        ),
      );
    });
  }
}

class MyDropDownRolesLookup extends StatelessWidget {
  final bool? isExpanded;
  final String? selectedValue;
  final Function(String?)? onChanged;
  final List listOfItems;
  const MyDropDownRolesLookup(
      {this.isExpanded,
      this.selectedValue,
      this.onChanged,
      required this.listOfItems,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownSearch<String>(
        items: listOfItems.map((role) {
          return "${role.roleName!}";
        }).toList(),
        enabled: listOfItems.isEmpty ? false : true,
        mode: Mode.MENU,
        maxHeight: MyVariables.dropDownHeight,
        showAsSuffixIcons: true,
        showSearchBox: true,
        selectedItem: selectedValue,
        onChanged: onChanged,
        dropdownSearchDecoration: InputDecoration(
          hintText: MyVariables.hintTextSelectToTeam,
        ),
      );
    });
  }
}
