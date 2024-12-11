import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../Services/getPostsBySellerID.dart';
import '../Models/petPosts.dart';
import '../Services/FavoritesService.dart';
import '../Services/placeOrder.dart';

class PetDetailScreen extends StatefulWidget {
  final PetPost petPost;

  const PetDetailScreen({Key? key, required this.petPost}) : super(key: key);

  @override
  _PetDetailScreenState createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  late List<String> _mediaUrls;
  late List<Widget> _mediaWidgets;
  bool isFavorite = false;
  final userID = FirebaseAuth.instance.currentUser?.email;
  final FavoritesService _favoritesService = FavoritesService();

  @override
  void initState() {
    super.initState();
    _mediaUrls = widget.petPost.mediaUrls;
    _mediaWidgets = _mediaUrls.map<Widget>((mediaUrl) {
      if (mediaUrl.endsWith('.mp4')) {
        return GestureDetector(
          onTap: () => _showFullScreen(mediaUrl),
          child: VideoPlayerWidget(url: mediaUrl),
        );
      } else {
        return GestureDetector(
          onTap: () => _showFullScreen(mediaUrl),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              mediaUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    }).toList();
    _checkIfFavorite();

  }

  Future<void> _checkIfFavorite() async {
    if (userID != null) {
      final favoriteStatus = await _favoritesService.isFavorite(
        userID: userID!,
        petID: widget.petPost.id,
      );
      setState(() {
        isFavorite = favoriteStatus;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (userID != null) {
      await _favoritesService.toggleFavorite(
        userID: userID!,
        petID: widget.petPost.id,
        petDetails: {
          'petName': widget.petPost.petName,
          'petType': widget.petPost.petType,
          'petAge': widget.petPost.petAge,
          'petPrice': widget.petPost.petPrice,
          'mediaUrls': widget.petPost.mediaUrls,
        },
      );
      setState(() {
        isFavorite = !isFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite ? 'Added to favorites!' : 'Removed from favorites!',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You need to log in to add favorites.'),
        ),
      );
    }
  }

  void _showFullScreen(String mediaUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenMediaView(mediaUrl: mediaUrl),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                   
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        child: Card(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 400,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                aspectRatio: 16 / 9,
                                enlargeStrategy: CenterPageEnlargeStrategy.height,
                                animateToClosest: true,
                                pauseAutoPlayOnTouch: true,
                                pauseAutoPlayInFiniteScroll: true,
                                enableInfiniteScroll: false,
                              ),
                              items: _mediaWidgets,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: 300),
                    ],
                  ),
                  Positioned(
                    top: 350,  
                    left: 0,
                    right: 0,
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 350,
                      ),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 100, 16, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                   
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                        FirebaseAuth.instance!.currentUser!.photoURL!),  
                                  ),
                                  SizedBox(width: 8),

                                   
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          FirebaseAuth.instance!.currentUser!.displayName!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Owner",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "Dec 11, 2022",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),

                               
                              Text(
                                widget.petPost.petDescription.isNotEmpty
                                    ? widget.petPost.petDescription
                                    : "No description available.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                   
                  Positioned(
                    top: 300,  
                    left: 16,
                    right: 16,
                    child: Card(color: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 30,  
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.petPost.petName,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.male,
                                  size: 24,
                                  color: Colors.teal,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),

                             
                            Text(
                              "${widget.petPost.petType}, ${widget.petPost.petAge} years old",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),

                             
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 16, color: Colors.teal),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    "5 Street, G11/4, Islamabad",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                   
                ],
              )

            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.teal[100],  
          borderRadius: BorderRadius.circular(16),  
          boxShadow: [
            BoxShadow(
              color: Colors.black12,  
              blurRadius: 8,  
              offset: Offset(0, 2),  
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             
          FloatingActionButton(
          heroTag: 'favorite',
          onPressed: _toggleFavorite,
          backgroundColor: isFavorite ? Colors.red : Colors.teal,
          child: Icon(
            Icons.favorite,
            color: Colors.white,
          ),
        ),

             
            Expanded(
              child: Container(
                height: 60,
                margin: const EdgeInsets.only(left: 16),
                child: ElevatedButton(
                  onPressed: () => _showAdoptionForm(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Adoption',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

   
  Widget _buildCardInfo({
    required IconData icon,
    required String label,
    required Color color,
    bool isBold = false,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }



  void _showAdoptionForm(BuildContext context) {
    final TextEditingController numberController = TextEditingController();
    final TextEditingController noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 24.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                 
                Center(
                  child: Text(
                    "Buying Request",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[700],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                 
                _buildTextField(
                  controller: numberController,
                  label: "Phone Number",
                  hint: "Enter your phone number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                    isNumeric: true,

                ),
                SizedBox(height: 16),

                 
                _buildTextField(
                  controller: noteController,
                  label: "Note",
                  hint: "Leave a note for the seller",
                  icon: Icons.note,
                  maxLines: 3,
                    isNumeric: false
                ),
                SizedBox(height: 24),

                 
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        String phoneNumber = numberController.text.trim();
                        String note = noteController.text.trim();

                        if (phoneNumber.isNotEmpty) {
                          String buyerID = FirebaseAuth.instance.currentUser!.email!;
                          String postID = widget.petPost.id;

                          Navigator.pop(context);  

                          OrderServices.placeOrderToSeller(
                            buyerID: buyerID,
                            buyerNote: note,
                            buyerNumber: phoneNumber,
                            postID: postID,
                              sellerID: widget.petPost.sellerID,
                              petName: widget.petPost.petName

                          ).then((_) {
                            _showSuccessDialog(context, 'Request submitted successfully!', phoneNumber, note);
                          }).catchError((e) {
                             
                            _showErrorDialog(context, 'Failed to submit request. Please try again.');
                          });
                        } else {
                          _showErrorDialog(context, 'Phone number is required!');
                        }
                      },


                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 20,)],
            ),
          ),
        );
      },
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isNumeric,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.phone : TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: InputBorder.none,  
          ),
        ),
      ),
    );
  }


  void _showSuccessDialog(BuildContext context, String message, String phone, String note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.teal),
              SizedBox(width: 8),
              Text('Success'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              SizedBox(height: 16),
              Text('Phone: $phone'),
              if (note.isNotEmpty) ...[
                SizedBox(height: 8),
                Text('Note: $note'),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);  
              },
              child: Text('OK', style: TextStyle(color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Error'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);  
              },
              child: Text('OK', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }



}

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator(color: Colors.teal));
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _isPlaying = !_isPlaying;
          _isPlaying ? _controller.play() : _controller.pause();
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          if (!_isPlaying)
            Icon(
              Icons.play_circle_fill,
              size: 50,
              color: Colors.white.withOpacity(0.7),
            ),
        ],
      ),
    );
  }
}

class FullScreenMediaView extends StatelessWidget {
  final String mediaUrl;

  const FullScreenMediaView({Key? key, required this.mediaUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: mediaUrl.endsWith('.mp4')
              ? VideoPlayerWidget(url: mediaUrl)
              : Image.network(
                  mediaUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
        ),
      ),
    );
  }
}
