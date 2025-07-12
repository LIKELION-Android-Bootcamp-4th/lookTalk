import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/model/entity/notice_entity.dart';
import 'package:look_talk/ui/common/const/gap.dart';

class NoticeDetailScreen extends StatelessWidget {
  final NoticeEntity notice;

  const NoticeDetailScreen({required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공지사항"),
        centerTitle: true,
      ),
      body: Padding(

          padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gap32,
                    Text("${notice.title}",
                      style: context.bodyBold,),
                    gap32,
                    Text("${notice.currentAt}"),
                    gap32,
                    Text("${notice.content}")


                  ],
                ),
              )

      )

    );
  }
}