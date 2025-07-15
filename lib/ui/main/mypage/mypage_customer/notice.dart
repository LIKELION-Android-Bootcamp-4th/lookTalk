import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/notice_detail_screen.dart';
import 'package:look_talk/view_model/mypage_view_model/notice_viewmodel.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoticeViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vm.notices.isEmpty && !vm.isLoading) {
        vm.loadNotices(); // ✅ 요게 필요했음
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        itemCount: vm.notices.length,
        separatorBuilder: (_, __) => const Divider(color: Colors.black),
        itemBuilder: (context, index) {
          final notice = vm.notices[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NoticeDetailScreen(notice: notice),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      notice.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.bodyBold,
                    ),
                  ),
                  gap16,
                  Text(_formatDate(notice.currentAt)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String rawDate) {
    try {
      final parsedDate = DateTime.parse(rawDate);
      return DateFormat('yyyy.MM.dd').format(parsedDate);
    } catch (_) {
      return rawDate; // 파싱 실패 시 원본 그대로
    }
  }

}