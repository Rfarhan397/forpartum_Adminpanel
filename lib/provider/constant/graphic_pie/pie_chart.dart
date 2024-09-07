import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';

import '../../../constant.dart';
import '../../../model/res/components/responsive.dart';
import '../../../model/res/widgets/app_text.dart.dart';

class GeographicalDistribution extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Container(
      width: 20.w,
      padding: EdgeInsets.all(16),
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
          AppTextWidgetNunito(
            text:
            'Geographical Distribution',
            textAlign: TextAlign.start,
            fontSize: 14, fontWeight: FontWeight.w700),
          SizedBox(height: 1.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                height: 15.h,
                child: PieChart(
                  PieChartData(
                    sections: _buildPieChartSections(),
                    centerSpaceRadius: 50,
                    sectionsSpace: 0,

                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLegend(context,'North America', primaryColor),
              _buildLegend(context,'Europe', secondaryColor),
              _buildLegend(context,'Asia', Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {

    return [
      PieChartSectionData(
        color: primaryColor,
        value: 30,
        title: '35%',
        radius: 8,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.transparent),
      ),
      PieChartSectionData(
        color: secondaryColor,
        value: 35,
        title: '35%',
        radius: 8,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.transparent),
      ),
      PieChartSectionData(
        color: Colors.grey,
        value: 30,
        title: '30%',
        radius: 8,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.transparent),
      ),
      PieChartSectionData(
        color: Colors.grey.shade300,
        value: 30,
        title: '30%',
        radius: 8,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.transparent),
      ),
      PieChartSectionData(
        color: Colors.grey.shade100,
        value: 10,
        title: '30%',
        radius: 8,
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.transparent),
      ),
    ];
  }

  Widget _buildLegend(BuildContext context,String region, Color color) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 0.5.w),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: color,
            ),
          ),
          SizedBox(width: 0.1.w),
          AppTextWidgetNunito(text: region, fontSize: isMobile? 8 : isTablet? 10: 14),
          SizedBox(width: 0.8.w),


        ],
      ),
    );
  }
}
