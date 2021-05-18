import 'dart:convert';

import 'package:http/http.dart' as http;
import '/models/products.dart';

class ProductRepository {
  static Future<List<ProductModel>> getProductItem() async {
    var finalUrl = 'https://headphone-shop-default-rtdb.firebaseio.com/products.json';
    final response = await http.get(finalUrl);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<ProductModel> products = jsonResponse.entries.map((e) => ProductModel.fromJson(e.value)).toList();
      // var productList = jsonResponse.map((items) => ProductModel.fromJson(items)).toList();
      print(products);
      return products;
    } else {
      throw Exception('Error get Product');
    }
  }
}
