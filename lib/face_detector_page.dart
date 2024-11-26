import 'package:camera/camera.dart';
import 'package:facial_expression_app/CameraView.dart';
import 'package:facial_expression_app/utils/face_detector.dart';
import 'package:facial_expression_app/utils/face_deteector_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({super.key});

  @override
  State<FaceDetectorPage> createState() => _FaceDetectorPageState();
}

class _FaceDetectorPageState extends State<FaceDetectorPage> {
  late FaceDetector _faceDetector;
  late FacialExpressionPredictor _expressionPredictor;

  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  @override
  void initState() {
    super.initState();
    _initializeModels();
  }

  Future<void> _initializeModels() async {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
      ),
    );

    _expressionPredictor = await FacialExpressionPredictor.create(
      modelPath: 'path_to_your_model.tflite',
      labels: ['Happy', 'Sad', 'Neutral', 'Angry', 'Surprised'],
    );
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Face detector',
      customPaint: _customPaint,
      text: _text,
      onImage: (inputImage) {
        processImage(inputImage);
      },
      initialDirection: CameraLensDirection.front,
    );
  }

  Future<void> processImage(final InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });

    final faces = await _faceDetector.processImage(inputImage);

    if (inputImage.inputImageData?.size != null && inputImage.inputImageData?.imageRotation != null) {
      final expressions = await predictExpressions(faces);
      final painter = FaceDetectorPainter(
        faces,
        inputImage.inputImageData!.size,
        inputImage.inputImageData!.imageRotation,
        expressions,
      );

      // final expressions = await predictExpressions(faces);
      // final text = expressions.join('\n');

      _customPaint = CustomPaint(
        painter: painter,
      );
      // _text = text;
    } else {
      String text = 'Face found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'Face: ${face.boundingBox}\n\n';
      }
      _text = text;
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<List<String>> predictExpressions(List<Face> faces) async {
    final expressions = <String>[];
    for (final face in faces) {
      final landmarks = getLandmarkCoordinates(face);
      final expression = await _expressionPredictor.predict(landmarks);
      expressions.add('Predicted expression: $expression');
    }
    return expressions;
  }

  List<List<int>> getLandmarkCoordinates(Face face) {
    final List<List<int>> landmarkCoordinates = [];

    for (final contour in face.contours.values) {
      if (contour != null) {
        for (final point in contour.points) {
          landmarkCoordinates.add([point.x.toInt(), point.y.toInt()]);
        }
      }
    }

    return landmarkCoordinates;
  }
}

// class _FaceDetectorPageState extends State<FaceDetectorPage> {
//   // create face detecto object
//   final FaceDetector _faceDetector = FaceDetector(
//       options: FaceDetectorOptions(
//     enableContours: true,
//     enableClassification: true,
//   ));
//
//   bool _canProcess = true;
//   bool _isBusy = false;
//   CustomPaint? _customPaint;
//   String? _text;
//
//   @override
//   void dispose() {
//     _canProcess = false;
//     _faceDetector.close();
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CameraView(
//       title: 'Face detector',
//       customPaint: _customPaint,
//       text: _text,
//       onImage: (inputImage) {
//         processImage(inputImage);
//       },
//       initialDirection: CameraLensDirection.front,
//     );
//   }
//
//   Future<void> processImage(final InputImage inputImage) async {
//     if (!_canProcess) return;
//     if (_isBusy) return;
//     _isBusy = true;
//     setState(() {
//       _text = '';
//     });
//     final faces = await _faceDetector.processImage(inputImage);
//     if (inputImage.inputImageData?.size != null &&
//         inputImage.inputImageData?.imageRotation != null) {
//       final painter =
//           FaceDetectorPainter(faces, inputImage.inputImageData!.size,
//               inputImage.inputImageData!.imageRotation);
//       _customPaint = CustomPaint(
//         painter: painter,
//       );
//     } else {
//       String text = 'face found: ${faces.length}\n\n';
//       for (final face in faces) {
//         text += 'face: ${face.boundingBox}\n\n';
//       }
//       _text = text;
//       _customPaint = null;
//     }
//     _isBusy = false;
//     if (mounted) {
//       setState(() {});
//     }
//   }
// }
