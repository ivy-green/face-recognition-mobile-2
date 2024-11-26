import 'dart:math';

import 'package:facial_expression_app/utils/coordinate_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorPainter extends CustomPainter {
  final List<Face> faces;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final List<String> predictedExpressions;

  FaceDetectorPainter(
    this.faces,
    this.absoluteImageSize,
    this.rotation,
    this.predictedExpressions,
  );

  @override
  void paint(final Canvas canvas, final Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.blue;

    for (int i = 0; i < faces.length; i++) {
      final Face face = faces[i];
      final String expression = predictedExpressions[i];

      void paintContour(final FaceContourType type) {
        final FaceContour? faceContour = face.contours[type];
        if (faceContour != null) {
          for (final Point point in faceContour.points) {
            canvas.drawCircle(
              Offset(
                translateX(point.x.toDouble(), rotation, size, absoluteImageSize),
                translateY(point.y.toDouble(), rotation, size, absoluteImageSize),
              ),
              1.0,
              paint,
            );
          }
        }
      }

      paintContour(FaceContourType.face);
      paintContour(FaceContourType.leftEyebrowTop);
      paintContour(FaceContourType.leftEyebrowBottom);
      paintContour(FaceContourType.rightEyebrowTop);
      paintContour(FaceContourType.rightEyebrowBottom);
      paintContour(FaceContourType.leftEye);
      paintContour(FaceContourType.rightEye);
      paintContour(FaceContourType.upperLipTop);
      paintContour(FaceContourType.upperLipBottom);
      paintContour(FaceContourType.lowerLipTop);
      paintContour(FaceContourType.lowerLipBottom);
      paintContour(FaceContourType.noseBridge);
      paintContour(FaceContourType.noseBottom);
      paintContour(FaceContourType.leftCheek);
      paintContour(FaceContourType.rightCheek);

      // Draw the predicted expression text on the face
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: expression,
          style: TextStyle(
            color: Colors.red,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          face.boundingBox.left + 10,
          face.boundingBox.top - 20,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(final FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces ||
        oldDelegate.predictedExpressions != predictedExpressions;
  }
}

// class FaceDetectorPainter extends CustomPainter {
//   final List<Face> faces;
//   final Size absoluteImageSize;
//   final InputImageRotation rotation;
//   final List<String> predictedExpressions;
//
//   FaceDetectorPainter(
//     this.faces,
//     this.absoluteImageSize,
//     this.rotation,
//     this.predictedExpressions,
//   );
//
//   @override
//   void paint(final Canvas canvas, final Size size) {
//     final Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0
//       ..color = Colors.blue;
//     for (int i = 0; i < faces.length; i++) {
//       final Face face = faces[i];
//       final String expression = predictedExpressions[i];
//
//       // canvas.drawRect(
//       //     Rect.fromLTRB(
//       //       translateX(face.boundingBox.left, rotation, size, absoluteImageSize),
//       //       translateY(face.boundingBox.top, rotation, size, absoluteImageSize),
//       //       translateX(face.boundingBox.right, rotation, size, absoluteImageSize),
//       //       translateY(face.boundingBox.bottom, rotation, size, absoluteImageSize),
//       //     ),
//       //     paint);
//
//       // draw blue circle for detected points of the face
//       void paintContour(final FaceContourType type) {
//         final faceContour = face.contours[type];
//         //
//         if (faceContour?.points != null) {
//           for (final Point point in faceContour!.points) {
//             canvas.drawCircle(
//                 Offset(translateX(point.x.toDouble(), rotation, size, absoluteImageSize),
//                     translateY(point.y.toDouble(), rotation, size, absoluteImageSize)),
//                 1.0,
//                 paint);
//           }
//         }
//       }
//
//       paintContour(FaceContourType.face);
//       paintContour(FaceContourType.leftEyebrowTop);
//       paintContour(FaceContourType.leftEyebrowBottom);
//       paintContour(FaceContourType.rightEyebrowTop);
//       paintContour(FaceContourType.rightEyebrowBottom);
//       paintContour(FaceContourType.leftEye);
//       paintContour(FaceContourType.rightEye);
//       paintContour(FaceContourType.upperLipTop);
//       paintContour(FaceContourType.upperLipBottom);
//       paintContour(FaceContourType.lowerLipTop);
//       paintContour(FaceContourType.lowerLipBottom);
//       paintContour(FaceContourType.noseBridge);
//       paintContour(FaceContourType.noseBottom);
//       paintContour(FaceContourType.leftCheek);
//       paintContour(FaceContourType.rightCheek);
//
//       // Draw the predicted expression text on the face
//       final TextPainter textPainter = TextPainter(
//         text: TextSpan(
//           text: expression,
//           style: TextStyle(
//             color: Colors.red,
//             fontSize: 14.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         textDirection: TextDirection.ltr,
//       );
//
//       textPainter.layout();
//       textPainter.paint(
//         canvas,
//         Offset(
//           face.boundingBox.left + 10,
//           face.boundingBox.top - 20,
//         ),
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(final FaceDetectorPainter oldDelegate) {
//     return oldDelegate.absoluteImageSize != absoluteImageSize || oldDelegate.faces != faces;
//   }
// }
