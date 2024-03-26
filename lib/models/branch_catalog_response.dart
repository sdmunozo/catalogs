// To parse this JSON data, do
//
//     final branchCatalogResponse = branchCatalogResponseFromJson(jsonString);

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
    required this.brandId,
    required this.branchId,
    required this.brandName,
    required this.branchName,
    required this.instagramLink,
    required this.facebookLink,
    required this.websiteLink,
    required this.brandLogo,
    required this.brandSlogan,
    required this.menuBackground,
    required this.catalogs,
  });

  factory BranchCatalogResponse.fromJson(Map<String, dynamic> json) =>
      BranchCatalogResponse(
        brandId: json["brandId"],
        branchId: json["branchId"],
        brandName: json["brandName"],
        branchName: json["branchName"],
        instagramLink: json["instagramLink"],
        facebookLink: json["facebookLink"],
        websiteLink: json["websiteLink"],
        brandLogo: json["brandLogo"],
        brandSlogan: json["brandSlogan"],
        menuBackground: json["menuBackground"],
        catalogs: List<Catalog>.from(
            json["catalogs"].map((x) => Catalog.fromJson(x))),
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
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.categories,
  });

  factory Catalog.fromJson(Map<String, dynamic> json) => Catalog(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        icon: json["icon"],
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "icon": icon,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class Category {
  String name;
  String description;
  String icon;
  List<Item> items;
  List<Item> products;

  Category({
    required this.name,
    required this.description,
    required this.icon,
    required this.items,
    required this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        description: json["description"],
        icon: json["icon"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        products:
            List<Item>.from(json["products"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "icon": icon,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Item {
  String alias;
  String description;
  String icon;
  String price;
  List<Item> modifiersGroups;
  List<Item> modifiers;

  Item({
    required this.alias,
    required this.description,
    required this.icon,
    required this.price,
    required this.modifiersGroups,
    required this.modifiers,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        alias: json["alias"],
        description: json["description"],
        icon: json["icon"],
        price: json["price"] ?? "0",
        modifiersGroups: json["modifiersGroups"] == null
            ? []
            : List<Item>.from(
                json["modifiersGroups"].map((x) => Item.fromJson(x))),
        modifiers: json["modifiers"] == null
            ? []
            : List<Item>.from(json["modifiers"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "alias": alias,
        "description": description,
        "icon": icon,
        "price": price,
        "modifiersGroups":
            List<dynamic>.from(modifiersGroups.map((x) => x.toJson())),
        "modifiers": List<dynamic>.from(modifiers.map((x) => x.toJson())),
      };
}
