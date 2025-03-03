class YogaPoseModel {
  final String name; // ชื่อท่าโยคะ
  final String exerciseType; // ประเภทการออกกำลังกาย
  final int duration; // ระยะเวลา (วินาที)
  final int calories; // แคลอรีที่เผาผลาญ
  final String difficulty; // ระดับความยาก
  final DateTime date; // วันที่ฝึก

  YogaPoseModel({
    required this.name,
    required this.exerciseType,
    required this.duration,
    required this.calories,
    required this.difficulty,
    required this.date,
  });
}