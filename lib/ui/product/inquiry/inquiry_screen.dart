import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/view_model/inquiry/inquiry_viewmodel.dart';

class InquiryScreen extends StatelessWidget {
  final TextEditingController _inquiryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('문의'),
      ),
      body: Consumer<InquiryViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Expanded로 ListView를 감싸서 크기 제한
              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.inquiries.isEmpty
                    ? const Center(child: Text('등록된 문의가 없습니다.'))
                    : ListView.builder(
                  shrinkWrap: true, // ListView 크기를 자식 크기에 맞게 설정
                  itemCount: viewModel.inquiries.length,
                  itemBuilder: (context, index) {
                    final inquiry = viewModel.inquiries[index];
                    return ListTile(
                      title: Text(inquiry.content),
                      subtitle: Text('작성일: ${inquiry.createdAt}'),
                    );
                  },
                ),
              ),

              // 문의 내용 입력창
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _inquiryController,
                  decoration: const InputDecoration(
                    hintText: '문의 내용을 입력하세요',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              // 문의 작성 버튼
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_inquiryController.text.isNotEmpty) {
                      viewModel.createInquiry(_inquiryController.text);
                      _inquiryController.clear();
                    }
                  },
                  child: const Text('문의 작성'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
