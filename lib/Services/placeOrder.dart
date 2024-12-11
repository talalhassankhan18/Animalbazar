import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/Notification.dart';

class OrderServices {
 static Future<void> placeOrderToSeller({
    required String buyerID,
    required String buyerNote,
    required String petName,
    required String buyerNumber,
    required String postID,
    required String sellerID,

  }) async {
    await FirebaseFirestore.instance.collection('requests').add({
      "postID": postID,
      "sellerID": sellerID,
      "buyerID": buyerID,
      "petName": petName,
      "buyerNote": buyerNote,
      "buyerNumber": buyerNumber,
      'createdAt': Timestamp.now(),
    });
  }

  // Fetch requests for a specific pet
  static Future<List<PetNotification>> fetchRequestsForPet(String postID) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('postID', isEqualTo: postID)
        .get();

    return snapshot.docs
        .map((doc) => PetNotification.fromFirestore(doc))
        .toList();
  }

  static Future<List<PetNotification>> fetchRequestsForBuyer(String buyerID) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('buyerID', isEqualTo: buyerID)
        .get();

    return snapshot.docs
        .map((doc) => PetNotification.fromFirestore(doc))
        .toList();
  }

  // Fetch requests for a specific seller
  static Future<List<PetNotification>> fetchRequestsForSeller(String sellerID) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('sellerID', isEqualTo: sellerID)
        .get();

    return snapshot.docs
        .map((doc) => PetNotification.fromFirestore(doc))
        .toList();
  }
}
