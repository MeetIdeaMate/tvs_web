class UserAccess {
  String? departmentId;
  List<Menu>? menus;
  String? role;
  List<UIComponent>? uiComponents;
  String? userId;

  UserAccess({
    this.departmentId,
    this.menus,
    this.role,
    this.uiComponents,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'departmentId': departmentId,
      'menus': menus?.map((menu) => menu.toJson()).toList(),
      'role': role,
      'uiComponents': uiComponents?.map((component) => component.toJson()).toList(),
      'userId': userId,
    };
  }
}

class Menu {
  List<String>? accessLevels;
  String? menuName;

  Menu({
    this.accessLevels,
    this.menuName,
  });

  Map<String, dynamic> toJson() {
    return {
      'accessLevels': accessLevels,
      'menuName': menuName,
    };
  }
}

class UIComponent {
  List<String>? accessLevels;
  String? componentName;

  UIComponent({
    this.accessLevels,
    this.componentName,
  });

  Map<String, dynamic> toJson() {
    return {
      'accessLevels': accessLevels,
      'componentName': componentName,
    };
  }
}
