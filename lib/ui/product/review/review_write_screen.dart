import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:look_talk/ui/common/component/common_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/ui/common/component/primary_button.dart';
import 'package:look_talk/view_model/product/review_viewmodel.dart';

class ReviewWriteScreen extends StatefulWidget {
  final String productId;

  const ReviewWriteScreen({super.key, required this.productId});

  @override
  State<ReviewWriteScreen> createState() => _ReviewWriteScreenState();
}

class _ReviewWriteScreenState extends State<ReviewWriteScreen> {
  final _contentController = TextEditingController();
  int _selectedRating = 5;
  final List<XFile> _images = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    if (_images.length >= 5) {
      CommonSnackBar.show(context, message: '이미지는 최대 5장까지 첨부할 수 있어요.');
      return;
    }

    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _images.add(picked);
      });
    }
  }

  Future<void> _submitReview() async {
    final vm = context.read<ReviewViewModel>();

    final files = await Future.wait(_images.map((xfile) async {
      return MultipartFile.fromFile(xfile.path, filename: xfile.name);
    }));

    final result = await vm.createReview(
      productId: widget.productId,
      rating: _selectedRating,
      content: _contentController.text.trim(),
      imageFiles: files,
    );

    if (result.success) {
      Navigator.pop(context); // 작성 완료 후 뒤로가기
    } else {
      CommonSnackBar.show(context, message: '${result.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('리뷰 작성')),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('별점', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(5, (index) {
                  final star = index + 1;
                  return IconButton(
                    icon: Icon(
                      _selectedRating >= star ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedRating = star;
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 16),
              Text('리뷰 내용', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: '리뷰를 입력해주세요',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text('이미지 첨부 (최대 5장)', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: [
                  ..._images.map((file) => Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.file(File(file.path),
                          width: 80, height: 80, fit: BoxFit.cover),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _images.remove(file);
                          });
                        },
                        child: Icon(Icons.cancel, color: Colors.red),
                      )
                    ],
                  )),
                  if (_images.length < 5)
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: Icon(Icons.add),
                      ),
                    )
                ],
              ),
              SizedBox(height: 24),
              PrimaryButton(
                text: '등록하기',
                onPressed: _submitReview,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
