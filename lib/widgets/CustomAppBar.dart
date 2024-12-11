import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
                     GestureDetector(
            onTap: () {
                             Scaffold.of(context).openDrawer();
            },
            child: Icon(
              Icons.menu,
              size: 28,
              color: Colors.grey[800],
            ),
          ),

                     Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Location',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_pin,
                    size: 18,
                    color: Colors.teal,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Islamabad, Pakistan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ],
          ),

          GestureDetector(
            onTap: () {
            },
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                FirebaseAuth.instance.currentUser!.photoURL!,                ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70);  }
