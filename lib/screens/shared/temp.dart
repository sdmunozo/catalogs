/*

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

    String jsonString = '''
{
"brandId": "e9836589-f766-4bc0-ed86-08dc4ba99b9c",
"branchId": "84e2c10c-918b-4fd4-45ed-08dc4ba99bbb",
"brandName": "Frutería La Única",
"branchName": "Río",
"instagramLink": "https://www.instagram.com/fruterialaunica/",
"facebookLink": "https://www.facebook.com/fruterialaunicario/",
"websiteLink": "https://www.fruterialaunica.com.mx/",
"brandLogo": "",
"brandSlogan": "Únicamente La Mejor",
"menuBackground": "https://i0.wp.com/foodandpleasure.com/wp-content/uploads/2022/08/drinks-en-monterrey-terraza-coss.jpeg?fit=1080%2C1350&ssl=1",
"catalogs": [
{
"id": "a25ee89d-f3a5-464c-900c-08dc4c2e69d8",
"name": "Cocina Mexicana",
"description": "",
"icon": "",
"categories": [
{
"id": "ffc82fff-05ca-48e8-53bc-08dc4c2e6a08",
"name": "Caldos",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "7d6dcc8f-4c78-4264-8c35-08dc4c2e6a7b",
"alias": "Consome",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "48590823-f561-4995-4890-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "2c44393d-90a3-49c0-627f-08dc4c2e6b07",
"alias": "Chico",
"description": "",
"icon": "",
"price": "59"
},
{
"id": "3f91b804-b848-4fa8-6280-08dc4c2e6b07",
"alias": "Grande",
"description": "",
"icon": "",
"price": "79"
}
]
}
]
},
{
"id": "d52ec4f8-5dd8-4780-8c36-08dc4c2e6a7b",
"alias": "Pollo",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "0ab12a9e-a521-457c-4891-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "9a8c867e-d995-4a25-6281-08dc4c2e6b07",
"alias": "Chico",
"description": "",
"icon": "",
"price": "189"
},
{
"id": "1617f4ab-cf42-4d3a-6282-08dc4c2e6b07",
"alias": "Grande",
"description": "",
"icon": "",
"price": "216"
}
]
}
]
},
{
"id": "acc41378-6183-42d8-8c37-08dc4c2e6a7b",
"alias": "Res",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "7e347f20-b846-45b2-4892-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "bab91337-386a-46ba-6283-08dc4c2e6b07",
"alias": "Chico",
"description": "",
"icon": "",
"price": "189"
},
{
"id": "624f8e3d-5048-4500-6284-08dc4c2e6b07",
"alias": "Grande",
"description": "",
"icon": "",
"price": "259"
}
]
}
]
},
{
"id": "f57b5ec5-a289-4019-8c38-08dc4c2e6a7b",
"alias": "Tlalpeño",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "0869175a-8158-4829-4893-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "4a5b2e0c-f300-493d-6285-08dc4c2e6b07",
"alias": "Chico",
"description": "",
"icon": "",
"price": "199"
},
{
"id": "41c86164-dab2-4bf9-6286-08dc4c2e6b07",
"alias": "Grande",
"description": "",
"icon": "",
"price": "259"
}
]
}
]
}
]
},
{
"id": "001ec7db-6eb6-4415-53bd-08dc4c2e6a08",
"name": "Antojitos",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "bd587821-b384-4607-8c39-08dc4c2e6a7b",
"alias": "Tacos Dorados",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "6b2cb16e-1d8b-4c45-4894-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "4bf8f31d-fbfe-4e8e-6287-08dc4c2e6b07",
"alias": "3 pzs",
"description": "",
"icon": "",
"price": "189"
}
]
}
]
},
{
"id": "7b1d7227-0cc2-4703-8c3a-08dc4c2e6a7b",
"alias": "Tostadas",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "785f5b11-37e9-4f6a-4895-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "3b03c998-e1d4-420b-6288-08dc4c2e6b07",
"alias": "3 pzs",
"description": "",
"icon": "",
"price": "209"
}
]
}
]
},
{
"id": "6f6138cf-ea1d-4033-8c3b-08dc4c2e6a7b",
"alias": "Sopes",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "bf845167-e482-402e-4896-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "4147ab6f-d13c-46af-6289-08dc4c2e6b07",
"alias": "3 pzs",
"description": "",
"icon": "",
"price": "204"
}
]
}
]
},
{
"id": "e2e57e0c-56cb-4d7b-8c3c-08dc4c2e6a7b",
"alias": "Flautas",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "74e68cb0-f379-4470-4897-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "e90a1887-c696-4dcd-628a-08dc4c2e6b07",
"alias": "3 pzs",
"description": "",
"icon": "",
"price": "209"
},
{
"id": "beac2a5e-dbe8-41ab-628b-08dc4c2e6b07",
"alias": "4 pzs",
"description": "",
"icon": "",
"price": "229"
}
]
}
]
}
]
},
{
"id": "5ba76bba-c090-44c2-53be-08dc4c2e6a08",
"name": "Platillos Tipicos",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "10c02cdf-77d8-4feb-8c3d-08dc4c2e6a7b",
"alias": "Bistec Ranchero",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "2ef2ba67-e99c-4de2-4898-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "165922e6-7fae-4642-628c-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "169"
}
]
}
]
},
{
"id": "e7cb0111-7013-4f99-8c3e-08dc4c2e6a7b",
"alias": "Milanesa(200gr)",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "271ffd40-4c7b-452b-4899-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "1bc9e8e3-56dd-48cf-628d-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "259"
}
]
}
]
},
{
"id": "e4b75fe2-ef4b-451d-8c3f-08dc4c2e6a7b",
"alias": "Chiles Rellenos",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "e2603f34-d2c4-4b0b-489a-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "0b39cadf-681e-4a19-628e-08dc4c2e6b07",
"alias": "2 pzs",
"description": "",
"icon": "",
"price": "249"
}
]
}
]
},
{
"id": "071d15c1-b79d-4ed1-8c40-08dc4c2e6a7b",
"alias": "Pechuga en Mole Negro 100% Oaxaqueño",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "f4d85671-5bd7-4628-489b-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "8e3a7790-7366-4d3b-628f-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "254"
}
]
}
]
},
{
"id": "ab90fd60-3655-488f-8c41-08dc4c2e6a7b",
"alias": "Tamales",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "24e36900-cf62-49e3-489c-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "89640629-d526-4610-6290-08dc4c2e6b07",
"alias": "Res",
"description": "",
"icon": "",
"price": "79"
},
{
"id": "dd5f7019-359d-498a-6291-08dc4c2e6b07",
"alias": "Piña",
"description": "",
"icon": "",
"price": "79"
},
{
"id": "af8932a6-a2c6-4362-6292-08dc4c2e6b07",
"alias": "Rajas con queso",
"description": "",
"icon": "",
"price": "79"
}
]
}
]
},
{
"id": "6486d68c-a603-469b-8c42-08dc4c2e6a7b",
"alias": "Molletes",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "9816658b-a461-4f22-489d-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "22d18fff-2ea3-4f0e-6293-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "149"
}
]
}
]
}
]
},
{
"id": "614625f0-be2b-4918-53bf-08dc4c2e6a08",
"name": "Entradas",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "2de30ad7-2cdc-4861-8c43-08dc4c2e6a7b",
"alias": "Frijoles Puercos",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "9cbe068a-0797-4175-489e-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "98108687-d4e9-4769-6294-08dc4c2e6b07",
"alias": "Molcajete",
"description": "",
"icon": "",
"price": "149"
}
]
}
]
},
{
"id": "396e7388-c10a-4231-8c44-08dc4c2e6a7b",
"alias": "Queso Fundido",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "24c4440c-2a62-4131-489f-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "8cc0d197-c77f-49be-6295-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "239"
}
]
}
]
},
{
"id": "2828d0c3-c7d6-4c3e-8c45-08dc4c2e6a7b",
"alias": "Guacamole",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "88922508-4634-46d2-48a0-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "f5bc1f9a-1060-44a8-6296-08dc4c2e6b07",
"alias": "Molcajete",
"description": "",
"icon": "",
"price": "179"
}
]
}
]
}
]
},
{
"id": "9b11daf6-ed6f-48c2-53c0-08dc4c2e6a08",
"name": "El Sabor De Sinaloa",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "bdcf6cc3-4243-420d-8c46-08dc4c2e6a7b",
"alias": "Asado Mazatleco",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "181f19f2-054e-4872-48a1-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "56ab30df-0cbc-4681-6297-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "169"
}
]
}
]
},
{
"id": "f2c3fc7a-ce7f-4933-8c47-08dc4c2e6a7b",
"alias": "Chilorio(el original)",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "352964c2-fc05-4709-48a2-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "fb4fd167-3914-4d12-6298-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "264"
}
]
}
]
},
{
"id": "632ae147-426e-4748-8c48-08dc4c2e6a7b",
"alias": "Machaca",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "1280400a-9c38-4f8a-48a3-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "d4f8a84f-21e5-4a7b-6299-08dc4c2e6b07",
"alias": "Estilo Sinaloa",
"description": "",
"icon": "",
"price": "269"
},
{
"id": "23555219-a797-4b62-629a-08dc4c2e6b07",
"alias": "Ranchera",
"description": "",
"icon": "",
"price": "269"
}
]
}
]
}
]
},
{
"id": "14d7092b-ba85-485b-53c1-08dc4c2e6a08",
"name": "Enchiladas",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "50f5627e-15e7-4a0e-8c49-08dc4c2e6a7b",
"alias": "Las Tradicionales",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "580a36ed-6e39-4c18-48a4-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "4a62717e-db04-46c3-629b-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "216"
}
]
}
]
},
{
"id": "d43873f3-64d4-49ab-8c4a-08dc4c2e6a7b",
"alias": "Suizas",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "4b2ba00b-a8d8-42b0-48a5-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "b01655aa-a949-42fe-629c-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "239"
}
]
}
]
},
{
"id": "6d75fb7b-7130-4012-8c4b-08dc4c2e6a7b",
"alias": "Crema Poblana",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "8d06681f-1a4d-4bc0-48a6-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "b72c9474-4a9b-4001-629d-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "239"
}
]
}
]
},
{
"id": "25e5b1a3-5ed8-4563-8c4c-08dc4c2e6a7b",
"alias": "Entomatadas",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "cc18e0c2-ca07-4a09-48a7-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "27a8d429-8738-43c6-629e-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "216"
}
]
}
]
},
{
"id": "e6cff106-2f96-428a-8c4d-08dc4c2e6a7b",
"alias": "Salseadas en Chipotle",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "a04ac292-edcf-4b71-48a8-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "3329000e-1a9a-419e-629f-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "239"
}
]
}
]
},
{
"id": "fd39a2f5-ef21-49d8-8c4e-08dc4c2e6a7b",
"alias": "Mole Negro 100% Oaxaqueño",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "cd32d5ea-8ae5-4536-48a9-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "71086cdd-b41c-4ff6-62a0-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "216"
}
]
}
]
},
{
"id": "62b8068a-d940-4a0c-8c4f-08dc4c2e6a7b",
"alias": "Combinacion Mexicana",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "decd6a50-9a77-4675-48aa-08dc4c2e6ac5",
"alias": "3 opciones a Escoger",
"description": "",
"icon": "",
"modifiers": [
{
"id": "5cb18556-31d1-425d-62a1-08dc4c2e6b07",
"alias": "Sope",
"description": "",
"icon": "",
"price": "239"
},
{
"id": "3f26ee44-2450-43ff-62a2-08dc4c2e6b07",
"alias": "Tostada",
"description": "",
"icon": "",
"price": "-1"
},
{
"id": "139e6758-95a0-47a0-62a3-08dc4c2e6b07",
"alias": "Tamal",
"description": "",
"icon": "",
"price": "-1"
},
{
"id": "d1c69cf7-647d-4eb0-62a4-08dc4c2e6b07",
"alias": "Enchilada",
"description": "",
"icon": "",
"price": "-1"
}
]
}
]
}
]
}
]
},
{
"id": "d264f642-a525-4558-7ac8-08dc4c69fa46",
"name": "Cocina Mexicana",
"description": "",
"icon": "",
"categories": [
{
"id": "cda8130b-9109-472d-1f84-08dc4c69fbfc",
"name": "Caldos",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "ef054b41-ae9d-4abe-b3b3-08dc4c69fc4d",
"alias": "Consome",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "6220144b-06fc-4ac3-289d-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "ec05bef9-4b1f-4072-2abd-08dc4c69fcf5",
"alias": "Chico",
"description": "",
"icon": "",
"price": "59"
},
{
"id": "e53c19a2-834d-4d94-2abe-08dc4c69fcf5",
"alias": "Grande",
"description": "",
"icon": "",
"price": "79"
}
]
}
]
},
{
"id": "71bdab9c-9845-48c2-b3b4-08dc4c69fc4d",
"alias": "Pollo",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "eedbb1fd-312e-403f-289e-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "ab034180-0d9d-4fc9-2abf-08dc4c69fcf5",
"alias": "Chico",
"description": "",
"icon": "",
"price": "189"
},
{
"id": "4100967f-0225-4736-2ac0-08dc4c69fcf5",
"alias": "Grande",
"description": "",
"icon": "",
"price": "216"
}
]
}
]
},
{
"id": "3b4d2d05-208d-43a1-b3b5-08dc4c69fc4d",
"alias": "Res",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "5bb867f4-a707-4cd5-289f-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "676a7fd2-b39d-4ead-2ac1-08dc4c69fcf5",
"alias": "Chico",
"description": "",
"icon": "",
"price": "189"
},
{
"id": "34027c89-e279-4814-2ac2-08dc4c69fcf5",
"alias": "Grande",
"description": "",
"icon": "",
"price": "259"
}
]
}
]
},
{
"id": "6d74d78b-399f-4b41-b3b6-08dc4c69fc4d",
"alias": "Tlalpeño",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "bbba0522-e0a7-4e2f-28a0-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "de92bc17-dacf-458d-2ac3-08dc4c69fcf5",
"alias": "Chico",
"description": "",
"icon": "",
"price": "199"
},
{
"id": "d0d1943e-17ff-471a-2ac4-08dc4c69fcf5",
"alias": "Grande",
"description": "",
"icon": "",
"price": "259"
}
]
}
]
}
]
},
{
"id": "ebf0e9ca-9e9e-4df1-1f85-08dc4c69fbfc",
"name": "Antojitos",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "ad52e58a-7be8-4d7e-b3b7-08dc4c69fc4d",
"alias": "Tacos Dorados",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "ce69521a-3e4d-4feb-28a1-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "54776a09-9c54-4317-2ac5-08dc4c69fcf5",
"alias": "3 pzs",
"description": "",
"icon": "",
"price": "189"
}
]
}
]
},
{
"id": "bd843b8b-353a-4e10-b3b8-08dc4c69fc4d",
"alias": "Tostadas",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "0c14afd5-c181-4d7b-28a2-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "abf7e795-e1ae-4b23-2ac6-08dc4c69fcf5",
"alias": "3 pzs",
"description": "",
"icon": "",
"price": "209"
}
]
}
]
},
{
"id": "1a3eef5b-40c9-4270-b3b9-08dc4c69fc4d",
"alias": "Sopes",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "2c487e5a-f022-4f10-28a3-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "e24934f3-41d5-485f-2ac7-08dc4c69fcf5",
"alias": "3 pzs",
"description": "",
"icon": "",
"price": "204"
}
]
}
]
},
{
"id": "1d91d394-ef84-43e6-b3ba-08dc4c69fc4d",
"alias": "Flautas",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "a5446316-fd92-4019-28a4-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "04ed1928-6abf-486e-2ac8-08dc4c69fcf5",
"alias": "3 pzs",
"description": "",
"icon": "",
"price": "209"
},
{
"id": "350de3a3-3840-41a5-2ac9-08dc4c69fcf5",
"alias": "4 pzs",
"description": "",
"icon": "",
"price": "229"
}
]
}
]
}
]
},
{
"id": "acb94f3f-a02d-477f-1f86-08dc4c69fbfc",
"name": "Platillos Tipicos",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "e352bc63-5576-40b3-b3bb-08dc4c69fc4d",
"alias": "Bistec Ranchero",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "1c356021-9fdc-4bc4-28a5-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "474e3cf6-17ea-4774-2aca-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "169"
}
]
}
]
},
{
"id": "782a3708-413c-4f1b-b3bc-08dc4c69fc4d",
"alias": "Milanesa(200gr)",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "3ef89dc5-4cec-4a1d-28a6-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "7c64f3a6-50c1-4696-2acb-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "259"
}
]
}
]
},
{
"id": "5eeda395-c136-413d-b3bd-08dc4c69fc4d",
"alias": "Chiles Rellenos",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "201af361-4b2a-4d53-28a7-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "99192409-278f-49e4-2acc-08dc4c69fcf5",
"alias": "2 pzs",
"description": "",
"icon": "",
"price": "249"
}
]
}
]
},
{
"id": "21fb6283-0f2e-4407-b3be-08dc4c69fc4d",
"alias": "Pechuga en Mole Negro 100% Oaxaqueño",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "c3b3bba7-3e06-49e8-28a8-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "b52c8ebf-013a-4e17-2acd-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "254"
}
]
}
]
},
{
"id": "6a527805-0674-46f6-b3bf-08dc4c69fc4d",
"alias": "Tamales",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "86741319-5544-453b-28a9-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "6e4950b7-27a9-42cf-2ace-08dc4c69fcf5",
"alias": "Res",
"description": "",
"icon": "",
"price": "79"
},
{
"id": "0485e058-2083-42de-2acf-08dc4c69fcf5",
"alias": "Piña",
"description": "",
"icon": "",
"price": "79"
},
{
"id": "838f1e7e-897d-477c-2ad0-08dc4c69fcf5",
"alias": "Rajas con queso",
"description": "",
"icon": "",
"price": "79"
}
]
}
]
},
{
"id": "19415de3-6326-4936-b3c0-08dc4c69fc4d",
"alias": "Molletes",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "79ccc961-1d61-4422-28aa-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "8989a19a-4427-40dd-2ad1-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "149"
}
]
}
]
}
]
},
{
"id": "fbb3f83e-d48e-4e53-1f87-08dc4c69fbfc",
"name": "Entradas",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "6bf478c2-bb48-4aeb-b3c1-08dc4c69fc4d",
"alias": "Frijoles Puercos",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "49676f51-dadf-4f58-28ab-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "fcb7283f-d729-4ef1-2ad2-08dc4c69fcf5",
"alias": "Molcajete",
"description": "",
"icon": "",
"price": "149"
}
]
}
]
},
{
"id": "dc22a796-5470-41b1-b3c2-08dc4c69fc4d",
"alias": "Queso Fundido",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "7e2c9bd2-4031-4768-28ac-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "02f34239-0ce7-42f8-2ad3-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "239"
}
]
}
]
},
{
"id": "ad10ebf0-bf2b-477c-b3c3-08dc4c69fc4d",
"alias": "Guacamole",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "65913b03-82d1-4476-28ad-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "aa86155c-7ccc-4e7e-2ad4-08dc4c69fcf5",
"alias": "Molcajete",
"description": "",
"icon": "",
"price": "179"
}
]
}
]
}
]
},
{
"id": "a2d1d604-63a9-4d1c-1f88-08dc4c69fbfc",
"name": "El Sabor De Sinaloa",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "cf8c93a2-8716-4701-b3c4-08dc4c69fc4d",
"alias": "Asado Mazatleco",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "9ecb3e49-f55c-409b-28ae-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "b4a0cd1e-230b-4bf0-2ad5-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "169"
}
]
}
]
},
{
"id": "f8c4b2e0-c8a3-41c1-b3c5-08dc4c69fc4d",
"alias": "Chilorio(el original)",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "6e3a7788-6338-4b92-28af-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "b858012c-6b93-4d9e-2ad6-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "264"
}
]
}
]
},
{
"id": "ab1ccdbe-247a-4409-b3c6-08dc4c69fc4d",
"alias": "Machaca",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "ccace020-f7d6-4240-28b0-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "175cbffa-4176-495f-2ad7-08dc4c69fcf5",
"alias": "Estilo Sinaloa",
"description": "",
"icon": "",
"price": "269"
},
{
"id": "d8e7e3cd-c60b-42be-2ad8-08dc4c69fcf5",
"alias": "Ranchera",
"description": "",
"icon": "",
"price": "269"
}
]
}
]
}
]
},
{
"id": "7c521a4e-9386-4999-1f89-08dc4c69fbfc",
"name": "Enchiladas",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "52715b92-7bc2-4a80-b3c7-08dc4c69fc4d",
"alias": "Las Tradicionales",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "33025250-0462-4660-28b1-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "7a1c7f7f-c6d5-485f-2ad9-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "216"
}
]
}
]
},
{
"id": "38e8b59e-af2b-4238-b3c8-08dc4c69fc4d",
"alias": "Suizas",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "9ddb2e0a-411c-46c8-28b2-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "bd88f87a-1278-4771-2ada-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "239"
}
]
}
]
},
{
"id": "eb0c88c3-9aef-4440-b3c9-08dc4c69fc4d",
"alias": "Crema Poblana",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "446c15fa-972f-4ff3-28b3-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "5a1665f0-38c7-4e0a-2adb-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "239"
}
]
}
]
},
{
"id": "e3919ff0-eedb-47c8-b3ca-08dc4c69fc4d",
"alias": "Entomatadas",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "e5f855a7-957e-4e75-28b4-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "e9f7de64-5dea-4774-2adc-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "216"
}
]
}
]
},
{
"id": "95358274-cb84-4c27-b3cb-08dc4c69fc4d",
"alias": "Salseadas en Chipotle",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "afd40348-8687-4832-28b5-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "c76c409e-77d4-4298-2add-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "239"
}
]
}
]
},
{
"id": "cdb2ec61-1cf5-4447-b3cc-08dc4c69fc4d",
"alias": "Mole Negro 100% Oaxaqueño",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "ed35cff7-bbeb-4de7-28b6-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "1951c785-35fc-4f95-2ade-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "216"
}
]
}
]
},
{
"id": "f140ba8c-4fbe-4b53-b3cd-08dc4c69fc4d",
"alias": "Combinacion Mexicana",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "d91a8a39-3de5-4259-28b7-08dc4c69fcbd",
"alias": "3 opciones a Escoger",
"description": "",
"icon": "",
"modifiers": [
{
"id": "c3ecd846-17ce-4442-2adf-08dc4c69fcf5",
"alias": "Sope",
"description": "",
"icon": "",
"price": "239"
},
{
"id": "4f8ead4f-80dc-43cd-2ae0-08dc4c69fcf5",
"alias": "Tostada",
"description": "",
"icon": "",
"price": "-1"
},
{
"id": "0b3a482d-fc4c-4a1d-2ae1-08dc4c69fcf5",
"alias": "Tamal",
"description": "",
"icon": "",
"price": "-1"
},
{
"id": "ab028f5e-1e80-4dbd-2ae2-08dc4c69fcf5",
"alias": "Enchilada",
"description": "",
"icon": "",
"price": "-1"
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

 */



