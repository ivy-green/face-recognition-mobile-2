import 'package:facial_expression_app/screen/camera_feed_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'face_detector_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Face detector"),
      ),
      body: _body(),
    );
  }

  Widget _body() => Center(
        child: SizedBox(
          width: 350,
          height: 80,
          child: OutlinedButton(
            style: ButtonStyle(
              side: MaterialStateProperty.all(const BorderSide(
                color: Colors.blue,
                width: 1.0,
                style: BorderStyle.solid,
              )),
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        // const FaceDetectorPage())),
                        CameraFeedScreen())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIconWidget(Icons.arrow_forward_ios),
                const Text(
                  'Go to Face Detector',
                  style: TextStyle(fontSize: 20),
                ),
                _buildIconWidget(Icons.arrow_back_ios),
              ],
            ),
          ),
        ),
      );

  Widget _buildIconWidget(final IconData icon) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Icon(icon, size: 24),
      );
}
