import 'dart:convert';

import 'package:get/get.dart';
import '/models/cart.dart';
import '/models/order.dart';
import 'package:http/http.dart' as http;
class OrderViewModel extends GetxController{
  List<OrderItem> orders = List<OrderItem>().obs;
  OrderItem order;

  Future<void> fetchAndSetOrder() async {
    final url =
        'https://headphone-shop-default-rtdb.firebaseio.com/orders.json?';
    try {
      final response =
      await http.get(url); //post de gui yeu cau gui, get de yeu cau nhan
      if (response.statusCode == 200) {
        Map<String, dynamic> _mapData = jsonDecode(response.body);
        final List<OrderItem> loadedOrder = [];
        _mapData.forEach((pordId, pordData) {
          print(pordId);
          //duyet phan tu theo id la name va gia tri tra ve ben trong do gan vao pordData
          loadedOrder.add(OrderItem(
            pordId,
            pordData['amount'],
            pordData['name'],
            pordData['address'],
            pordData['phone'],
            (pordData['products'] as List<dynamic>).map((e) =>
                CartItem(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price'])).toList(),
            DateTime.parse(pordData['dateTime']),
          ));
        });
        orders = loadedOrder;
        update();
      }
    } catch (error) {
      throw error;
    }
  }
  // void removeOrder(String orderId) {
  //   orders.remove(orderId);
  //   update();
  // }
  void removeOrder(String id) {
    final url = 'https://headphone-shop-default-rtdb.firebaseio.com/orders/$id.json?';
    http.delete(url);
    orders.removeWhere((element) => element.id == id);
    update();
  }

  void addOrder(List<CartItem> cartProduct, double total, String name, String address, String phone) async {
    final url =
        'https://headphone-shop-default-rtdb.firebaseio.com/orders.json?';
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'name': name,
          'address': address,
          'phone': phone,
          'products': cartProduct
              .map((e) => {
            'id': e.id,
            'title': e.title,
            'quantity': e.quantity,
            'price': e.price
          })
              .toList(),
          'dateTime': DateTime.now().toIso8601String(),
        }));
    print(json.decode(response.body));
    orders.insert(
        0,
        OrderItem(
          json.decode(response.body)['name'],
          total,
          name,
          address,
          phone,
          cartProduct,
          DateTime.now(),
        ));
    update();
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAndSetOrder();
  }

}