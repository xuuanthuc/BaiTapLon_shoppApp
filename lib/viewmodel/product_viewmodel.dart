import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '/models/products.dart';
import '/repositories/product_repository.dart';

class ProductViewModel extends GetxController {
  List<ProductModel> productList = List<ProductModel>().obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchProductItem();
    super.onInit();
  }

  void fetchProductItem() async {
    try {
      isLoading(true);
      productList = await ProductRepository.getProductItem();
      update();
    } finally {
      isLoading(false);
      update();
    }
  }
  ProductModel findById(String id){
return productList.firstWhere((element) => element.id == id);
  }

  void addNewProduct(ProductModel products) async {
    final url =
        'https://headphone-shop-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'id': products.id,
            'title': products.title,
            'description': products.description,
            'price': products.price,
            'from': products.from,
            'imageUrl': products.imageUrl,
          }));
      final newProduct = ProductModel(
        id: json.decode(response.body)['name'],
        title: products.title,
        from: products.from,
        description: products.description,
        price: products.price,
        imageUrl: products.imageUrl,
      );
      productList.add(newProduct);
      update();
    } catch (e) {}
  }
  Future<void> updateProduct(String id, ProductModel newProduct) async {
    final prodIndex = productList.indexWhere((element) => element.id == id); //prodIndex lay gia tri product co id moi trung voi id cu
    if (prodIndex >= 0) {
      final url = 'https://headphone-shop-default-rtdb.firebaseio.com/products/$id.json?';
      await http.patch(url, body: json.encode({
        'id': newProduct.id,
        'title': newProduct.title,
        'description': newProduct.description,
        'from': newProduct.from,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
      }));
      productList[prodIndex] = newProduct;
      update();
    } else {
    }
  }

  void deleteProduct(String id) {
    final url = 'https://headphone-shop-default-rtdb.firebaseio.com/products/$id.json?';
    http.delete(url);
    productList.removeWhere((element) => element.id == id);
    update();
  }

}
