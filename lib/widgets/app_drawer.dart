import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/views/home_page/list_product.dart';
import '/views/management_product/management_product.dart';
import '/views/order_page/order_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            elevation: 0,
            backgroundColor: Colors.redAccent,
            title: Text('Welcome to HShop'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () => Get.to(ListProductItem()),
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: ()=> Get.to(()=> OrderScreen()),
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Products Manager'),
            onTap: () => Get.to(ManagementProduct()),
          ),

        ],
      ),
    );
  }
}
