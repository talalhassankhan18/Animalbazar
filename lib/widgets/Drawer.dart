import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_store/Screens/FavoritePetsScreen.dart';

class DrawerMenu extends StatelessWidget {
  final Function(int) onItemSelected;  
  const DrawerMenu({Key? key, required this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser!;
    return Container(
      color: Colors.teal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                     Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  currentUser.photoURL!,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentUser.displayName!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Active status",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      maxLines: 1,                        overflow: TextOverflow
                          .ellipsis,                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 40),

                     _buildDrawerItem(Icons.store, "Seller", 0),
          _buildDrawerItem(Icons.shopping_cart, "Buyer", 1),
          _buildDrawerItem(Icons.person, "Profile", 2),
          GestureDetector(
            onTap:  () {

              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FavoritePetsScreen(userID: currentUser.email!)));
              }
              ,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Icon(Icons.favorite, color: Colors.white, size: 24),
                  SizedBox(width: 16),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    "Favorite",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),

                     Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.settings, color: Colors.white),
                  label: Text(
                    "Settings",
                    style: TextStyle(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Log out",
                    style: TextStyle(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(width: 16),
            Text(
              overflow: TextOverflow.ellipsis,
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
