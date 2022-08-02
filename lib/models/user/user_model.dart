class UserLoginResponse {
  int? userId;
  String? email;
  int? userTypeId;
  int? employeeId;
  bool? isUserCityHasMultipleWarehouse;
  String? lastLoginDateTime;
  String? fullName;
  String? jwtToken;

  UserLoginResponse(
      {this.userId,
      this.email,
      this.userTypeId,
      this.employeeId,
      this.isUserCityHasMultipleWarehouse,
      this.lastLoginDateTime,
      this.fullName,
      this.jwtToken});

  factory UserLoginResponse.fromJson(json) {
    return UserLoginResponse(
      userId: json['userId'],
      email: json['email'],
      userTypeId: json['userTypeId'],
      employeeId: json['employeeId'],
      isUserCityHasMultipleWarehouse: json['isUserCityHasMultipleWarehouse'],
      lastLoginDateTime: json['lastLoginDateTime'],
      fullName: json['fullName'],
      jwtToken: json['jwtToken'],
    );
  }
}

class UserLoginRequestData {
  int? applicationTypeId;
  String? email;
  String? password;

  UserLoginRequestData({this.applicationTypeId, this.email, this.password});

  Map toJson() {
    return {
      "applicationTypeId": applicationTypeId,
      "email": email!,
      "password": password!,
    };
  }
}

// class UserMenuData {
//   List<UserMenuDataDist>? dist;

//   UserMenuData({this.dist});

//   factory UserMenuData.fromJson(json) {
//     return UserMenuData(
//       dist: UserMenuData.parseDist(json.dist),
//     );
//   }

//   static List<UserMenuDataDist>? parseDist(dist) {
//     var list = dist as List;

//     List<UserMenuDataDist> distList =
//         list.map((e) => UserMenuDataDist.fromJson(e)).toList();
//     return distList;
//   }
// }

// class UserMenuDataDist {
//   int? moduleId;
//   String? name;
//   String? description;
//   bool? active;
//   String? icon;
//   int? sequenceNumber;
//   String? actionCode;
//   String? moduleType;
//   bool? allowed;
//   List<UserMenuChild>? child;

//   UserMenuDataDist(
//       {this.moduleId,
//       this.name,
//       this.description,
//       this.active,
//       this.icon,
//       this.sequenceNumber,
//       this.actionCode,
//       this.moduleType,
//       this.allowed,
//       this.child});

//   factory UserMenuDataDist.fromJson(Map<String, dynamic> distJson) {
//     return UserMenuDataDist(
//       moduleId: distJson['moduleId'],
//       name: distJson['name'],
//       description: distJson['description'],
//       active: distJson['active'],
//       icon: distJson['icon'],
//       sequenceNumber: distJson['sequenceNumber'],
//       actionCode: distJson['actionCode'],
//       moduleType: distJson['moduleType'],
//       allowed: distJson['allowed'],
//       child: UserMenuDataDist.parseChild(distJson['child']),
//     );
//   }

//   static List<UserMenuChild>? parseChild(child) {
//     var list = child as List;

//     List<UserMenuChild> childList =
//         list.map((e) => UserMenuChild.fromJson(e)).toList();
//     return childList;
//   }
// }

// class UserMenuChild {
//   int? moduleId;
//   int? parentModuleId;
//   String? name;
//   String? description;
//   bool? active;
//   String? icon;
//   int? sequenceNumber;
//   String? actionCode;
//   String? moduleType;
//   bool? allowed;
//   List<UserMenuGrandChild>? child;

//   UserMenuChild(
//       {this.moduleId,
//       this.parentModuleId,
//       this.name,
//       this.description,
//       this.active,
//       this.icon,
//       this.sequenceNumber,
//       this.actionCode,
//       this.moduleType,
//       this.allowed,
//       this.child});

//   factory UserMenuChild.fromJson(Map<String, dynamic> childJson) {
//     return UserMenuChild(
//       moduleId: childJson['moduleId'],
//       parentModuleId: childJson['parentModuleId'],
//       name: childJson['name'],
//       description: childJson['description'],
//       active: childJson['active'],
//       icon: childJson['icon'],
//       sequenceNumber: childJson['sequenceNumber'],
//       actionCode: childJson['actionCode'],
//       moduleType: childJson['moduleType'],
//       allowed: childJson['allowed'],
//       child: UserMenuChild.parseChild(childJson['child']),
//     );
//   }

//   static List<UserMenuGrandChild>? parseChild(child) {
//     var list = child as List;

//     List<UserMenuGrandChild> childList =
//         list.map((e) => UserMenuGrandChild.fromJson(e)).toList();
//     return childList;
//   }
// }

// class UserMenuGrandChild {
//   int? moduleId;
//   int? parentModuleId;
//   String? name;
//   String? description;
//   bool? active;
//   String? icon;
//   int? sequenceNumber;
//   String? actionCode;
//   String? moduleType;
//   bool? allowed;

//   UserMenuGrandChild({
//     this.moduleId,
//     this.parentModuleId,
//     this.name,
//     this.description,
//     this.active,
//     this.icon,
//     this.sequenceNumber,
//     this.actionCode,
//     this.moduleType,
//     this.allowed,
//   });

