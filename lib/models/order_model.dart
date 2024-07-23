import 'package:ecommerce/models/add_to_cart_model.dart';

class OrderModel {
  final String id;
  final String name;
  final List<AddToCartModel> allCartItems;
  final String address;
  final int totalAmount;

  OrderModel({
    required this.id,
    required this.name,
    required this.allCartItems,
    required this.address,
    required this.totalAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name' : name,
      'cartItems': allCartItems.map((item) => item.toMap()).toList(),
      'address': address,
      'totalAmount': totalAmount,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OrderModel(
      id: documentId,
      allCartItems: List<AddToCartModel>.from(
        map['cartItems']?.map((item) => AddToCartModel.fromMap(item, documentId)),
      ),
      address: map['address'],
      totalAmount: map['totalAmount'],
      name: map['name'],
    );
  }
}
