import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/viewmodel/product_viewmodel.dart';
import '/views/management_product/edit_product_screen.dart';
import '/widgets/app_drawer.dart';

import 'widgets/product_card.dart';


class ManagementProduct extends StatelessWidget {
  ProductViewModel productViewModel = Get.put(ProductViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        elevation: 0,
        title: Text('Your Product'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
                onTap: () => Get.to(EditProduct()), child: Icon(Icons.add)),
          ),
        ],
      ),
      body: Container(
        child: GetBuilder<ProductViewModel>(
          init: productViewModel,
          builder: (index) =>
              Container(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Divider(),
                        CustomProductCard(index),
                      ],
                    );
                  },
                  itemCount: productViewModel.productList.length,
                ),
              ),
        ),
      ),
    );
  }
}
