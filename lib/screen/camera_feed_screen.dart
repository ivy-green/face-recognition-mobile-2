import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CameraFeedScreen extends StatefulWidget {
  @override
  _CameraFeedScreenState createState() => _CameraFeedScreenState();
}

class _CameraFeedScreenState extends State<CameraFeedScreen> {
  late String _imageUrl = ''; // URL of the Flask API endpoint

  @override
  void initState() {
    super.initState();
    fetchCameraFeed();
  }

  Future<void> fetchCameraFeed() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:5000/camera/video_feed'));
      if (response.statusCode == 200) {
        setState(() {
          _imageUrl = response.body;
        });
      } else {
        throw Exception('Failed to load camera feed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching camera feed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Feed'),
      ),
      body: Center(
        child: _imageUrl.isNotEmpty
            ? Image.network(_imageUrl) // Display the image if URL is not empty
            : CircularProgressIndicator(), // Show loading indicator while fetching the image
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CameraFeedScreen(),
  ));
}
