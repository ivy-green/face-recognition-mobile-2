List<List<int>> calcLandmarkList(List<List<double>> landmarks, int imageWidth, int imageHeight) {
  List<List<int>> landmarkPoints = [];

  for (var landmark in landmarks) {
    int landmarkX = (landmark[0] * imageWidth).toInt().clamp(0, imageWidth - 1);
    int landmarkY = (landmark[1] * imageHeight).toInt().clamp(0, imageHeight - 1);

    landmarkPoints.add([landmarkX, landmarkY]);
  }

  return landmarkPoints;
}

List<double> preprocessLandmark(List<List<int>> landmarkList) {
  List<List<int>> tempLandmarkList = List.from(landmarkList);

  // Convert to relative coordinates
  int baseX = 0, baseY = 0;
  for (int index = 0; index < tempLandmarkList.length; index++) {
    List<int> landmarkPoint = tempLandmarkList[index];
    if (index == 0) {
      baseX = landmarkPoint[0];
      baseY = landmarkPoint[1];
    }

    tempLandmarkList[index][0] -= baseX;
    tempLandmarkList[index][1] -= baseY;
  }

  // Convert to a one-dimensional list
  List<int> flattenedList = [];
  for (int index = 0; index < tempLandmarkList.length; index++) {
    flattenedList.addAll(tempLandmarkList[index]);
  }

  // Normalization
  int maxValue = flattenedList.map((e) => e.abs()).reduce((a, b) => a > b ? a : b);

  List<double> normalizedList = flattenedList.map((n) => n / maxValue).toList();

  return normalizedList;
}
