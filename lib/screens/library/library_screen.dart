import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../model/res/components/cuatom_card.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/pagination.dart';
import '../../provider/libraryCard/card_provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(text: 'Dashboard'),
      body: Column(
        children: [
          Divider(
            height: 10,
            color: Colors.grey[300],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 8.h),
              child: Consumer<CardProvider>(
                builder: (context, provider, _) {
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: provider.currentCards.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 50,
                      childAspectRatio: 2.5/1,
                    ),
                    itemBuilder: (context, index) {
                      return CustomCard(title: provider.currentCards[index]);
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(right: 2.w),
            child: Align(
              alignment: Alignment.centerRight,
              child: PaginationWidget(
                currentPage: context.watch<CardProvider>().currentPage,
                totalPages: context.watch<CardProvider>().totalPages,
                onPageChanged: context.read<CardProvider>().goToPage,
              ),
            ),
          ),
          SizedBox(height: 2.h,)
        ],
      ),
    );
  }
}

