class AddToCartModel {
  final String id;
  final String productId;
  final String title;
  final int price;
  final int quantity;
  final String imageUrl;
  final int discountValue;

  AddToCartModel({
    required this.id,
    required this.title,
    required this.price,
    required this.productId,
    this.quantity = 1,
    required this.imageUrl,
    required this.discountValue,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'productId': productId});
    result.addAll({'title': title});
    result.addAll({'price': price});
    result.addAll({'quantity': quantity});
    result.addAll({'imageUrl': imageUrl});
    result.addAll({'discountValue': discountValue});

    return result;
  }

  factory AddToCartModel.fromMap(Map<String, dynamic> map, String documentId) {
    return AddToCartModel(
      id: documentId,
      title: map['title'] ?? '',
      productId: map['productId'] ?? '',
      price: map['price']?.toInt() ?? 0,
      quantity: map['quantity']?.toInt() ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      discountValue: map['discountValue']?.toInt() ?? 0,
    );
  }

}