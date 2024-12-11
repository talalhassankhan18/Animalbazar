import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_store/widgets/CustomAppBar.dart';

import '../Services/postPet.dart';
import '../widgets/Buttons/MediaPicker.dart';
import '../widgets/Buttons/SubmitButton.dart';
import '../widgets/Grids/MediaGrid.dart';
import '../widgets/inputFeildsForPosts/InputFeld.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({Key? key}) : super(key: key);

  @override
  _SellerScreenState createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  final _petNameController = TextEditingController();
  final _petTypeController = TextEditingController();
  final _petAgeController = TextEditingController();
  final _petPriceController = TextEditingController();
  final _petDescriptionController = TextEditingController();  // Added description controller
  final ImagePicker _picker = ImagePicker();
  String _selectedGender = "Male";

  List<XFile> _mediaFiles = [];
  String _selectedPetType = '';
  bool isSubmitting = false;


  // Function to pick images/videos
  Future<void> _pickMedia() async {
    final pickedFiles = await _picker.pickMultipleMedia();
    if (pickedFiles != null) {
      setState(() {
        _mediaFiles = pickedFiles;
      });
    }
  }

  // Function to submit pet details and media
  void _submitPetDetails() {
    final petName = _petNameController.text;
    final petType = _selectedPetType;
    final petAge = _petAgeController.text;
    final petPrice = _petPriceController.text;
    final petDescription = _petDescriptionController.text;

    // Check if all fields are filled, including gender
    if (petName.isNotEmpty &&
        petType.isNotEmpty &&
        petAge.isNotEmpty &&
        petPrice.isNotEmpty &&
        petDescription.isNotEmpty &&
        _selectedGender.isNotEmpty &&
        _mediaFiles.isNotEmpty) {
      setState(() {
        isSubmitting = true; // Show loading indicator
      });

      // Call the upload function
      uploadPetDetailsAndMedia(
        petName,
        petType,
        int.parse(petAge),
        double.parse(petPrice),
        petDescription,
        _selectedGender,
        _mediaFiles,
      ).then((_) {
        setState(() {
          isSubmitting = false; // Hide loading indicator
        });

        // Show success message and reset form
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pet details uploaded successfully!')),
        );
        _resetForm();
      }).catchError((e) {
        setState(() {
          isSubmitting = false; // Hide loading indicator on error
        });

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading pet details: $e')),
        );
      });
    } else {
      // Show validation error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields, select a gender, and upload media')),
      );
    }
  }


  // Function to reset form
  void _resetForm() {
    _petNameController.clear();
    _petTypeController.clear();
    _petAgeController.clear();
    _petPriceController.clear();
    _petDescriptionController.clear();  // Clear description field
    setState(() {
      _mediaFiles.clear();
      _selectedPetType = 'Dog';  // Reset to default value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Pet Type Selector
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryButton('Dog', 'assets/dog.svg', _selectedPetType == 'Dog'),
                  _buildCategoryButton('Cat', 'assets/cat.svg', _selectedPetType == 'Cat'),
                  _buildCategoryButton('Parrot', "assets/parrot.svg", _selectedPetType == 'Parrot'),
                  _buildCategoryButton('Bunny', "assets/bunny.svg", _selectedPetType == 'Bunny'),
                  _buildCategoryButton('Hamster', "assets/hamster.svg", _selectedPetType == 'Hamster'),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Input Fields
            _buildCardedInputField(
              controller: _petNameController,
              label: 'Pet Name',
              isNumeric: false,
              prefixIcon: Icons.pets,
            ),
            _buildCardedInputField(
              controller: _petAgeController,
              label: 'Pet Age',
              isNumeric: true,
              prefixIcon: Icons.calendar_today,
            ),
            _buildCardedInputField(
              controller: _petPriceController,
              label: 'Pet Price',
              isNumeric: true,
              prefixIcon: Icons.attach_money,
            ),

            // Gender Selection
            _buildGenderSelector(),

            // Description Field
            _buildCardedInputField(
              controller: _petDescriptionController,
              label: 'Pet Description',
              isNumeric: false,
              prefixIcon: Icons.description,
            ),
            SizedBox(height: 20),

            // Media Picker
            MediaPicker(onPickMedia: _pickMedia),
            SizedBox(height: 20),
            _mediaFiles.isNotEmpty
                ? MediaGrid(mediaFiles: _mediaFiles)
                : Text(
              'No media selected',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),

            // Submit Button
            isSubmitting
                ? Center(child: CircularProgressIndicator())
                : SubmitButton(onSubmit: _submitPetDetails),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gender',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedGender = 'Male'),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: _selectedGender == 'Male' ? Colors.teal : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _selectedGender == 'Male'
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.male,
                            color: _selectedGender == 'Male' ? Colors.white : Colors.grey[500],
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Male',
                            style: TextStyle(
                              color: _selectedGender == 'Male' ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedGender = 'Female'),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: _selectedGender == 'Female' ? Colors.teal : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _selectedGender == 'Female'
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.female,
                            color: _selectedGender == 'Female' ? Colors.white : Colors.grey[500],
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Female',
                            style: TextStyle(
                              color: _selectedGender == 'Female' ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCategoryButton(String label, String svgAsset, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPetType = label; // Set selected pet type
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0), // Gap between buttons
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? Colors.teal : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ]
                    : [],
              ),
              child: Center(
                child: SvgPicture.asset(
                  svgAsset,
                  color: isSelected ? Colors.white : Colors.grey[500],
                  width: 32,
                  height: 32,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.teal : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardedInputField({
    required TextEditingController controller,
    required String label,
    required bool isNumeric,
    required IconData prefixIcon,
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
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(prefixIcon),
            border: InputBorder.none,            ),
        ),
      ),
    );
  }


}
