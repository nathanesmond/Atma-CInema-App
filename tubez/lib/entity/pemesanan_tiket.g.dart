// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pemesanan_tiket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PemesananTiket _$PemesananTiketFromJson(Map<String, dynamic> json) =>
    PemesananTiket(
      id: (json['id'] as num?)?.toInt() ?? null,
      idJadwalTayang: (json['idJadwalTayang'] as num).toInt(),
      kursiDipesan: (json['kursiDipesan'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PemesananTiketToJson(PemesananTiket instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idJadwalTayang': instance.idJadwalTayang,
      'kursiDipesan': instance.kursiDipesan,
    };
