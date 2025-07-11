import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:look_talk/model/entity/response/wishlist_response.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';
import 'package:look_talk/view_model/wishlist/wishlist_view_model.dart';
import 'package:provider/provider.dart';

class WishlistItemWidget extends StatelessWidget {
  final WishlistItem item;
  final numberFormat = NumberFormat('###,###,###,###');

  WishlistItemWidget({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final discountInfo = item.discount;
    int? discountedPrice;

    if (discountInfo != null) {
      discountedPrice = (item.price * (1 - discountInfo.value / 100)).toInt();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // [✅ 수정] Stack으로 감싸서 삭제 버튼을 올릴 공간 마련
        Stack(
          children: [
            // 상품 이미지
            AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.boxGrey,
                  borderRadius: BorderRadius.circular(8),
                  image: item.thumbnailImage != null
                      ? DecorationImage(
                    image: NetworkImage(item.thumbnailImage!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: item.thumbnailImage == null
                    ? const Icon(Icons.image_not_supported_outlined, color: AppColors.iconGrey, size: 40)
                    : null,
              ),
            ),
            // [✅ 추가] 삭제 아이콘 버튼
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                onPressed: () {
                  context.read<WishlistViewModel>().removeItem(item.id);
                },
                icon: const Icon(Icons.favorite, color: AppColors.primary, size: 28),
                // 배경을 약간 주어 터치 영역 확보 및 시각적 개선
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.white.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
        gap8,
        // 상품 정보 (기존과 동일)
        Text(item.brandName ?? '브랜드 없음', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.caption)),
        gap4,
        Text(item.name, style: const TextStyle(fontSize: TextSizes.caption), maxLines: 2, overflow: TextOverflow.ellipsis),
        gap4,
        // 가격 정보 (기존과 동일)
        if (discountInfo != null)
          Text(
            '${numberFormat.format(item.price)}원',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textGrey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        Row(
          children: [
            if (discountInfo != null)
              Text(
                '${discountInfo.value}%',
                style: const TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: TextSizes.body,
                ),
              ),
            gapW8,
            Text(
              '${numberFormat.format(discountedPrice ?? item.price)}원',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: TextSizes.body,
              ),
            ),
          ],
        )
      ],
    );
  }
}