//   factory UserMenuGrandChild.fromJson(Map<String, dynamic> grandChildJson) {
//     return UserMenuGrandChild(
//       moduleId: grandChildJson['moduleId'],
//       parentModuleId: grandChildJson['parentModuleId'],
//       name: grandChildJson['name'],
//       description: grandChildJson['description'],
//       active: grandChildJson['active'],
//       icon: grandChildJson['icon'],
//       sequenceNumber: grandChildJson['sequenceNumber'],
//       actionCode: grandChildJson['actionCode'],
//       moduleType: grandChildJson['moduleType'],
//       allowed: grandChildJson['allowed'],
//     );
//   }
// }

class MenuData {
  List<MenuDataDist>? dist;

  MenuData({this.dist});

  factory MenuData.fromJson(json) {
    return MenuData(
      dist: MenuData.parseDist(json.dist),
    );
  }

  static List<MenuDataDist>? parseDist(dist) {
    var list = dist as List;

    List<MenuDataDist> distList =
        list.map((e) => MenuDataDist.fromJson(e)).toList();
    return distList;
  }
}

class MenuDataDist {
  int? menuId;
  String? menuOption;
  String? description;
  bool? active;
  String? icon;
  int? sequenceNumber;
  String? actionCode;
  String? agentType;
  String? url;
  bool? allowed;
  List<MenuChild>? childMenuList;

  MenuDataDist(
      {this.menuId,
      this.menuOption,
      this.description,
      this.active,
      this.icon,
      this.sequenceNumber,
      this.actionCode,
      this.agentType,
      this.url,
      this.allowed,
      this.childMenuList});

  factory MenuDataDist.fromJson(Map<String, dynamic> distJson) {
    return MenuDataDist(
      menuId: distJson['menuId'],
      menuOption: distJson['menuOption'],
      description: distJson['description'],
      active: distJson['active'],
      icon: distJson['icon'],
      sequenceNumber: distJson['sequenceNumber'],
      actionCode: distJson['actionCode'],
      agentType: distJson['agentType'],
      allowed: distJson['allowed'],
      childMenuList: MenuDataDist.parseChild(distJson['childMenuList']),
    );
  }

  static List<MenuChild>? parseChild(child) {
    var list = child as List;

    List<MenuChild> childList = list.map((e) => MenuChild.fromJson(e)).toList();
    return childList;
  }
}

class MenuChild {
  int? menuId;
  int? parentMenuId;
  String? menuOption;
  String? parentMenuOption;
  String? description;
  bool? active;
  String? icon;
  int? sequenceNumber;
  String? actionCode;
  String? agentType;
  String? url;
  bool? allowed;
  List<MenuGrandChild>? childMenuList;

  MenuChild(
      {this.menuId,
      this.parentMenuId,
      this.menuOption,
      this.parentMenuOption,
      this.description,
      this.active,
      this.icon,
      this.sequenceNumber,
      this.actionCode,
      this.agentType,
      this.url,
      this.allowed,
      this.childMenuList});

  factory MenuChild.fromJson(Map<String, dynamic> childJson) {
    return MenuChild(
      menuId: childJson['menuId'],
      parentMenuId: childJson['parentMenuId'],
      menuOption: childJson['menuOption'],
      parentMenuOption: childJson['parentMenuOption'],
      description: childJson['description'],
      active: childJson['active'],
      icon: childJson['icon'],
      sequenceNumber: childJson['sequenceNumber'],
      actionCode: childJson['actionCode'],
      agentType: childJson['agentType'],
      url: childJson['url'],
      allowed: childJson['allowed'],
      childMenuList: MenuChild.parseChild(childJson['childMenuList']),
    );
  }

  static List<MenuGrandChild>? parseChild(child) {
    var list = child as List;

    List<MenuGrandChild> childList =
        list.map((e) => MenuGrandChild.fromJson(e)).toList();
    return childList;
  }
}

class MenuGrandChild {
  int? menuId;
  int? parentMenuId;
  String? menuOption;
  String? parentMenuOption;
  String? description;
  bool? active;
  String? icon;
  int? sequenceNumber;
  String? actionCode;
  String? agentType;
  String? url;
  bool? allowed;

  MenuGrandChild({
    this.menuId,
    this.parentMenuId,
    this.menuOption,
    this.parentMenuOption,
    this.description,
    this.active,
    this.icon,
    this.sequenceNumber,
    this.actionCode,
    this.agentType,
    this.url,
    this.allowed,
  });

  factory MenuGrandChild.fromJson(Map<String, dynamic> grandChildJson) {
    return MenuGrandChild(
      menuId: grandChildJson['menuId'],
      parentMenuId: grandChildJson['parentMenuId'],
      menuOption: grandChildJson['menuOption'],
      parentMenuOption: grandChildJson['parentMenuOption'],
      description: grandChildJson['description'],
      active: grandChildJson['active'],
      icon: grandChildJson['icon'],
      sequenceNumber: grandChildJson['sequenceNumber'],
      actionCode: grandChildJson['actionCode'],
      agentType: grandChildJson['agentType'],
      url: grandChildJson['url'],
      allowed: grandChildJson['allowed'],
    );
  }
}

class UserLogoutRequestData {
  String? email;
  String? jwtToken;

  UserLogoutRequestData({this.email, this.jwtToken});

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "jwt_token": jwtToken,
    };
  }
}
