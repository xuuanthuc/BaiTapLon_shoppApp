import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/viewmodel/cart_viewmodel.dart';
import '/viewmodel/product_viewmodel.dart';
import '/views/cart_page/cart_list.dart';
import '/views/home_page/widgets/badge.dart';
import '/widgets/app_drawer.dart';

class ListProductItem extends StatelessWidget {
  ProductViewModel productViewModel = Get.put(ProductViewModel());
  CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.redAccent,
        title: Text('HappyShop'),
        actions: [
          Stack(
            children: [
              GetBuilder<CartController>(
                init: cartController,
                builder: (index) => Badge(
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {Get.to(CartScreen());},
                    ),
                    value: cartController.itemCount.toString()),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          child: GetBuilder<ProductViewModel>(
            init: productViewModel,
            builder: (index) => Container(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return CustomListTile(index);
                },
                itemCount: productViewModel.productList.length,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget CustomListTile(int index) {
    var product = productViewModel.productList[index];
    return GestureDetector(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Flexible(
              flex: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/ping.png'),
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                child: Container(
                  padding: EdgeInsets.all(15),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(57, 57, 57, 1)),
                      ),
                      Text(
                        product.from,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(143, 143, 143, 1)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${product.price}',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.redAccent),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              color: Colors.white,
                              icon: Icon(Icons.shopping_cart_outlined),
                              onPressed: () {
                                cartController.addItem(
                                    product.id, product.title, product.price);
                                Get.snackbar(
                                  'Added Item to Cart!',
                                  'Have nice day for you!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  mainButton: TextButton(
                                    onPressed: ()=> cartController.removeSinglerCart(product.id),
                                    child: Text('UNDO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
                                  ),
                                  duration: Duration(seconds: 2),
                                );
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