/*

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

    /*

      "brandId": "e9836589-f766-4bc0-ed86-08dc4ba99b9c",
  "branchId": "84e2c10c-918b-4fd4-45ed-08dc4ba99bbb",
  "brandName": "Frutería La Única",
  "branchName": "Río",
  "instagramLink": "https://www.instagram.com/fruterialaunica/",
  "facebookLink": "https://www.facebook.com/fruterialaunicario/",
  "websiteLink": "https://www.fruterialaunica.com.mx/",
  "brandLogo": "",
  "brandSlogan": "Únicamente La Mejor",
  "menuBackground": "https://i0.wp.com/foodandpleasure.com/wp-content/uploads/2022/08/drinks-en-monterrey-terraza-coss.jpeg?fit=1080%2C1350&ssl=1",



     */

    // JSON como un String. Reemplaza este string con tu JSON real
    String jsonString = '''
{
"brandId": "e9836589-f766-4bc0-ed86-08dc4ba99b9c",
"branchId": "84e2c10c-918b-4fd4-45ed-08dc4ba99bbb",
"brandName": "Frutería La Única",
"branchName": "Río",
"instagramLink": "https://www.instagram.com/fruterialaunica/",
"facebookLink": "https://www.facebook.com/fruterialaunicario/",
"websiteLink": "https://www.fruterialaunica.com.mx/",
"brandLogo": "",
"brandSlogan": "Únicamente La Mejor",
"menuBackground": "http://localhost:5215/brands/0a46d3e4-4988-4042-83ea-e19e165f7fde.jpg",
"catalogs": [
{
"id": "a25ee89d-f3a5-464c-900c-08dc4c2e69d8",
"name": "Cocina Mexicana",
"description": "",
"icon": "",
"categories": [
{
"id": "ffc82fff-05ca-48e8-53bc-08dc4c2e6a08",
"name": "Caldos",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "7d6dcc8f-4c78-4264-8c35-08dc4c2e6a7b",
"alias": "Consome",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "48590823-f561-4995-4890-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "2c44393d-90a3-49c0-627f-08dc4c2e6b07",
"alias": "Chico",
"description": "",
"icon": "",
"price": "59"
},
{
"id": "3f91b804-b848-4fa8-6280-08dc4c2e6b07",
"alias": "Grande",
"description": "",
"icon": "",
"price": "79"
}
]
}
]
},
{
"id": "d52ec4f8-5dd8-4780-8c36-08dc4c2e6a7b",
"alias": "Pollo",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "0ab12a9e-a521-457c-4891-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "9a8c867e-d995-4a25-6281-08dc4c2e6b07",
"alias": "Chico",
"description": "",
"icon": "",
"price": "189"
},
{
"id": "1617f4ab-cf42-4d3a-6282-08dc4c2e6b07",
"alias": "Grande",
"description": "",
"icon": "",
"price": "216"
}
]
}
]
},
{
"id": "acc41378-6183-42d8-8c37-08dc4c2e6a7b",
"alias": "Res",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "7e347f20-b846-45b2-4892-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "bab91337-386a-46ba-6283-08dc4c2e6b07",
"alias": "Chico",
"description": "",
"icon": "",
"price": "189"
},
{
"id": "624f8e3d-5048-4500-6284-08dc4c2e6b07",
"alias": "Grande",
"description": "",
"icon": "",
"price": "259"
}
]
}
]
},
{
"id": "f57b5ec5-a289-4019-8c38-08dc4c2e6a7b",
"alias": "Tlalpeño",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "0869175a-8158-4829-4893-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "4a5b2e0c-f300-493d-6285-08dc4c2e6b07",
"alias": "Chico",
"description": "",
"icon": "",
"price": "199"
},
{
"id": "41c86164-dab2-4bf9-6286-08dc4c2e6b07",
"alias": "Grande",
"description": "",
"icon": "",
"price": "259"
}
]
}
]
}
]
},
{
"id": "001ec7db-6eb6-4415-53bd-08dc4c2e6a08",
"name": "Antojitos",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "bd587821-b384-4607-8c39-08dc4c2e6a7b",
"alias": "Tacos Dorados",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "6b2cb16e-1d8b-4c45-4894-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "4bf8f31d-fbfe-4e8e-6287-08dc4c2e6b07",
"alias": "3 pzs",
"description": "",
"icon": "",
"price": "189"
}
]
}
]
},
{
"id": "7b1d7227-0cc2-4703-8c3a-08dc4c2e6a7b",
"alias": "Tostadas",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "785f5b11-37e9-4f6a-4895-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "3b03c998-e1d4-420b-6288-08dc4c2e6b07",
"alias": "3 pzs",
"description": "",
"icon": "",
"price": "209"
}
]
}
]
},
{
"id": "6f6138cf-ea1d-4033-8c3b-08dc4c2e6a7b",
"alias": "Sopes",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "bf845167-e482-402e-4896-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "4147ab6f-d13c-46af-6289-08dc4c2e6b07",
"alias": "3 pzs",
"description": "",
"icon": "",
"price": "204"
}
]
}
]
},
{
"id": "e2e57e0c-56cb-4d7b-8c3c-08dc4c2e6a7b",
"alias": "Flautas",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "74e68cb0-f379-4470-4897-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "e90a1887-c696-4dcd-628a-08dc4c2e6b07",
"alias": "3 pzs",
"description": "",
"icon": "",
"price": "209"
},
{
"id": "beac2a5e-dbe8-41ab-628b-08dc4c2e6b07",
"alias": "4 pzs",
"description": "",
"icon": "",
"price": "229"
}
]
}
]
}
]
},
{
"id": "5ba76bba-c090-44c2-53be-08dc4c2e6a08",
"name": "Platillos Tipicos",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "10c02cdf-77d8-4feb-8c3d-08dc4c2e6a7b",
"alias": "Bistec Ranchero",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "2ef2ba67-e99c-4de2-4898-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "165922e6-7fae-4642-628c-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "169"
}
]
}
]
},
{
"id": "e7cb0111-7013-4f99-8c3e-08dc4c2e6a7b",
"alias": "Milanesa(200gr)",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "271ffd40-4c7b-452b-4899-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "1bc9e8e3-56dd-48cf-628d-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "259"
}
]
}
]
},
{
"id": "e4b75fe2-ef4b-451d-8c3f-08dc4c2e6a7b",
"alias": "Chiles Rellenos",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "e2603f34-d2c4-4b0b-489a-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "0b39cadf-681e-4a19-628e-08dc4c2e6b07",
"alias": "2 pzs",
"description": "",
"icon": "",
"price": "249"
}
]
}
]
},
{
"id": "071d15c1-b79d-4ed1-8c40-08dc4c2e6a7b",
"alias": "Pechuga en Mole Negro 100% Oaxaqueño",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "f4d85671-5bd7-4628-489b-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "8e3a7790-7366-4d3b-628f-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "254"
}
]
}
]
},
{
"id": "ab90fd60-3655-488f-8c41-08dc4c2e6a7b",
"alias": "Tamales",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "24e36900-cf62-49e3-489c-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "89640629-d526-4610-6290-08dc4c2e6b07",
"alias": "Res",
"description": "",
"icon": "",
"price": "79"
},
{
"id": "dd5f7019-359d-498a-6291-08dc4c2e6b07",
"alias": "Piña",
"description": "",
"icon": "",
"price": "79"
},
{
"id": "af8932a6-a2c6-4362-6292-08dc4c2e6b07",
"alias": "Rajas con queso",
"description": "",
"icon": "",
"price": "79"
}
]
}
]
},
{
"id": "6486d68c-a603-469b-8c42-08dc4c2e6a7b",
"alias": "Molletes",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "9816658b-a461-4f22-489d-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "22d18fff-2ea3-4f0e-6293-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "149"
}
]
}
]
}
]
},
{
"id": "614625f0-be2b-4918-53bf-08dc4c2e6a08",
"name": "Entradas",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "2de30ad7-2cdc-4861-8c43-08dc4c2e6a7b",
"alias": "Frijoles Puercos",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "9cbe068a-0797-4175-489e-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "98108687-d4e9-4769-6294-08dc4c2e6b07",
"alias": "Molcajete",
"description": "",
"icon": "",
"price": "149"
}
]
}
]
},
{
"id": "396e7388-c10a-4231-8c44-08dc4c2e6a7b",
"alias": "Queso Fundido",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "24c4440c-2a62-4131-489f-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "8cc0d197-c77f-49be-6295-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "239"
}
]
}
]
},
{
"id": "2828d0c3-c7d6-4c3e-8c45-08dc4c2e6a7b",
"alias": "Guacamole",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "88922508-4634-46d2-48a0-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "f5bc1f9a-1060-44a8-6296-08dc4c2e6b07",
"alias": "Molcajete",
"description": "",
"icon": "",
"price": "179"
}
]
}
]
}
]
},
{
"id": "9b11daf6-ed6f-48c2-53c0-08dc4c2e6a08",
"name": "El Sabor De Sinaloa",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "bdcf6cc3-4243-420d-8c46-08dc4c2e6a7b",
"alias": "Asado Mazatleco",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "181f19f2-054e-4872-48a1-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "56ab30df-0cbc-4681-6297-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "169"
}
]
}
]
},
{
"id": "f2c3fc7a-ce7f-4933-8c47-08dc4c2e6a7b",
"alias": "Chilorio(el original)",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "352964c2-fc05-4709-48a2-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "fb4fd167-3914-4d12-6298-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "264"
}
]
}
]
},
{
"id": "632ae147-426e-4748-8c48-08dc4c2e6a7b",
"alias": "Machaca",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "1280400a-9c38-4f8a-48a3-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "d4f8a84f-21e5-4a7b-6299-08dc4c2e6b07",
"alias": "Estilo Sinaloa",
"description": "",
"icon": "",
"price": "269"
},
{
"id": "23555219-a797-4b62-629a-08dc4c2e6b07",
"alias": "Ranchera",
"description": "",
"icon": "",
"price": "269"
}
]
}
]
}
]
},
{
"id": "14d7092b-ba85-485b-53c1-08dc4c2e6a08",
"name": "Enchiladas",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "50f5627e-15e7-4a0e-8c49-08dc4c2e6a7b",
"alias": "Las Tradicionales",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "580a36ed-6e39-4c18-48a4-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "4a62717e-db04-46c3-629b-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "216"
}
]
}
]
},
{
"id": "d43873f3-64d4-49ab-8c4a-08dc4c2e6a7b",
"alias": "Suizas",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "4b2ba00b-a8d8-42b0-48a5-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "b01655aa-a949-42fe-629c-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "239"
}
]
}
]
},
{
"id": "6d75fb7b-7130-4012-8c4b-08dc4c2e6a7b",
"alias": "Crema Poblana",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "8d06681f-1a4d-4bc0-48a6-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "b72c9474-4a9b-4001-629d-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "239"
}
]
}
]
},
{
"id": "25e5b1a3-5ed8-4563-8c4c-08dc4c2e6a7b",
"alias": "Entomatadas",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "cc18e0c2-ca07-4a09-48a7-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "27a8d429-8738-43c6-629e-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "216"
}
]
}
]
},
{
"id": "e6cff106-2f96-428a-8c4d-08dc4c2e6a7b",
"alias": "Salseadas en Chipotle",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "a04ac292-edcf-4b71-48a8-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "3329000e-1a9a-419e-629f-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "239"
}
]
}
]
},
{
"id": "fd39a2f5-ef21-49d8-8c4e-08dc4c2e6a7b",
"alias": "Mole Negro 100% Oaxaqueño",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "cd32d5ea-8ae5-4536-48a9-08dc4c2e6ac5",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "71086cdd-b41c-4ff6-62a0-08dc4c2e6b07",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "216"
}
]
}
]
},
{
"id": "62b8068a-d940-4a0c-8c4f-08dc4c2e6a7b",
"alias": "Combinacion Mexicana",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "decd6a50-9a77-4675-48aa-08dc4c2e6ac5",
"alias": "3 opciones a Escoger",
"description": "",
"icon": "",
"modifiers": [
{
"id": "5cb18556-31d1-425d-62a1-08dc4c2e6b07",
"alias": "Sope",
"description": "",
"icon": "",
"price": "239"
},
{
"id": "3f26ee44-2450-43ff-62a2-08dc4c2e6b07",
"alias": "Tostada",
"description": "",
"icon": "",
"price": "-1"
},
{
"id": "139e6758-95a0-47a0-62a3-08dc4c2e6b07",
"alias": "Tamal",
"description": "",
"icon": "",
"price": "-1"
},
{
"id": "d1c69cf7-647d-4eb0-62a4-08dc4c2e6b07",
"alias": "Enchilada",
"description": "",
"icon": "",
"price": "-1"
}
]
}
]
}
]
}
]
},
{
"id": "d264f642-a525-4558-7ac8-08dc4c69fa46",
"name": "Cocina Mexicana",
"description": "",
"icon": "",
"categories": [
{
"id": "cda8130b-9109-472d-1f84-08dc4c69fbfc",
"name": "Caldos",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "ef054b41-ae9d-4abe-b3b3-08dc4c69fc4d",
"alias": "Consome",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "6220144b-06fc-4ac3-289d-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "ec05bef9-4b1f-4072-2abd-08dc4c69fcf5",
"alias": "Chico",
"description": "",
"icon": "",
"price": "59"
},
{
"id": "e53c19a2-834d-4d94-2abe-08dc4c69fcf5",
"alias": "Grande",
"description": "",
"icon": "",
"price": "79"
}
]
}
]
},
{
"id": "71bdab9c-9845-48c2-b3b4-08dc4c69fc4d",
"alias": "Pollo",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "eedbb1fd-312e-403f-289e-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "ab034180-0d9d-4fc9-2abf-08dc4c69fcf5",
"alias": "Chico",
"description": "",
"icon": "",
"price": "189"
},
{
"id": "4100967f-0225-4736-2ac0-08dc4c69fcf5",
"alias": "Grande",
"description": "",
"icon": "",
"price": "216"
}
]
}
]
},
{
"id": "3b4d2d05-208d-43a1-b3b5-08dc4c69fc4d",
"alias": "Res",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "5bb867f4-a707-4cd5-289f-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "676a7fd2-b39d-4ead-2ac1-08dc4c69fcf5",
"alias": "Chico",
"description": "",
"icon": "",
"price": "189"
},
{
"id": "34027c89-e279-4814-2ac2-08dc4c69fcf5",
"alias": "Grande",
"description": "",
"icon": "",
"price": "259"
}
]
}
]
},
{
"id": "6d74d78b-399f-4b41-b3b6-08dc4c69fc4d",
"alias": "Tlalpeño",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "bbba0522-e0a7-4e2f-28a0-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "de92bc17-dacf-458d-2ac3-08dc4c69fcf5",
"alias": "Chico",
"description": "",
"icon": "",
"price": "199"
},
{
"id": "d0d1943e-17ff-471a-2ac4-08dc4c69fcf5",
"alias": "Grande",
"description": "",
"icon": "",
"price": "259"
}
]
}
]
}
]
},
{
"id": "ebf0e9ca-9e9e-4df1-1f85-08dc4c69fbfc",
"name": "Antojitos",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "ad52e58a-7be8-4d7e-b3b7-08dc4c69fc4d",
"alias": "Tacos Dorados",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "ce69521a-3e4d-4feb-28a1-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "54776a09-9c54-4317-2ac5-08dc4c69fcf5",
"alias": "3 pzs",
"description": "",
"icon": "",
"price": "189"
}
]
}
]
},
{
"id": "bd843b8b-353a-4e10-b3b8-08dc4c69fc4d",
"alias": "Tostadas",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "0c14afd5-c181-4d7b-28a2-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "abf7e795-e1ae-4b23-2ac6-08dc4c69fcf5",
"alias": "3 pzs",
"description": "",
"icon": "",
"price": "209"
}
]
}
]
},
{
"id": "1a3eef5b-40c9-4270-b3b9-08dc4c69fc4d",
"alias": "Sopes",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "2c487e5a-f022-4f10-28a3-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "e24934f3-41d5-485f-2ac7-08dc4c69fcf5",
"alias": "3 pzs",
"description": "",
"icon": "",
"price": "204"
}
]
}
]
},
{
"id": "1d91d394-ef84-43e6-b3ba-08dc4c69fc4d",
"alias": "Flautas",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "a5446316-fd92-4019-28a4-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "04ed1928-6abf-486e-2ac8-08dc4c69fcf5",
"alias": "3 pzs",
"description": "",
"icon": "",
"price": "209"
},
{
"id": "350de3a3-3840-41a5-2ac9-08dc4c69fcf5",
"alias": "4 pzs",
"description": "",
"icon": "",
"price": "229"
}
]
}
]
}
]
},
{
"id": "acb94f3f-a02d-477f-1f86-08dc4c69fbfc",
"name": "Platillos Tipicos",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "e352bc63-5576-40b3-b3bb-08dc4c69fc4d",
"alias": "Bistec Ranchero",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "1c356021-9fdc-4bc4-28a5-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "474e3cf6-17ea-4774-2aca-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "169"
}
]
}
]
},
{
"id": "782a3708-413c-4f1b-b3bc-08dc4c69fc4d",
"alias": "Milanesa(200gr)",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "3ef89dc5-4cec-4a1d-28a6-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "7c64f3a6-50c1-4696-2acb-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "259"
}
]
}
]
},
{
"id": "5eeda395-c136-413d-b3bd-08dc4c69fc4d",
"alias": "Chiles Rellenos",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "201af361-4b2a-4d53-28a7-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "99192409-278f-49e4-2acc-08dc4c69fcf5",
"alias": "2 pzs",
"description": "",
"icon": "",
"price": "249"
}
]
}
]
},
{
"id": "21fb6283-0f2e-4407-b3be-08dc4c69fc4d",
"alias": "Pechuga en Mole Negro 100% Oaxaqueño",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "c3b3bba7-3e06-49e8-28a8-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "b52c8ebf-013a-4e17-2acd-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "254"
}
]
}
]
},
{
"id": "6a527805-0674-46f6-b3bf-08dc4c69fc4d",
"alias": "Tamales",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "86741319-5544-453b-28a9-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "6e4950b7-27a9-42cf-2ace-08dc4c69fcf5",
"alias": "Res",
"description": "",
"icon": "",
"price": "79"
},
{
"id": "0485e058-2083-42de-2acf-08dc4c69fcf5",
"alias": "Piña",
"description": "",
"icon": "",
"price": "79"
},
{
"id": "838f1e7e-897d-477c-2ad0-08dc4c69fcf5",
"alias": "Rajas con queso",
"description": "",
"icon": "",
"price": "79"
}
]
}
]
},
{
"id": "19415de3-6326-4936-b3c0-08dc4c69fc4d",
"alias": "Molletes",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "79ccc961-1d61-4422-28aa-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "8989a19a-4427-40dd-2ad1-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "149"
}
]
}
]
}
]
},
{
"id": "fbb3f83e-d48e-4e53-1f87-08dc4c69fbfc",
"name": "Entradas",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "6bf478c2-bb48-4aeb-b3c1-08dc4c69fc4d",
"alias": "Frijoles Puercos",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "49676f51-dadf-4f58-28ab-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "fcb7283f-d729-4ef1-2ad2-08dc4c69fcf5",
"alias": "Molcajete",
"description": "",
"icon": "",
"price": "149"
}
]
}
]
},
{
"id": "dc22a796-5470-41b1-b3c2-08dc4c69fc4d",
"alias": "Queso Fundido",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "7e2c9bd2-4031-4768-28ac-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "02f34239-0ce7-42f8-2ad3-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "239"
}
]
}
]
},
{
"id": "ad10ebf0-bf2b-477c-b3c3-08dc4c69fc4d",
"alias": "Guacamole",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "65913b03-82d1-4476-28ad-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "aa86155c-7ccc-4e7e-2ad4-08dc4c69fcf5",
"alias": "Molcajete",
"description": "",
"icon": "",
"price": "179"
}
]
}
]
}
]
},
{
"id": "a2d1d604-63a9-4d1c-1f88-08dc4c69fbfc",
"name": "El Sabor De Sinaloa",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "cf8c93a2-8716-4701-b3c4-08dc4c69fc4d",
"alias": "Asado Mazatleco",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "9ecb3e49-f55c-409b-28ae-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "b4a0cd1e-230b-4bf0-2ad5-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "169"
}
]
}
]
},
{
"id": "f8c4b2e0-c8a3-41c1-b3c5-08dc4c69fc4d",
"alias": "Chilorio(el original)",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "6e3a7788-6338-4b92-28af-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "b858012c-6b93-4d9e-2ad6-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "264"
}
]
}
]
},
{
"id": "ab1ccdbe-247a-4409-b3c6-08dc4c69fc4d",
"alias": "Machaca",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "ccace020-f7d6-4240-28b0-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "175cbffa-4176-495f-2ad7-08dc4c69fcf5",
"alias": "Estilo Sinaloa",
"description": "",
"icon": "",
"price": "269"
},
{
"id": "d8e7e3cd-c60b-42be-2ad8-08dc4c69fcf5",
"alias": "Ranchera",
"description": "",
"icon": "",
"price": "269"
}
]
}
]
}
]
},
{
"id": "7c521a4e-9386-4999-1f89-08dc4c69fbfc",
"name": "Enchiladas",
"description": "",
"icon": "",
"items": [],
"products": [
{
"id": "52715b92-7bc2-4a80-b3c7-08dc4c69fc4d",
"alias": "Las Tradicionales",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "33025250-0462-4660-28b1-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "7a1c7f7f-c6d5-485f-2ad9-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "216"
}
]
}
]
},
{
"id": "38e8b59e-af2b-4238-b3c8-08dc4c69fc4d",
"alias": "Suizas",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "9ddb2e0a-411c-46c8-28b2-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "bd88f87a-1278-4771-2ada-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "239"
}
]
}
]
},
{
"id": "eb0c88c3-9aef-4440-b3c9-08dc4c69fc4d",
"alias": "Crema Poblana",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "446c15fa-972f-4ff3-28b3-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "5a1665f0-38c7-4e0a-2adb-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "239"
}
]
}
]
},
{
"id": "e3919ff0-eedb-47c8-b3ca-08dc4c69fc4d",
"alias": "Entomatadas",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "e5f855a7-957e-4e75-28b4-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "e9f7de64-5dea-4774-2adc-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "216"
}
]
}
]
},
{
"id": "95358274-cb84-4c27-b3cb-08dc4c69fc4d",
"alias": "Salseadas en Chipotle",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "afd40348-8687-4832-28b5-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "c76c409e-77d4-4298-2add-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "239"
}
]
}
]
},
{
"id": "cdb2ec61-1cf5-4447-b3cc-08dc4c69fc4d",
"alias": "Mole Negro 100% Oaxaqueño",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "ed35cff7-bbeb-4de7-28b6-08dc4c69fcbd",
"alias": "Presentacion",
"description": "",
"icon": "",
"modifiers": [
{
"id": "1951c785-35fc-4f95-2ade-08dc4c69fcf5",
"alias": "Platillo",
"description": "",
"icon": "",
"price": "216"
}
]
}
]
},
{
"id": "f140ba8c-4fbe-4b53-b3cd-08dc4c69fc4d",
"alias": "Combinacion Mexicana",
"description": "",
"icon": "",
"modifiersGroups": [
{
"id": "d91a8a39-3de5-4259-28b7-08dc4c69fcbd",
"alias": "3 opciones a Escoger",
"description": "",
"icon": "",
"modifiers": [
{
"id": "c3ecd846-17ce-4442-2adf-08dc4c69fcf5",
"alias": "Sope",
"description": "",
"icon": "",
"price": "239"
},
{
"id": "4f8ead4f-80dc-43cd-2ae0-08dc4c69fcf5",
"alias": "Tostada",
"description": "",
"icon": "",
"price": "-1"
},
{
"id": "0b3a482d-fc4c-4a1d-2ae1-08dc4c69fcf5",
"alias": "Tamal",
"description": "",
"icon": "",
"price": "-1"
},
{
"id": "ab028f5e-1e80-4dbd-2ae2-08dc4c69fcf5",
"alias": "Enchilada",
"description": "",
"icon": "",
"price": "-1"
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

    /*

      "brandId": "e9836589-f766-4bc0-ed86-08dc4ba99b9c",
  "branchId": "84e2c10c-918b-4fd4-45ed-08dc4ba99bbb",
  "brandName": "Frutería La Única",
  "branchName": "Río",
  "instagramLink": "https://www.instagram.com/fruterialaunica/",
  "facebookLink": "https://www.facebook.com/fruterialaunicario/",
  "websiteLink": "https://www.fruterialaunica.com.mx/",
  "brandLogo": "",
  "brandSlogan": "Únicamente La Mejor",
  "menuBackground": "https://i0.wp.com/foodandpleasure.com/wp-content/uploads/2022/08/drinks-en-monterrey-terraza-coss.jpeg?fit=1080%2C1350&ssl=1",



     */

    // JSON como un String. Reemplaza este string con tu JSON real
    String jsonString = '''
 {
  "brandId": "e9836589-f766-4bc0-ed86-08dc4ba99b9c",
  "branchId": "84e2c10c-918b-4fd4-45ed-08dc4ba99bbb",
  "brandName": "Frutería La Única",
	"branchName": "Río",
	"instagramLink": "https://www.instagram.com/fruterialaunica/",
	"facebookLink": "https://facebook.com/fruterialaunicario",
	"websiteLink": "https://www.fruterialaunica.com.mx/",
	"brandLogo": "https://www.imagelogo.com",
	"brandSlogan": "Únicamente la mejor",
	"menuBackground": "https://i0.wp.com/foodandpleasure.com/wp-content/uploads/2022/08/drinks-en-monterrey-terraza-coss.jpeg?fit=1080%2C1350&ssl=1",

	"catalogs": [
		{
      "id": "a25ee89d-f3a5-464c-900c-08dc4c2e69d8",
			"name": "Menú Infantil",
			"description": "Menú diseñado para niños con opciones saludables y divertidas.",
			"icon": "url_icono_menu_infantil",
			"categories": [
				{
          "id": "a25ee89d-f3a5-464c-900c-08dc4c2e69d8",
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
          "id": "a25ee89d-f3a5-464c-900c-08dc4c2e69d8",
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


*/