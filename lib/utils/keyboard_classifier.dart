// import 'dart:io';
// import 'dart:typed_data';
// import 'package:tflite_flutter/tflite_flutter.dart';
//
// class KeyPointClassifier {
//   late Interpreter interpreter;
//   late List<dynamic> inputDetails;
//   late List<dynamic> outputDetails;
//   late int lastIndex;
//
//   late InterpreterOptions options;
//
//   KeyPointClassifier({
//     String modelPath = 'model/keypoint_classifier/keypoint_classifier.tflite',
//     int numThreads = 1,
//   }) {
//     File modelFile = File(modelPath);
//     options = InterpreterOptions()..threads = numThreads;
//
//     interpreter = Interpreter.fromFile(modelFile, options: options);
//     interpreter.allocateTensors();
//     inputDetails = interpreter.getInputTensors();
//     outputDetails = interpreter.getOutputTensors();
//     lastIndex = 2;
//   }
//
//   int call(List<double> landmarkList) {
//     interpreter.setTensor(inputDetails[0]['index'], Float32List.fromList([landmarkList]));
//     interpreter.invoke();
//
//     var result = interpreter.getTensor(outputDetails[0]['index']);
//
//     var maxResult = result[0].cast<double>().reduce((a, b) => a > b ? a : b);
//
//     print(maxResult);
//
//     if (maxResult >= 0.85) {
//       var resultIndex = result[0].indexOf(maxResult);
//       lastIndex = resultIndex;
//       return resultIndex;
//     } else {
//       return lastIndex;
//     }
//   }
// }
