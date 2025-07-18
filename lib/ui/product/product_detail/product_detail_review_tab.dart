import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/view_model/product/review_viewmodel.dart';
import 'package:look_talk/model/entity/review_entity.dart';

class ProductDetailReviewTab extends StatefulWidget {
  final String productId;

  const ProductDetailReviewTab({super.key, required this.productId});

  @override
  State<ProductDetailReviewTab> createState() => _ProductDetailReviewTabState();
}

class _ProductDetailReviewTabState extends State<ProductDetailReviewTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReviewViewModel>().fetchReviewsAndAverage(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummary(vm),
              const Divider(),
              ...vm.reviews.map((review) {
                return Column(
                  children: [
                    _buildReviewItem(context, review, vm),
                    const Divider(),
                  ],
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummary(ReviewViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text('⭐️ ${vm.averageRating.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text('리뷰 ${vm.reviews.length}개'),
        ],
      ),
    );
  }

  Widget _buildReviewItem(BuildContext context, ReviewEntity review, ReviewViewModel vm) {
    final formattedDate = DateFormat('yyyy.MM.dd').format(review.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage:
                review.profileImageUrl != null ? NetworkImage(review.profileImageUrl!) : null,
                child: review.profileImageUrl == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 8),
              Text(review.nickname),
              const Spacer(),
              Text(formattedDate, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (i) {
              return Icon(
                i < review.rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 18,
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(review.content),
          const SizedBox(height: 8),
          if (review.imageUrls.isNotEmpty)
            Wrap(
              spacing: 8,
              children: review.imageUrls.map((url) {
                return Image.network(url, width: 80, height: 80, fit: BoxFit.cover);
              }).toList(),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
