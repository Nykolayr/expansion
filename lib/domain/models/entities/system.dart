// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'system.g.dart';

@JsonSerializable()
class System {
  String name;
  String starName;
  double diametr;
  System({
    required this.name,
    required this.starName,
    required this.diametr,
  });
  factory System.fromJson(Map<String, dynamic> json) => _$SystemFromJson(json);
  Map<String, dynamic> toJson() => _$SystemToJson(this);
}
