import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/petPosts.dart';

class FavoritePetsScreen extends StatefulWidget {
  final String userID;

  const FavoritePetsScreen({Key? key, required this.userID}) : super(key: key);

  @override
  _FavoritePetsScreenState createState() => _FavoritePetsScreenState();
}

class _FavoritePetsScreenState extends State<FavoritePetsScreen> {
  List<PetPost> favoritePets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavoritePets();
  }

  Future<void> _fetchFavoritePets() async {
    try {
       
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .collection('favorites')
          .get();

       
      final petIDs = snapshot.docs.map((doc) => doc.id).toList();

       
      final petSnapshots = await Future.wait(
        petIDs.map((id) => FirebaseFirestore.instance.collection('pets').doc(id).get()),
      );

       
      final pets = petSnapshots
          .where((doc) => doc.exists)  
          .map((doc) => PetPost.fromFirestore(doc))
          .toList();

      setState(() {
        favoritePets = pets;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching favorite pets: $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Pets'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favoritePets.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No favorite pets yet!',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: favoritePets.length,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        itemBuilder: (context, index) {
          final pet = favoritePets[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: pet.mediaUrls.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  pet.mediaUrls[0],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              )
                  : Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.image, color: Colors.grey),
              ),
              title: Text(
                pet.petName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    pet.petType,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${pet.petPrice}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.teal),
              onTap: () {
                 
                print('Selected Pet: ${pet.petName}');
              },
            ),
          );
        },
      ),
    );
  }
}
