// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumCarouselModel _$AlbumCarouselModelFromJson(Map<String, dynamic> json) =>
    AlbumCarouselModel(
      (json['image'] as List<dynamic>).map((e) => e as String).toList(),
      (json['voice'] as List<dynamic>).map((e) => e as String).toList(),
      (json['bgm'] as List<dynamic>).map((e) => e as String).toList(),
      json['interval'] as int,
    );

Map<String, dynamic> _$AlbumCarouselModelToJson(AlbumCarouselModel instance) =>
    <String, dynamic>{
      'image': instance.image,
      'voice': instance.voice,
      'bgm': instance.bgm,
      'interval': instance.interval,
    };
