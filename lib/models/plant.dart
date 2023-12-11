import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'plant.g.dart';

@JsonSerializable()
class Plant{
  Plant(this.fid,this.name,this.health,this.image,this.ml_per_watering);

  late int? fid;
  late String name;
  late String health;
  late String image;
  late int ml_per_watering;
  late bool monday;
  late bool tuesday;
  late bool wednesday;
  late bool thursday;
  late bool friday;
  late bool saturday;
  late bool sunday;

  factory Plant.fromJson(Map<String, dynamic> json) => _$PlantFromJson(json);

  Map<String, dynamic> toJson() => _$PlantToJson(this);

}