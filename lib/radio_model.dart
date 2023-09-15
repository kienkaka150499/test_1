import 'package:equatable/equatable.dart';
import 'package:flutter_radio_player/models/frp_source_modal.dart';

class RadioModel extends Equatable{
  final String name;
  final String location;
  final String url;



  @override
  List<Object?> get props => [];

  const RadioModel({
    required this.name,
    required this.location,
    required this.url,
  });

  RadioModel copyWith({
    String? name,
    String? location,
    String? url,
  }) {
    return RadioModel(
      name: name ?? this.name,
      location: location ?? this.location,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'location': this.location,
      'url': this.url,
    };
  }

  factory RadioModel.fromMap(Map<String, dynamic> map) {
    return RadioModel(
      name: map['name'] as String,
      location: (map['state']??"") + ' ' + (map['country']??'') ,
      url: map['url'] as String,
    );
  }

  MediaSources toMediaSource(){
    return MediaSources(isPrimary: false,title: name,description: location,url: url, isAac: true);
  }
}