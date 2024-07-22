
import 'package:json_annotation/json_annotation.dart';
part 'album.g.dart';


@JsonSerializable(explicitToJson: true)
class AlbumCarouselModel {
  final List<String> image;
  final List<String> voice;
  final List<String> bgm;
  final int interval;

  AlbumCarouselModel(this.image, this.voice, this.bgm, this.interval);

  factory AlbumCarouselModel.fromJson(Map<String, dynamic> json) => _$AlbumCarouselModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AlbumCarouselModelToJson(this);
}