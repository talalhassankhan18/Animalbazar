import 'package:cloud_firestore/cloud_firestore.dart';

class PetNotification {
  final String id; // ID of the notification document
  final String postID;
  final String sellerID;
  final String buyerID;
  final String buyerNote;
  final String buyerNumber;
  final String petName;
  final Timestamp createdAt;


  PetNotification({
    required this.id,
    required this.postID,
    required this.sellerID,
    required this.buyerID,
    required this.buyerNote,
    required this.buyerNumber,
    required this.createdAt,
    required this.petName,
  });

  // Factory constructor to create a Notification object from Firestore data
  factory PetNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PetNotification(
      id: doc.id,
      postID: data['postID'] ?? '',
      sellerID: data['sellerID'] ?? '',
      buyerID: data['buyerID'] ?? '',
      buyerNote: data['buyerNote'] ?? '',
      buyerNumber: data['buyerNumber'] ?? '',
      petName: data["petName"] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
