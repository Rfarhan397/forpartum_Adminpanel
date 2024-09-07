import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constant.dart';
import '../../../model/res/components/responsive.dart';
import '../../../model/res/widgets/app_text.dart.dart';

class AgeDistribution extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: 20.w,
      padding: EdgeInsets.all(3.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidgetNunito(text:
            'Age Distribution',
            fontSize: isMobile ? 12:18, fontWeight: FontWeight.w700),
          SizedBox(height: 2.h),
          _buildAgeRow('16-18', 0.05, primaryColor),
          _buildAgeRow('20-30', 0.35, secondaryColor),
          _buildAgeRow('30-40', 0.35, primaryColor),
          _buildAgeRow('40+', 0.25, Colors.grey),
        ],
      ),
    );
  }

  Widget _buildAgeRow(String ageGroup, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextWidget(text: ageGroup, fontSize: 12),
              SizedBox(width: 1.w),
              AppTextWidgetNunito(text: '${(percentage * 100).toInt()}%', fontSize: 12  ),
            ],
          ),
          SizedBox(height: 1.h),
          Stack(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2)
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2)
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
