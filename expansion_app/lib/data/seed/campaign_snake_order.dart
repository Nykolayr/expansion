/// Порядок миссий на карте: змейка по рядам по 5 узлов.
abstract final class CampaignSnakeOrder {
  static List<int> buildJsonIndices(int missionCount) {
    final result = <int>[];
    var row = 0;
    while (result.length < missionCount) {
      final rowStart = row * 5;
      final rowEnd = (rowStart + 5).clamp(0, missionCount);
      if (rowStart >= missionCount) break;

      var rowIndices = List.generate(rowEnd - rowStart, (i) => rowStart + i);
      if (row.isOdd) {
        rowIndices = rowIndices.reversed.toList();
      }
      result.addAll(rowIndices);
      row++;
    }
    return result;
  }
}
