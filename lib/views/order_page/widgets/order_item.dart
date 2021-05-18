import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '/models/order.dart';
import '/viewmodel/order_viewmodel.dart';
import '/viewmodel/push_notification_viewmodel.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;
  OrderItemWidget(this.order);
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItemWidget> {
  PushNotificationController pushNotificationController = Get.find();

  OrderViewModel orderViewModel = Get.find();
  var _expandedMore = false;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderViewModel>(
        init: orderViewModel,
        builder:(index)=> GestureDetector(
          onLongPress: (){
            showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Confirm Orders'),
                  content: Text('Payment on delivery'),
                  actions: [
                    TextButton(onPressed: () {
                      Get.back();
                    }, child: Text('No')),
                    TextButton(onPressed: () {
                      pushNotificationController.showNotificationConfirm(widget.order.name);
                      orderViewModel.removeOrder(widget.order.id);
                      Get.back();
                    }, child: Text('Yes')),
                  ],
                ));
          },
          child: Dismissible(
          key: ValueKey(widget.order.id),
          background: Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 40,
              ),
            ),
            alignment: Alignment.centerRight,
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) {//tra ve gia tri xac nhan true hay false, true thi tiep tuc thuc hien
            return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Are you sure??'),
                  content: Text('Delete your order!'),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.of(ctx).pop(false); //tra lai ket qua vi false
                    }, child: Text('No')),
                    TextButton(onPressed: () {
                      Navigator.of(ctx).pop(true); // tro ve nhung tiep tuc thuc hien cau lenh onDismiss
                    }, child: Text('Yes')),
                  ],
                ));
          },
          onDismissed: (dismiss) =>
              orderViewModel.removeOrder(widget.order.id),
          child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _expandedMore ? widget.order.products.length * 40.0 + 130 : 150,
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${widget.order.name}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),),
                          Text('Address: ${widget.order.address}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),),
                          Text('Phone: ${widget.order.phone}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),),
                          Text('\$${widget.order.amount}', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),),
                        ],
                      ),
                      subtitle: Text(
                          DateFormat('dd/MM/yyy hh:mm').format(widget.order.dateTime)),
                      trailing: IconButton(
                        icon:
                        Icon(_expandedMore ? Icons.expand_less : Icons.expand_more),
                        onPressed: () {
                          setState(() {
                            _expandedMore = !_expandedMore;
                          });
                        },
                      ),
                    ),

                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: _expandedMore ? widget.order.products.length * 40.0 - 10 : 0,
                      child: ListView(
                        children: widget.order.products.map((prod) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(prod.title, style: TextStyle(fontWeight: FontWeight.bold),),
                              Text('${prod.quantity} x \$${prod.price}')
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
        ),
    );
  }
}
