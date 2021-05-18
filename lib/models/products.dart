import 'dart:convert';

List<ProductModel> productFromJson(String str) => List<ProductModel>.from(json.decode(str).map((e) => ProductModel.fromJson(e)));
String productToJson(List<ProductModel> data) => json.encode(List<dynamic>.from(data.map((e) => e.toJson())));
class ProductModel {
   String id;
   String title;
   num price;
   String imageUrl;
   String description;
   String from;

  ProductModel(
      {this.id,
        this.title,
        this.price,
        this.imageUrl,
        this.from,
        this.description});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    from = json['from'];
    price = json['price'];
    imageUrl = json['imageUrl'];
    description = json['description'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['imageUrl'] = this.imageUrl;
    data['from'] = this.from;
    data['description'] = this.description;
    return data;
  }
}
