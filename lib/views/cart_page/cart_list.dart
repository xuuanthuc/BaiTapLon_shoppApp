import 'package:bai_tap_lon/viewmodel/push_notification_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/viewmodel/cart_viewmodel.dart';
import '/viewmodel/order_viewmodel.dart';

import 'widgets/cart_item.dart';


class CartScreen extends StatelessWidget {
  PushNotificationController pushNotificationController = Get.put(PushNotificationController());
  CartController cart = Get.find();
  OrderViewModel orderViewModel = Get.put(OrderViewModel());
  TextEditingController textName = TextEditingController();
  TextEditingController textAddress = TextEditingController();
  TextEditingController textPhone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart !!!'),
      ),
      body: GetBuilder(
        init: orderViewModel,
        builder: (index) =>Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total'),
                        Spacer(),

                        Chip(
                          backgroundColor: Theme
                              .of(context)
                              .primaryColor,
                          label: GetBuilder<CartController>(
                            init: cart,
                            builder:(index)=> Text(
                              '\$${cart.totalAmount}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        TextButton (
                            onPressed: () async {
                              if(textName.text.isEmpty || textAddress.text.isEmpty || textPhone.text.isEmpty){
                                showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Your text field cannot empty'),
                                      content: Text('Enter your field to order!!'),
                                      actions: [
                                        TextButton(onPressed: () {
                                          Navigator.of(ctx).pop(false); //tra lai ket qua vi false
                                        }, child: Text('Confirm')),
                                      ],
                                    ));
                              }
                              else{
                                await orderViewModel.addOrder(cart.cart.values.toList(), cart.totalAmount, textName.text, textAddress.text, textPhone.text);
                                cart.clear();
                                pushNotificationController.showNotificationOrder();
                                textName.clear();
                                textAddress.clear();
                                textPhone.clear();
                              }
                            },
                            child: Text(
                              'Order Now', style: TextStyle(color: Colors.pink),))
                      ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: textName,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Full Name',
                        ),
                      ),
                      TextFormField(
                        controller: textAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Address',
                        ),
                      ),
                      TextFormField(
                        controller: textPhone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Phone Number',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, i) =>
                    CartItemWidget(
                        cart.cart.values.toList()[i].id,
                        //values cung cap mot thuoc tinh co the lap lai ma co the chuye doi thnah danh sach
                        cart.cart.keys.toList()[i],
                        cart.cart.values.toList()[i].title,
                        cart.cart.values.toList()[i].quantity,
                        cart.cart.values.toList()[i].price),
                itemCount: cart.cart.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
