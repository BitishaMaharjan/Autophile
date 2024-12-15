// import 'package:autophile/widgets/app_button.dart';
// import 'package:flutter/material.dart';
//
// class ReportProblemScreen extends StatefulWidget {
//   const ReportProblemScreen({super.key});
//
//   @override
//   ReportProblemScreenState createState() => ReportProblemScreenState();
// }
//
// class ReportProblemScreenState extends State<ReportProblemScreen> {
//   final TextEditingController _descriptionController = TextEditingController();
//   String _selectedProblemType = 'Bug';
//   final List<String> _problemTypes = ['Bug', 'Performance Issue', 'UI Issue', 'Other'];
//
//   void _submitReport() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Problem reported: $_selectedProblemType')),
//     );
//   }
//
//   void _attachScreenshot() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Screenshot attached')),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Report a Problem'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Select Problem Type',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 10),
//             DropdownButtonFormField<String>(
//               value: _selectedProblemType,
//               items: _problemTypes.map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedProblemType = value!;
//                 });
//               },
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Describe the Problem',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _descriptionController,
//               maxLines: 5,
//               decoration: InputDecoration(
//                 hintText: 'Please describe the issue you’re experiencing...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 contentPadding: const EdgeInsets.all(12),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: _attachScreenshot,
//               icon: const Icon(Icons.camera_alt, size: 24),
//               label: const Text('Attach Screenshot', style: TextStyle(fontSize: 16)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Theme.of(context).colorScheme.onPrimary,
//                 padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 2,
//               ),
//             ),
//             const SizedBox(height: 30),
//             AppButton(text: "Submit", onTap: _submitReport),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:autophile/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  ReportProblemScreenState createState() => ReportProblemScreenState();
}

class ReportProblemScreenState extends State<ReportProblemScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedProblemType = 'Bug';
  final List<String> _problemTypes = ['Bug', 'Performance Issue', 'UI Issue', 'Other'];
  File? _screenshotFile;

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickScreenshot() async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _screenshotFile = File(pickedFile.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Screenshot attached')),
      );
    }
  }

  String? _convertToBase64(File? file) {
    if (file == null) return null;
    final bytes = file.readAsBytesSync();
    return base64Encode(bytes);
  }

  Future<void> _submitReport() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a description.')),
      );
      return;
    }

    String? base64Image = _convertToBase64(_screenshotFile);

    final reportData = {
      'problemType': _selectedProblemType,
      'description': _descriptionController.text,
      'screenshotBase64': base64Image,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance.collection('reportProblem').add(reportData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Problem reported successfully!')),
    );

    _descriptionController.clear();
    setState(() {
      _screenshotFile = null;
      _selectedProblemType = 'Bug';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report a Problem'),
      ),
      body:
          SafeArea(child:
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Problem Type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedProblemType,
                    items: _problemTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProblemType = value!;
                      });
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary, // Correct usage
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary, // For focused border
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Describe the Problem',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary, // Correct usage
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary, // For focused border
                        ),
                      ),
                      hintText: 'Please describe the issue you’re experiencing...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_screenshotFile != null)
                    Column(
                      children: [
                        Image.file(
                          _screenshotFile!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ElevatedButton.icon(
                    onPressed: _pickScreenshot,
                    icon: const Icon(Icons.camera_alt, size: 24),
                    label: const Text('Attach Screenshot', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AppButton(text: "Submit", onTap: _submitReport),
                ],
              ),
            ),
          )
          )
      ,
    );
  }
}
