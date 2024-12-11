import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/petPosts.dart';

class Getpostsbyselleridy {

  static Future<List<PetPost>> fetchPostsBySeller({
    required String sellerID,
    int limit = 10,
  }) async {
    Query query = FirebaseFirestore.instance
        .collection('pets')
        .where('sellerID', isEqualTo: sellerID)
        .orderBy('createdAt', descending: true)
        .limit(limit);



    QuerySnapshot snapshot = await query.get();

    List<PetPost> posts = snapshot.docs.map((doc) {
      return PetPost.fromFirestore(doc);
    }).toList();

    return posts;
  }
}
