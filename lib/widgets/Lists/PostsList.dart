import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pet_store/Screens/PetEditDetailScreen.dart';
import '../../Models/petPosts.dart';
import '../../Services/getPostsBySellerID.dart';

class PetPostList extends StatelessWidget {
  final List<PetPost> petPosts;
  final bool isLoading;
  final VoidCallback onLoadMore;

  const PetPostList({
    Key? key,
    required this.petPosts,
    required this.isLoading,
    required this.onLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (petPosts.isEmpty && !isLoading) {
      return Center(
        child: Text(
          "No pet posts available.",
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      itemCount: petPosts.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == petPosts.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator(color: Colors.teal)),
          );
        } else {
          final petPost = petPosts[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetEditDetailScreen(petPost: petPost),
                  ),
                );
              },
              child: Card(
                elevation: 6,
                shadowColor: Colors.black.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display Pet Image with a nice placeholder and cache
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                      child: CachedNetworkImage(
                        imageUrl: petPost.mediaUrls.isNotEmpty ? petPost.mediaUrls[0] : '',
                        placeholder: (context, url) => Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(color: Colors.teal),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        petPost.petName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        petPost.petType,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.teal,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        "Age: ${petPost.petAge}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "\$${petPost.petPrice}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
