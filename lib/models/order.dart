import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final String name;
  final String address;
  final String phone;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
     this.id,
     this.amount,
     this.name,
     this.address,
     this.phone,
     this.products,
     this.dateTime,
  );
}