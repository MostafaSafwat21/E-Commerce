class AddToFavoriteModel {
  final String id;
  final String? title;
  final int? price;
  final String? imageUrl;
  final int? discountValue;
  final String? category;
  final bool? isFavorite;
  final int? rate;

  AddToFavoriteModel({
    required this.id,
    this.title,
    this.price,
    this.imageUrl,
    this.discountValue,
    this.category,
    this.isFavorite = false,
    this.rate = 0,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'price': price});
    result.addAll({'imageUrl': imageUrl});
    result.addAll({'discountValue': discountValue});
    result.addAll({'category': category});
    result.addAll({'rate': rate});
    result.addAll({'isFavorite': isFavorite});
    return result;
  }

  factory AddToFavoriteModel.fromMap(
      Map<String, dynamic> map, String documentId) {
    return AddToFavoriteModel(
      id: documentId,
      title: map['title'] ?? '',
      price: map['price']?.toInt() ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      discountValue: map['discountValue']?.toInt() ?? 0,
      category: map['category'] ?? '',
      rate: map['rate']?.toInt() ?? 0,
      isFavorite: map['isFavorite'] ?? false,
    );
  }
}
