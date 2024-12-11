import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Services/getPostsBySellerID.dart';
import '../Models/petPosts.dart';  

class PetEditDetailScreen extends StatefulWidget {
  final PetPost petPost;

  const PetEditDetailScreen({Key? key, required this.petPost}) : super(key: key);

  @override
  _PetEditDetailScreenState createState() => _PetEditDetailScreenState();
}

class _PetEditDetailScreenState extends State<PetEditDetailScreen> {
  late List<String> _mediaUrls;
  late List<Widget> _mediaWidgets;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.petPost.petName;
    _priceController.text = widget.petPost.petPrice.toString();
    _descriptionController.text = widget.petPost.petDescription ?? "No description available.";

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
          child: Image.network(mediaUrl),
        );
      }
    }).toList();
  }

  void _showFullScreen(String mediaUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenMediaView(mediaUrl: mediaUrl),
      ),
    );
  }

  Future<void> _updatePetPost() async {
    try {
      await FirebaseFirestore.instance.collection('pets').doc(widget.petPost.id).update({
        'petName': _nameController.text,
        'petPrice': double.parse(_priceController.text),
        'petDescription': _descriptionController.text,
        'mediaUrls': _mediaUrls,
        'postStatus': widget.petPost.postStatus,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pet post updated successfully!')));
    } catch (e) {
      print("Error updating pet post: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update pet post')));
    }
  }

  Future<void> _deletePetPost() async {
    try {
      await FirebaseFirestore.instance.collection('pets').doc(widget.petPost.id).delete();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pet post deleted successfully!')));
      Navigator.pop(context);  
    } catch (e) {
      print("Error deleting pet post: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete pet post')));
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Delete Pet Post', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Text(
            'Are you sure you want to delete this pet post? This action cannot be undone.',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();  
                _deletePetPost();  
              },
              child: Text('Delete', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Pet Post"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updatePetPost,  
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _showDeleteConfirmationDialog,  
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               
              CarouselSlider(
                options: CarouselOptions(
                  height: 300,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  animateToClosest: true,
                  pauseAutoPlayOnTouch: true,
                  enableInfiniteScroll: false,
                ),
                items: _mediaWidgets,
              ),

               
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.petPost.postStatus = widget.petPost.postStatus == 'Active' ? 'Inactive' : 'Active';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: widget.petPost.postStatus == 'Active' ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.petPost.postStatus == 'Active' ? Icons.check_circle : Icons.cancel,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          widget.petPost.postStatus,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

               
              _buildInputField(_nameController, 'Pet Name', 'Enter the pet name', Icons.pets),

               
              Text(
                "Gender",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildGenderButton("Male", Icons.male, widget.petPost.petGender == "Male"),
                  _buildGenderButton("Female", Icons.female, widget.petPost.petGender == "Female"),
                ],
              ),

              SizedBox(height: 16),

               
              _buildInputField(_priceController, 'Price', 'Enter the price', Icons.attach_money, isPrice: true),

               
              _buildInputField(_descriptionController, 'Description', 'Enter a description for the pet', Icons.description, isMultiline: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderButton(String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.petPost.petGender = label;  
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.teal.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey[500]),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildInputField(TextEditingController controller, String label, String hint, IconData icon, {bool isPrice = false, bool isMultiline = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: Icon(icon),   
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            ),
            keyboardType: isPrice ? TextInputType.number : TextInputType.text,
            maxLines: isMultiline ? 5 : 1,
          ),
        ),
      ),
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

  const FullScreenMediaView({Key? key, required this.mediaUrl}) : super(key: key);

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
