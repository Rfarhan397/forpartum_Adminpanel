import 'package:flutter/material.dart';

import '../../../constant.dart';
import '../../../model/res/components/stats_card.dart';
import '../../../model/res/constant/app_icons.dart';

class MobileStat extends StatelessWidget {
  const MobileStat({super.key});

  @override
  Widget build(BuildContext context) {
    return   Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatsCard(
                iconPath: AppIcons.totalUsers,
                //  progressIcon: 'assets/icons/arrowUp.svg',
                iconBackgroundColor: secondaryColor,
                title: 'Total Users',
                count: '10,000',
                // percentageIncrease: '12% increase from last month',
                increaseColor: Colors.green,
              ),
            ),
            Expanded(
              child: StatsCard(
                //  progressIcon: 'assets/icons/arrowUp.svg',
                iconPath: AppIcons.activeUser,
                iconBackgroundColor: primaryColor,
                title: 'Active Users',
                count: '95,000',
                // percentageIncrease: '10% decrease from last month',
                increaseColor: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0,),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                // progressIcon: 'assets/icons/arrowUp.svg',
                iconPath: AppIcons.time,
                iconBackgroundColor: secondaryColor,
                title: 'New Signups',
                count: '2,000',
                // percentageIncrease: '8% increase from last month',
                increaseColor: Colors.green,
              ),
            ),
            Expanded(
              child: StatsCard(
                // progressIcon: 'assets/icons/arrowUp.svg',
                iconPath: AppIcons.feedback,
                iconBackgroundColor: primaryColor,
                title: 'Feedback',
                count: '600',
                // percentageIncrease: '2% increase from last month',
                increaseColor: Colors.green,
              ),
            ),

          ],
        ),
      ],
    );
  }
}
