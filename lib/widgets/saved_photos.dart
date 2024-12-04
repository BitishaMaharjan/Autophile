import 'package:flutter/material.dart';

class SavedPhotosWidget extends StatelessWidget {
  SavedPhotosWidget({required this.savedPhotos});
  final List<Map<String, String>> savedPhotos;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2; // Adjust grid columns for larger screens

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true, // Allows grid to fit within a scrollable layout
        physics: NeverScrollableScrollPhysics(), // Prevents internal scrolling
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount, // Number of columns
          crossAxisSpacing: 14.0, // Space between columns
          mainAxisSpacing: 20.0, // Space between rows
          childAspectRatio: 0.8, // Adjust item height-to-width ratio
        ),
        itemCount: savedPhotos.length,
        itemBuilder: (context, index) {
          final photo = savedPhotos[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    photo['image']!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                photo['name']!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}
