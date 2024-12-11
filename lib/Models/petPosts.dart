
import 'package:cloud_firestore/cloud_firestore.dart';

class PetPost {
  String sellerID;
  String petName;
  String petType;
  var petAge;
  var petPrice;
  List<String> mediaUrls;
  Timestamp createdAt;
  String postStatus;
  String petDescription;
  String id;
  String petGender;
  PetPost({
    required this.sellerID,
    required this.petName,
    required this.petType,
    required this.petAge,
    required this.petPrice,
    required this.mediaUrls,
    required this.createdAt,
    required this.postStatus,
    required this.id,
    required this.petDescription,
    required this.petGender
  });

  // Factory method to create a PetPost from a Firestore document
  factory PetPost.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return PetPost(
        sellerID: data['sellerID'],
        petName: data['petName'],
        petType: data['petType'],
        petAge: data['petAge'],
        petPrice: data['petPrice'],
        mediaUrls: List<String>.from(data['mediaUrls']),
        createdAt: data['createdAt'],
        postStatus: data['postStatus'],
        id: doc.id,
        petDescription: data['petDescription'],
        petGender: data['petGender']
    );
  }

}
