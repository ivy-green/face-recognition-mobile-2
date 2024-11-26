import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';

class FacialExpressionPredictor {
  final Interpreter interpreter;
  final List<String> labels;

  FacialExpressionPredictor._(this.interpreter, this.labels);

  static Future<FacialExpressionPredictor> create({
    required String modelPath,
    required List<String> labels,
  }) async {
    final interpreter = await Interpreter.fromAsset(modelPath);
    return FacialExpressionPredictor._(interpreter, labels);
  }

  Future<String> predict(List<List<int>> landmarkList) async {
    // Preprocess landmark coordinates
    final input = preprocessLandmark(landmarkList);

    // Run inference
    final output = List.filled(1, List.filled(labels.length, 0.0));
    interpreter.run(input, output);

    // Postprocess output
    final prediction = output[0].cast<double>();
    final maxIndex = prediction.indexOf(prediction.reduce((curr, next) => curr > next ? curr : next));
    return labels[maxIndex];
  }

  Uint8List preprocessLandmark(List<List<int>> landmarkList) {
    // Perform preprocessing
    // Convert to a one-dimensional list
    List<int> flattenedList = [];
    for (int index = 0; index < landmarkList.length; index++) {
      flattenedList.addAll(landmarkList[index]);
    }

    // Convert to Float32List
    return Float32List.fromList(flattenedList.map((e) => e.toDouble()).toList()).buffer.asUint8List();
  }
}
