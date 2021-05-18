import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/viewmodel/product_viewmodel.dart';

import '../edit_product_screen.dart';

class CustomProductCard extends StatelessWidget {
  ProductViewModel productViewModel = Get.find();

  int index;
  CustomProductCard(this.index);
  @override
  Widget build(BuildContext context) {
    final product = productViewModel.productList[index];
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: Container(
        width: 97,
        child: Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.deepOrange,
                ),
                onPressed: () => Get.to(EditProduct(),
                    arguments: productViewModel.productList[index].id),
            ),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  productViewModel.deleteProduct(product.id);
                }),
          ],
        ),
      ),
    );
  }
}
