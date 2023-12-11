// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plant _$PlantFromJson(Map<String, dynamic> json) => Plant(
      json['fid'] as int?,
      json['name'] as String,
      json['health'] as String,
      json['image'] as String,
      json['ml_per_watering'] as int,
    )
      ..monday = json['monday'] as bool
      ..tuesday = json['tuesday'] as bool
      ..wednesday = json['wednesday'] as bool
      ..thursday = json['thursday'] as bool
      ..friday = json['friday'] as bool
      ..saturday = json['saturday'] as bool
      ..sunday = json['sunday'] as bool;

Map<String, dynamic> _$PlantToJson(Plant instance) => <String, dynamic>{
      'fid': instance.fid,
      'name': instance.name,
      'health': instance.health,
      'image': instance.image,
      'ml_per_watering': instance.ml_per_watering,
      'monday': instance.monday,
      'tuesday': instance.tuesday,
      'wednesday': instance.wednesday,
      'thursday': instance.thursday,
      'friday': instance.friday,
      'saturday': instance.saturday,
      'sunday': instance.sunday,
    };
