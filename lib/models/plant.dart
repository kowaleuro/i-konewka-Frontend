import 'dart:convert';
import 'dart:typed_data';

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
  late int monday;
  late int tuesday;
  late int wednesday;
  late int thursday;
  late int friday;
  late int saturday;
  late int sunday;

  factory Plant.fromJson(Map<String, dynamic> json) => _$PlantFromJson(json);

  Map<String, dynamic> toJson() => _$PlantToJson(this);

  List<int> getWateringList(){
    var waterList = List<int>.empty();

    waterList.add(monday);
    waterList.add(tuesday);
    waterList.add(wednesday);
    waterList.add(thursday);
    waterList.add(friday);
    waterList.add(saturday);
    waterList.add(sunday);

    return waterList;
  }

  void setWateringDays(List<int> waterList){
    monday = waterList[0];
    tuesday = waterList[1];
    wednesday = waterList[2];
    thursday = waterList[3];
    friday = waterList[4];
    saturday = waterList[5];
    sunday = waterList[6];
  }

  Uint8List getImageWidget(){
    return const Base64Decoder().convert(image);
  }

}