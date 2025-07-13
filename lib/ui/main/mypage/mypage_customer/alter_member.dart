import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/core/theme/app_theme.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_search_cart.dart';
import 'package:look_talk/ui/common/component/common_text_field.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:look_talk/view_model/mypage_view_model/alter_member_viewmodel.dart';
import 'package:provider/provider.dart';

class AlterMember extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    return AlterMemberState();
  }
}

class AlterMemberState extends State<AlterMember> {

  String? profileImagePath;
  ImagePicker picker = ImagePicker();
  late TextEditingController _nicknameController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nicknameController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    final thema = AppTheme.light();
    final viewModel = context.watch<AlterMemberViewmodel>();
    final member = viewModel.alterMember?.member;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }
            , icon: Icon(Icons.chevron_left,
              size: 30,)),
        title: Text('회원 정보 수정'),
        titleTextStyle: thema.textTheme.headlineLarge,
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: (){

                final nickName = _nicknameController.text.trim();
                viewModel.updateMemberFetch(nickName,profileImagePath ?? '');
                context.push('/home');
              },
              child:
              Text("완료",
                style: context.bodyBold,
              )
          ),
        ],
      ),
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileImage(context),
          gap16,
          Align(
            child:
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),

              ),
              child: GestureDetector(
                onTap: showImagePickerDialog,
                child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.camera_alt_rounded),
                  Text(' 사진 올리기',
                    style: context.bodyBold,),

                ],
              ),
              ),

            ),
          ),

          gap32,

          Text("이메일",
            style: context.bodyBold,),
          gap4,
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              member?.email ?? '',
              style: context.bodyBold,
            ),
          ),
          gap8,
          Text("닉네임",
            style: context.bodyBold,),
          gap8,
          CommonTextField(hintText: member?.nickName?.isNotEmpty == true
              ? member?.nickName
              : '닉네임을 입력하세요.',
          controller: _nicknameController),
          ElevatedButton(onPressed: () {
            final nickname = _nicknameController.text.trim();
            if (nickname.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('닉네임을 입력해주세요.')));
              return;
            }
            viewModel.checkNickname(nickname);
          }, child: Text('중복체크'))


        ],
      ),

    );
  }
  void showImagePickerDialog(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("프로필 사진 선택"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("카메라 촬영"),
                  onTap: (){
                    Navigator.pop(context);
                    pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text("갤러리 사진 선택"),
                  onTap: (){
                    Navigator.pop(context);
                    pickImage(ImageSource.gallery);
                  },
                )
              ],
            ),
          );
        });
  }
  Future<void> pickImage(ImageSource source) async {
    try {
      XFile? image = await picker.pickImage(source: source);
      if(image != null){
        setState((){
          profileImagePath = image.path;
        });
      }
    } catch(e){
      print("$e");
    }
  }

  Widget _buildProfileImage(BuildContext context) {
    final viewModel = context.watch<AlterMemberViewmodel>();
    final savedImagePath = viewModel.alterMember?.member.profileImage;

    final imagePathToUse = profileImagePath?.isNotEmpty == true
        ? profileImagePath
        : (savedImagePath?.isNotEmpty == true ? savedImagePath : null);

    return Align(
      alignment: Alignment.center,
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[400],
        backgroundImage: imagePathToUse != null
              ? (imagePathToUse.startsWith('http')
            ? NetworkImage(imagePathToUse) as ImageProvider
            : FileImage(File(imagePathToUse)))
            : null,
        child: imagePathToUse == null
            ? Icon(Icons.person, size: 60, color: AppColors.white)
            : null,
      ),
    );
  }
}
