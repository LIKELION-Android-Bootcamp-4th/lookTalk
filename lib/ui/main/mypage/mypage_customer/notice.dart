import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/model/entity/notice_entity.dart';
import 'package:look_talk/model/notice_dummy.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/notice_detail_screen.dart';

class Notice extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final List<NoticeEntity> noticeList = noticeEntity;
    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric( vertical: 24),
      child:
      ListView.builder(
        itemCount: noticeList.length,
        itemBuilder: (context, index) {
          final notice = noticeList[index];

          return GestureDetector(
            onTap: () {
              // 인덱스 값 사용
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NoticeDetailScreen(
                    notice: notice,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notice.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodyBold,
                      ),
                    ),
                    gap24,
                    Text(notice.currentAt),
                  ],
                ),
                gap8,
                const Divider(color: Colors.black, thickness: 1),
              ],
            ),
          );
        },
      ),
          ),
    );
  }
}