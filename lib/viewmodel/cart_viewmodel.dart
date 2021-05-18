import 'package:get/get.dart';
import '/models/cart.dart';

class CartController extends GetxController{
  Map<String, CartItem> cart = {};
  int get itemCount{
    return cart.length;
    update();
  }
  double get totalAmount {
    var total = 0.0;
    cart.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    //kiem tra mat hang da co trong gio hang chua, neu co thif tang so luong neu khong thi them vao gio hang
    if (cart.containsKey(productId)) {
      cart.update(
          productId,
              (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity + 1,
            price: existingCartItem.price,
          )); //goi ham cartItem vaof cung cap vao gia tri hien co tai productId
    } //neu items da co chua Id trong gio hang thi tang so luong
    else {
      cart.putIfAbsent(
          productId,
              () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1,
          ));
    }
    update();
  }

  void removeCart(String productId) {
    cart.remove(productId);
    update();
  }

  void removeSinglerCart(String productId) {
    if (!cart.containsKey(
        productId)) {
      //kiem tra xem san pham co phai la cua cua hang hay khong theo key id,
      return;
    } //neu khong thi return khong lam gi het
    else if (cart[productId].quantity > 1) {
      cart.update(
          productId,
              (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity - 1,
            price: existingCartItem.price,
          ));
    } else {
      cart.remove(productId);
    }
    update();
  }

  void clear() {
    cart = {};
    update();
  }
}