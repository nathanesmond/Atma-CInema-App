// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tiket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tiket _$TiketFromJson(Map<String, dynamic> json) => Tiket(
      (json['idTiket'] as num).toInt(),
      (json['harga'] as num).toDouble(),
      json['kursi'] as String,
    );

Map<String, dynamic> _$TiketToJson(Tiket instance) => <String, dynamic>{
      'idTiket': instance.idTiket,
      'kursi': instance.kursi,
      'harga': instance.harga,
    };
