import 'package:look_talk/model/entity/notice_entity.dart';

class NoticeDto {
  final String id;
  final String title;
  final String content;
  final String createdAt;

  NoticeDto({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory NoticeDto.fromJson(Map<String, dynamic> json) {
    return NoticeDto(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: json['createdAt'],
    );
  }

  NoticeEntity toEntity() {
    return NoticeEntity(
      id: id,
      title: title,
      content: content,
      currentAt: createdAt,
    );
  }
}