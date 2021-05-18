import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/viewmodel/order_viewmodel.dart';
import '/viewmodel/push_notification_viewmodel.dart';
import '/widgets/app_drawer.dart';

import 'widgets/order_item.dart';


class OrderScreen extends StatelessWidget {
  PushNotificationController pushNotificationController = Get.put(PushNotificationController());
  OrderViewModel orderViewModel = Get.put(OrderViewModel());
  Future<void> _refeshOrder(BuildContext context) async{
    await orderViewModel.fetchAndSetOrder();
  }
  static const routeName = 'order-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        elevation: 0,
        title: Text('Your Order'),
      ),
      body: FutureBuilder(//lay ket qua tu _refeshOrder truoc roi xay dung len list order
        future: _refeshOrder(context),
        builder:(ctx, snapshot)=> snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator(),) :
        GetBuilder(
          init: orderViewModel,// chi lay provider trong widget nay va build lai widget nay tranh build lai ca trang, neu dung final order o tren se build lai ca trang lien tuc, tuong tu voi user_products_screen
          builder:(index) => RefreshIndicator(
            onRefresh: () => _refeshOrder(context),
            child: ListView.builder(
              itemBuilder: (ctx, i) => OrderItemWidget(orderViewModel.orders[i]),
              itemCount: orderViewModel.orders.length,
            ),
          ),
        ),
      ),
    );
  }
}
