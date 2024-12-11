import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_store/Models/petPosts.dart';
import 'package:pet_store/widgets/CustomAppBar.dart';
import '../Services/getPostsForBuyers.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widgets/Drawer.dart';
import 'PetDetialsScreen.dart';

class BuyerScreen extends StatefulWidget {
  const BuyerScreen({Key? key}) : super(key: key);

  @override
  _BuyerScreenState createState() => _BuyerScreenState();
}

class _BuyerScreenState extends State<BuyerScreen> {
  static const _pageSize = 10;
  final PagingController<int, DocumentSnapshot> _pagingController =
  PagingController(firstPageKey: 0);

  String _selectedPetType = '';
  RangeValues _selectedPriceRangeValues = RangeValues(0, 10000);
  RangeValues _selectedAgeRangeValues = RangeValues(0, 20);

  final double _minPrice = 0;
  final double _maxPrice = 10000;
  final double _minAge = 0;
  final double _maxAge = 20;

  String _selectedGender = "";

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      Getpostsforbuyers.fetchPosts(
        pagingController: _pagingController,
        selectedPetType: _selectedPetType,
        selectedPriceRangeValues: _selectedPriceRangeValues,
        selectedAgeRangeValues: _selectedAgeRangeValues,
        selectedGender: _selectedGender
      );
    });


  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _showFilterPanel() async {
    String tempSelectedPetType = _selectedPetType;
    RangeValues tempSelectedPriceRange = _selectedPriceRangeValues;
    RangeValues tempSelectedAgeRange = _selectedAgeRangeValues;
    String tempSelectedGender = ''; 

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
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
                    SizedBox(height: 24),

                     
                    Center(
                      child: Text(
                        'Filter Options',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                     
                    Text(
                      'Select Gender',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setModalState(() {
                                tempSelectedGender = tempSelectedGender == 'Male' ? '' : 'Male';
                              });
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: tempSelectedGender == 'Male'
                                    ? Colors.teal
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: tempSelectedGender == 'Male'
                                    ? [
                                  BoxShadow(
                                    color: Colors.teal.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  )
                                ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.male,
                                    color: tempSelectedGender == 'Male'
                                        ? Colors.white
                                        : Colors.grey[600],
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Male',
                                    style: TextStyle(
                                      color: tempSelectedGender == 'Male'
                                          ? Colors.white
                                          : Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),

                         
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setModalState(() {
                                tempSelectedGender = tempSelectedGender == 'Female' ? '' : 'Female';
                              });
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: tempSelectedGender == 'Female'
                                    ? Colors.teal
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: tempSelectedGender == 'Female'
                                    ? [
                                  BoxShadow(
                                    color: Colors.teal.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  )
                                ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.female,
                                    color: tempSelectedGender == 'Female'
                                        ? Colors.white
                                        : Colors.grey[600],
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Female',
                                    style: TextStyle(
                                      color: tempSelectedGender == 'Female'
                                          ? Colors.white
                                          : Colors.grey[600],
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
                    SizedBox(height: 24),

                     
                    Text(
                      'Price Range',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${tempSelectedPriceRange.start.toInt()}',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                        Text('\$${tempSelectedPriceRange.end.toInt()}',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.teal,
                        inactiveTrackColor: Colors.grey[300],
                        thumbColor: Colors.teal,
                        overlayColor: Colors.teal.withOpacity(0.2),
                        trackHeight: 3.0,
                      ),
                      child: RangeSlider(
                        values: tempSelectedPriceRange,
                        min: _minPrice,
                        max: _maxPrice,
                        divisions: 100,
                        labels: RangeLabels(
                          '\$${tempSelectedPriceRange.start.toInt()}',
                          '\$${tempSelectedPriceRange.end.toInt()}',
                        ),
                        onChanged: (RangeValues values) {
                          setModalState(() {
                            tempSelectedPriceRange = values;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 24),

                     
                    Text(
                      'Age Range',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${tempSelectedAgeRange.start.toInt()} years',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                        Text('${tempSelectedAgeRange.end.toInt()} years',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.teal,
                        inactiveTrackColor: Colors.grey[300],
                        thumbColor: Colors.teal,
                        overlayColor: Colors.teal.withOpacity(0.2),
                        trackHeight: 3.0,
                      ),
                      child: RangeSlider(
                        values: tempSelectedAgeRange,
                        min: _minAge,
                        max: _maxAge,
                        divisions: 20,
                        labels: RangeLabels(
                          '${tempSelectedAgeRange.start.toInt()}',
                          '${tempSelectedAgeRange.end.toInt()}',
                        ),
                        onChanged: (RangeValues values) {
                          setModalState(() {
                            tempSelectedAgeRange = values;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 24),

                     
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempSelectedPetType = '';
                              tempSelectedPriceRange =
                                  RangeValues(_minPrice, _maxPrice);
                              tempSelectedAgeRange = RangeValues(_minAge, _maxAge);
                              tempSelectedGender = '';
                            });
                          },
                          child: Text(
                            'Reset',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedPetType = tempSelectedPetType;
                              _selectedPriceRangeValues = tempSelectedPriceRange;
                              _selectedAgeRangeValues = tempSelectedAgeRange;
                              _selectedGender = tempSelectedGender;
                            });
                            Navigator.pop(context);
                            _pagingController.refresh();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 12.0),
                          ),
                          child: Text('Apply Filters'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScreenContent(
      selectedPetType: _selectedPetType,
      pagingController: _pagingController,
      showFilterPanel: _showFilterPanel,
      buildCategoryButton: _buildCategoryButton,
    );
  }




  Widget _buildCategoryButton(String label, String svgAsset, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPetType = isSelected ? '' : label;  
          _pagingController.refresh();  
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),  
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
                fontSize: 8,  
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.teal : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
class MainScreenContent extends StatefulWidget {
  final String selectedPetType;
  final PagingController<int, DocumentSnapshot> pagingController;
  final Function showFilterPanel;
  final Function buildCategoryButton;

  const MainScreenContent({
    Key? key,
    required this.selectedPetType,
    required this.pagingController,
    required this.showFilterPanel,
    required this.buildCategoryButton,
  }) : super(key: key);

  @override
  State<MainScreenContent> createState() => _MainScreenContentState();
}

class _MainScreenContentState extends State<MainScreenContent> {
  String searchQuery = '';
  String selectedPetType = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget.showFilterPanel(),
        child: Icon(
          Icons.filter_list,
          size: 28,
        ),
        backgroundColor: Colors.teal,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tooltip: 'Filter',
      ),
      body: Column(
        children: [
           
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 
                TextField(onChanged: (value) {
    setState(() {
    searchQuery = value.toLowerCase();
    widget.pagingController.refresh();
    });
    },
                  decoration: InputDecoration(
                    hintText: 'Search pet to adopt',
                    prefixIcon: Icon(Icons.search, color: Colors.teal),
                    suffixIcon: Icon(Icons.tune, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                 
                SizedBox(
                  height: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      widget.buildCategoryButton('Cat', "assets/cat.svg", widget.selectedPetType == 'Cat'),
                      SizedBox(width: 10),
                      widget.buildCategoryButton('Dog', "assets/dog.svg", widget.selectedPetType == 'Dog'),
                      SizedBox(width: 10),
                      widget.buildCategoryButton('Parrot', "assets/parrot.svg", widget.selectedPetType == 'Parrot'),
                      SizedBox(width: 10),
                      widget.buildCategoryButton('Bunny', "assets/bunny.svg", widget.selectedPetType == 'Bunny'),
                      SizedBox(width: 10),
                      widget.buildCategoryButton('Hamster', "assets/hamster.svg" , widget.selectedPetType == 'Hamster'),
                    ],
                  ),
                ),
              ],
            ),
          ),

           
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                widget.pagingController.refresh();  
                await Future.delayed(Duration(seconds: 2));
              },
              child: PagedListView<int, DocumentSnapshot>(
                pagingController: widget.pagingController,
                builderDelegate: PagedChildBuilderDelegate<DocumentSnapshot>(
                  itemBuilder: (context, post, index) {
                    PetPost petPost = PetPost.fromFirestore(post);
                    if (!petPost.petName.toLowerCase().contains(searchQuery)) {
                      return SizedBox.shrink();  
                    }
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PetDetailScreen(petPost: petPost),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: petPost.mediaUrls.isNotEmpty
                                    ? CachedNetworkImage(
                                  imageUrl: petPost.mediaUrls[0],
                                  width: 110,
                                  height: 190,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: CircularProgressIndicator(color: Colors.teal),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                )
                                    : Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.grey[700],
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),

                               
                              Expanded(
                                child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: 150,  
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                         
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                             
                                            Expanded(
                                              child: Text(
                                                petPost.petName,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  letterSpacing: 0.5,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(width: 8),

                                             
                                            Icon(
                                              petPost.petGender == 'Male' ? Icons.male : Icons.female,
                                              color: petPost.petGender == 'Male' ? Colors.blue : Colors.pink,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),

                                         
                                        Text(
                                          petPost.petType,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8),

                                         
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Age: ${petPost.petAge}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              '\$${petPost.petPrice}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
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
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
