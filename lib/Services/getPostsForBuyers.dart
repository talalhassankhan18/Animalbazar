import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Getpostsforbuyers {

  static const _pageSize = 10;

  // Method to fetch posts with filters and pagination
 static Future<void> fetchPosts({
    required PagingController<int, DocumentSnapshot> pagingController,
    required String selectedPetType,
    required RangeValues selectedPriceRangeValues,
    required RangeValues selectedAgeRangeValues,
   required String selectedGender,
  }) async {
    try {
      // Query to fetch pet posts
      Query query = FirebaseFirestore.instance
          .collection('pets')
          .orderBy('createdAt').where("postStatus", isEqualTo: "Active")
          .limit(_pageSize);

      // Apply Pet Type Filter if selected
      if (selectedPetType.isNotEmpty) {
        query = query.where('petType', isEqualTo: selectedPetType);
      }

      if (selectedGender.isNotEmpty) {
        query = query.where('petGender', isEqualTo: selectedGender);
      }

      // Apply Price Range Filter if it's not the default full range
      if (selectedPriceRangeValues.start > 0 ||
          selectedPriceRangeValues.end < 10000) {
        query = query
            .where('petPrice', isGreaterThanOrEqualTo: selectedPriceRangeValues.start)
            .where('petPrice', isLessThanOrEqualTo: selectedPriceRangeValues.end);
      }

      // Apply Age Range Filter if it's not the default full range
      if (selectedAgeRangeValues.start > 0 ||
          selectedAgeRangeValues.end < 20) {
        query = query
            .where('petAge', isGreaterThanOrEqualTo: selectedAgeRangeValues.start)
            .where('petAge', isLessThanOrEqualTo: selectedAgeRangeValues.end);
      }

      // Pagination logic: start from the last document if not the first page
      if (pagingController.nextPageKey != null) {
        final lastDocument = pagingController.itemList?.last;
        if (lastDocument != null) {
          query = query.startAfterDocument(lastDocument);
        }
      }

      QuerySnapshot querySnapshot = await query.get();

      final isLastPage = querySnapshot.docs.length < _pageSize;

      if (isLastPage) {
        pagingController.appendLastPage(querySnapshot.docs);
      } else {
        final nextPageKey = pagingController.nextPageKey! + querySnapshot.docs.length;
        pagingController.appendPage(querySnapshot.docs, nextPageKey);
      }
    } catch (e) {
      pagingController.error = e;
    }
  }
}
