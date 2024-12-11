import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> toggleFavorite({
    required String userID,
    required String petID,
    required Map<String, dynamic> petDetails,
  }) async {
    final favoritesRef = _firestore.collection('users').doc(userID).collection('favorites');
    final petDoc = favoritesRef.doc(petID);

    final petSnapshot = await petDoc.get();

    if (petSnapshot.exists) {
      await petDoc.delete();
    } else {
      // If pet is not in favorites, add it
      await petDoc.set(petDetails);
    }
  }

  Future<bool> isFavorite({
    required String userID,
    required String petID,
  }) async {
    final favoritesRef = _firestore.collection('users').doc(userID).collection('favorites');
    final petDoc = favoritesRef.doc(petID);

    final petSnapshot = await petDoc.get();
    return petSnapshot.exists;
  }
}
