import 'dart:convert'; // Importa este paquete para usar json.decode
import 'package:flutter/material.dart';
import 'package:menu/models/branch_catalog_response.dart';

class BranchCatalogProvider extends ChangeNotifier {
  BranchCatalogResponse? _branchCatalog;

  BranchCatalogResponse? get branchCatalog => _branchCatalog;

  // Simula la carga de datos desde un JSON estático
  Future<void> fetchBranchCatalog(String branchId) async {
    // Simula un retraso si quieres imitar una llamada de red
    await Future.delayed(Duration(seconds: 1));

    // JSON como un String. Reemplaza este string con tu JSON real
    String jsonString = '''
 {
	"brand_name": "Frutería La Única",
	"branch_name": "Río",
	"instagram_link": "https://www.instagram.com/fruterialaunica/",
	"facebook_link": "https://facebook.com/fruterialaunicario",
	"website_link": "https://www.fruterialaunica.com.mx/",
	"brand_logo": "https://www.imagelogo.com",
	"brand_slogan": "Únicamente la mejor",
	"menu_background": "https://i0.wp.com/foodandpleasure.com/wp-content/uploads/2022/08/drinks-en-monterrey-terraza-coss.jpeg?fit=1080%2C1350&ssl=1",
	"catalogs": [
		{
			"name": "Menú Infantil",
			"description": "Menú diseñado para niños con opciones saludables y divertidas.",
			"icon": "url_icono_menu_infantil",
			"categories": [
				{
					"name": "Desayunos",
					"description": "Opciones saludables y energéticas para empezar el día.",
					"icon": "url_icono_desayunos",
					"items": [
						{
							"alias": "Hot Cakes",
							"description": "Hot Cakes suaves con miel de maple",
							"icon": "https://www.recetasnestle.com.mx/sites/default/files/srh_recipes/f395e167c1613770edb2b32d44260c80.jpg",
							"price": 119
						},
						{
							"alias": "Cereal con Yogurt",
							"description": "Cereal integral con yogurt natural y frutas de temporada",
							"icon": "https://www.prairiefarms.com/wp-content/uploads/files/2023/Cereal-and-Yogurt-Parfait.jpg",
							"price": 49
						}
					],
					"products": [
						{
							"alias": "Jugo de Betabel",
							"description": "Jugo de Betabel fresco 100% natural",
							"icon": "https://assets.tmecosys.com/image/upload/t_web767x639/img/recipe/vimdb/152998_4-741-3056-3056.jpg",
							"modifiersGroups": [
								{
									"alias": "Tamaño",
									"description": "¡Escoge el tamaño que se ajuste mas a tu antojo!",
									"icon": "url_icono_extras_desayuno",
									"modifiers": [
										{
											"alias": "Chico",
											"description": "Vaso de 500ml",
											"icon": "url_icono_extra_miel",
											"price": 55
										},
										{
											"alias": "Mediano",
											"description": "Vaso de 500ml",
											"icon": "url_icono_extra_miel",
											"price": 65
										},
										{
											"alias": "Grande",
											"description": "Porción adicional de fruta de temporada",
											"icon": "url_icono_extra_fruta",
											"price": 85
										}
									]
								},
								{
									"alias": "Extras",
									"description": "Añade extras a tu desayuno",
									"icon": "url_icono_extras_desayuno",
									"modifiers": [
										{
											"alias": "Zanahoria",
											"description": "Porción adicional de miel de maple",
											"icon": "url_icono_extra_miel",
											"price": 20
										},
										{
											"alias": "Naranja",
											"description": "Porción adicional de fruta de temporada",
											"icon": "url_icono_extra_fruta",
											"price": 15
										},
										{
											"alias": "Piña",
											"description": "Porción adicional de fruta de temporada",
											"icon": "url_icono_extra_fruta",
											"price": 5
										}
									]
								}
							]
						},
						{
							"alias": "Combo Cereal Niños",
							"description": "Incluye leche a elección, cereal integral y porción de frutas",
							"icon": "url_icono_combo_cereal",
							"modifiersGroups": [
								{
									"alias": "Extras de desayuno",
									"description": "Añade extras a tu desayuno",
									"icon": "url_icono_extras_desayuno",
									"modifiers": [
										{
											"alias": "Extra miel",
											"description": "Porción adicional de miel de maple",
											"icon": "url_icono_extra_miel",
											"price": 1
										},
										{
											"alias": "Extra fruta",
											"description": "Porción adicional de fruta de temporada",
											"icon": "url_icono_extra_fruta",
											"price": 1.5
										}
									]
								},
								{
									"alias": "Tipos de leche",
									"description": "Elige el tipo de leche para tu cereal",
									"icon": "url_icono_tipos_leche",
									"modifiers": [
										{
											"alias": "Leche Entera",
											"description": "Leche entera fresca",
											"icon": "url_icono_leche_entera",
											"price": 0
										},
										{
											"alias": "Leche de Almendra",
											"description": "Leche de almendra sin azúcar añadida",
											"icon": "url_icono_leche_almendra",
											"price": 0.5
										}
									]
								}
							]
						}
					]
				},
				{
					"name": "Comidas",
					"description": "Platos fuertes y nutritivos para la comida.",
					"icon": "url_icono_comidas",
					"items": [
						{
							"alias": "Hot Cakes",
							"description": "Hot Cakes suaves con miel de maple",
							"icon": "url_icono_hotcakes",
							"price": 5
						},
						{
							"alias": "Cereal con Yogurt",
							"description": "Cereal integral con yogurt natural y frutas de temporada",
							"icon": "url_icono_cereal_yogurt",
							"price": 4
						}
					],
					"products": [
						{
							"alias": "Combo Desayuno Niños",
							"description": "Incluye jugo de naranja, hot cakes y porción de frutas",
							"icon": "url_icono_combo_desayuno",
							"modifiersGroups": [
								{
									"alias": "Extras de desayuno",
									"description": "Añade extras a tu desayuno",
									"icon": "url_icono_extras_desayuno",
									"modifiers": [
										{
											"alias": "Extra miel",
											"description": "Porción adicional de miel de maple",
											"icon": "url_icono_extra_miel",
											"price": 1
										},
										{
											"alias": "Extra fruta",
											"description": "Porción adicional de fruta de temporada",
											"icon": "url_icono_extra_fruta",
											"price": 1.5
										}
									]
								},
								{
									"alias": "Tipos de leche",
									"description": "Elige el tipo de leche para tu cereal",
									"icon": "url_icono_tipos_leche",
									"modifiers": [
										{
											"alias": "Leche Entera",
											"description": "Leche entera fresca",
											"icon": "url_icono_leche_entera",
											"price": 0
										},
										{
											"alias": "Leche de Almendra",
											"description": "Leche de almendra sin azúcar añadida",
											"icon": "url_icono_leche_almendra",
											"price": 0.5
										}
									]
								}
							]
						},
						{
							"alias": "Combo Cereal Niños",
							"description": "Incluye leche a elección, cereal integral y porción de frutas",
							"icon": "url_icono_combo_cereal",
							"modifiersGroups": [
								{
									"alias": "Extras de desayuno",
									"description": "Añade extras a tu desayuno",
									"icon": "url_icono_extras_desayuno",
									"modifiers": [
										{
											"alias": "Extra miel",
											"description": "Porción adicional de miel de maple",
											"icon": "url_icono_extra_miel",
											"price": 1
										},
										{
											"alias": "Extra fruta",
											"description": "Porción adicional de fruta de temporada",
											"icon": "url_icono_extra_fruta",
											"price": 1.5
										}
									]
								},
								{
									"alias": "Tipos de leche",
									"description": "Elige el tipo de leche para tu cereal",
									"icon": "url_icono_tipos_leche",
									"modifiers": [
										{
											"alias": "Leche Entera",
											"description": "Leche entera fresca",
											"icon": "url_icono_leche_entera",
											"price": 0
										},
										{
											"alias": "Leche de Almendra",
											"description": "Leche de almendra sin azúcar añadida",
											"icon": "url_icono_leche_almendra",
											"price": 0.5
										}
									]
								}
							]
						}
					]
				}
			]
		}
	]
}
    '''; // Asegúrate de incluir todo tu JSON aquí

    // Decodifica el JSON
    final jsonResponse = json.decode(jsonString);

    // Crea la instancia de BranchCatalogResponse a partir del JSON decodificado
    _branchCatalog = BranchCatalogResponse.fromJson(jsonResponse);

    // Notifica a los oyentes sobre el cambio
    notifyListeners();
  }
}





/*import 'package:flutter/material.dart';
import 'package:menu/api/api_4uRest.dart';
import 'package:menu/models/branch_catalog_response.dart';

class BranchCatalogProvider extends ChangeNotifier {
  BranchCatalogResponse? _branchCatalog;

  BranchCatalogResponse? get branchCatalog => _branchCatalog;

  Future<void> fetchBranchCatalog(String branchId) async {
    final response = await Api4uRest.httpGet(
        'https://tu-endpoint-aqui.com/catalogs/$branchId');
    _branchCatalog = BranchCatalogResponse.fromJson(
        response); // Asume que tienes este método en tu clase model
    notifyListeners();
  }
}
*/