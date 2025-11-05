// lib/models/review_model.dart
class DeliveryPartner {
  String name;
  String phone;
  String vehicle;
  String agency;

  DeliveryPartner({
    required this.name,
    required this.phone,
    required this.vehicle,
    required this.agency,
  });

  factory DeliveryPartner.fromMap(Map<String, dynamic> m) => DeliveryPartner(
        name: m['name'] ?? '',
        phone: m['phone'] ?? '',
        vehicle: m['vehicle'] ?? '',
        agency: m['agency'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'phone': phone,
        'vehicle': vehicle,
        'agency': agency,
      };
}

class Review {
  String reviewId;
  String orderId;
  String productId;
  String productName;
  String sellerId;
  String customerName;
  double rating;
  String comment;
  String date;
  String? sellerReply;
  DeliveryPartner? deliveryPartner;

  Review({
    required this.reviewId,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.sellerId,
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.date,
    this.sellerReply,
    this.deliveryPartner,
  });

  factory Review.fromMap(Map<String, dynamic> m) => Review(
        reviewId: m['reviewId'] ?? '',
        orderId: m['orderId'] ?? '',
        productId: m['productId'] ?? '',
        productName: m['productName'] ?? '',
        sellerId: m['sellerId'] ?? '',
        customerName: m['customerName'] ?? '',
        rating: (m['rating'] is num) ? (m['rating'] as num).toDouble() : double.tryParse(m['rating']?.toString() ?? '0') ?? 0.0,
        comment: m['comment'] ?? '',
        date: m['date'] ?? '',
        sellerReply: m['sellerReply'],
        deliveryPartner: m['deliveryPartner'] != null ? DeliveryPartner.fromMap(Map<String,dynamic>.from(m['deliveryPartner'])) : null,
      );

  Map<String, dynamic> toMap() => {
        'reviewId': reviewId,
        'orderId': orderId,
        'productId': productId,
        'productName': productName,
        'sellerId': sellerId,
        'customerName': customerName,
        'rating': rating,
        'comment': comment,
        'date': date,
        'sellerReply': sellerReply,
        'deliveryPartner': deliveryPartner?.toMap(),
      };
}