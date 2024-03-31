import 'dart:convert';

BranchCatalogResponse branchCatalogResponseFromJson(String str) =>
    BranchCatalogResponse.fromJson(json.decode(str));

String branchCatalogResponseToJson(BranchCatalogResponse data) =>
    json.encode(data.toJson());

class BranchCatalogResponse {
  String brandId;
  String branchId;
  String brandName;
  String branchName;
  String instagramLink;
  String facebookLink;
  String websiteLink;
  String brandLogo;
  String brandSlogan;
  String menuBackground;
  List<Catalog> catalogs;

  BranchCatalogResponse({
    this.brandId = '',
    this.branchId = '',
    this.brandName = '',
    this.branchName = '',
    this.instagramLink = '',
    this.facebookLink = '',
    this.websiteLink = '',
    this.brandLogo = '',
    this.brandSlogan = '',
    this.menuBackground = '',
    this.catalogs = const [],
  });

  factory BranchCatalogResponse.fromJson(Map<String, dynamic> json) =>
      BranchCatalogResponse(
        brandId: json["brandId"] ?? '',
        branchId: json["branchId"] ?? '',
        brandName: json["brandName"] ?? '',
        branchName: json["branchName"] ?? '',
        instagramLink: json["instagramLink"] ?? '',
        facebookLink: json["facebookLink"] ?? '',
        websiteLink: json["websiteLink"] ?? '',
        brandLogo: json["brandLogo"] ?? '',
        brandSlogan: json["brandSlogan"] ?? '',
        menuBackground: json["menuBackground"] ?? '',
        catalogs: List<Catalog>.from(
            json["catalogs"]?.map((x) => Catalog.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "brandId": brandId,
        "branchId": branchId,
        "brandName": brandName,
        "branchName": branchName,
        "instagramLink": instagramLink,
        "facebookLink": facebookLink,
        "websiteLink": websiteLink,
        "brandLogo": brandLogo,
        "brandSlogan": brandSlogan,
        "menuBackground": menuBackground,
        "catalogs": List<dynamic>.from(catalogs.map((x) => x.toJson())),
      };
}

class Catalog {
  String id;
  String name;
  String description;
  String icon;
  List<Category> categories;

  Catalog({
    this.id = '',
    this.name = '',
    this.description = '',
    this.icon = '',
    this.categories = const [],
  });

  factory Catalog.fromJson(Map<String, dynamic> json) => Catalog(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        icon: json["icon"],
        categories: List<Category>.from(
            json["categories"]?.map((x) => Category.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "icon": icon,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class Category {
  String id;
  String name;
  String description;
  String icon;
  List<Item> items;
  List<Item> products;

  Category({
    this.id = '',
    this.name = '',
    this.description = '',
    this.icon = '',
    this.items = const [],
    this.products = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        icon: json["icon"],
        items:
            List<Item>.from(json["items"]?.map((x) => Item.fromJson(x)) ?? []),
        products: List<Item>.from(
            json["products"]?.map((x) => Item.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "icon": icon,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class ModifiersGroup {
  String id;
  String alias;
  String description;
  String icon;
  String isSelectable;
  List<Item> modifiers;

  ModifiersGroup({
    this.id = '',
    this.alias = '',
    this.description = '',
    this.icon = '',
    this.isSelectable = '0',
    this.modifiers = const [],
  });

  factory ModifiersGroup.fromJson(Map<String, dynamic> json) => ModifiersGroup(
        id: json["id"],
        alias: json["alias"],
        description: json["description"],
        icon: json["icon"],
        isSelectable: json["isSelectable"],
        modifiers:
            List<Item>.from(json["modifiers"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "alias": alias,
        "description": description,
        "icon": icon,
        "isSelectable": isSelectable,
        "modifiers": List<dynamic>.from(modifiers.map((x) => x.toJson())),
      };
}

class Item {
  String id;
  String alias;
  String description;
  String icon;
  String price;
  List<ModifiersGroup> modifiersGroups;

  Item({
    this.id = '',
    this.alias = '',
    this.description = '',
    this.icon = '',
    this.price = '0',
    this.modifiersGroups = const [],
  });
  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        alias: json["alias"],
        description: json["description"],
        //description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the ind",
        icon: json["icon"],
        price: json["price"] ?? "0",
        modifiersGroups: List<ModifiersGroup>.from(
            json["modifiersGroups"]?.map((x) => ModifiersGroup.fromJson(x)) ??
                []),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "alias": alias,
        "description": description,
        "icon": icon,
        "price": price,
        "modifiersGroups":
            List<dynamic>.from(modifiersGroups.map((x) => x.toJson())),
      };
}
