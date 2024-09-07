import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../constant.dart';
import '../../controller/menu_App_Controller.dart';
import '../../model/res/components/custom_appBar.dart';
import '../../model/res/components/pagination.dart';
import '../../model/res/components/stats_card.dart';
import '../../model/res/constant/app_icons.dart';
import '../../model/res/widgets/app_text.dart.dart';
import '../../provider/blog/blog_provider.dart';
import '../../provider/dropDOwn/dropdown.dart';
import '../../provider/user_provider/user_provider.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dropdownProvider = Provider.of<DropdownProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final blogPostProvider = Provider.of<BlogPostProvider>(context);

    final users = userProvider.users;
    final currentPage = blogPostProvider.currentPage;
    final itemsPerPage = 8;
    final totalItems = 40;
    final totalPages = blogPostProvider.totalPages;

    final startItem = (currentPage - 1) * itemsPerPage + 1;
    final endItem = currentPage * itemsPerPage > totalItems ? totalItems : currentPage * itemsPerPage;

    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
        appBar: const CustomAppbar(text: 'Users'),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey.shade300,
                        endIndent: 20,
                      ),
                    ),
                    DropdownButton<String>(
                      value: dropdownProvider.selectedValue,
                      items: <String>[
                        'Last 30 Days',
                        'Last 10 Days',
                        'Yesterday'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: AppTextWidget(text: value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          dropdownProvider.setSelectedValue(newValue);
                        }
                      },
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.black),
                    ),
                  ],
                ),
                 Row(
                  children: [
                    StatsCard(
                      iconPath: AppIcons.totalUsers,
                      progressIcon: 'assets/icons/arrowUp.svg',
                      iconBackgroundColor: secondaryColor,
                      title: 'Total Users',
                      count: '10,000',
                      percentageIncrease: '12% increase from last month',
                      increaseColor: Colors.green,
                    ),
                    StatsCard(
                      progressIcon: 'assets/icons/arrowdown.svg',
                      iconPath: AppIcons.activeUser,
                      iconBackgroundColor: primaryColor,
                      title: 'Active Users',
                      count: '95,000',
                      percentageIncrease: '10% decrease from last month',
                      increaseColor: Colors.red,
                    ),
                    StatsCard(
                      progressIcon: 'assets/icons/arrowUp.svg',
                      iconPath: AppIcons.time,
                      iconBackgroundColor: secondaryColor,
                      title: 'New Signups',
                      count: '2,000',
                      percentageIncrease: '8% increase from last month',
                      increaseColor: Colors.green,
                    ),
                    StatsCard(
                      progressIcon: 'assets/icons/arrowUp.svg',
                      iconPath: AppIcons.feedback,
                      iconBackgroundColor: primaryColor,
                      title: 'Feedback',
                      count: '600',
                      percentageIncrease: '2% increase from last month',
                      increaseColor: Colors.green,
                    ),
                  ],
                ),
                SizedBox(height: 2.h,),
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      // boxShadow: [
                      //   const BoxShadow(
                      //     color: Colors.black12,
                      //     blurRadius: 8,
                      //     spreadRadius: 2,
                      //     offset: Offset(2, 2),
                      //   ),
                      //],
                    ),
                    child: Column(
                      children: [
                        Table(
                          columnWidths: {
                            0: const FlexColumnWidth(1),
                            1: const FlexColumnWidth(1),
                            2: const FlexColumnWidth(1),
                            3: const FlexColumnWidth(1.5),
                          },
                          children: [
                            TableRow(children: [
                              Container(
                                width: 10.w,
                                padding: EdgeInsets.only(
                                   top: 1.5.h, bottom: 1.5.h),
                                margin: EdgeInsets.only(
                                    left: 2.w, right: 8.w, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(25)),
                                child: const AppTextWidget(
                                    text: 'User Name', color: Colors.white),
                              ),
                              Container(
                                width: 10.w,

                                padding: EdgeInsets.only(
                                     top: 1.5.h, bottom: 1.5.h),
                                margin: EdgeInsets.only(
                                    left: 1.w, right: 10.w, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(25)),
                                child: const AppTextWidget(
                                    text: 'Email', color: Colors.white),
                              ),
                              Container(
                                width: 10.w,

                                padding: EdgeInsets.only(
                                     top: 1.5.h, bottom: 1.5.h),
                                margin: EdgeInsets.only(
                                    left: 1.w, right: 10.w, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(25)),
                                child: const AppTextWidget(
                                    text: 'Status', color: Colors.white),
                              ),
                              Container(
                                  width: 10.w,
                                  padding: EdgeInsets.only(
                                       top: 1.5.h, bottom: 1.5.h),
                                  margin: EdgeInsets.only(
                                       right: 20.w, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(25)),
                                  child: const AppTextWidget(
                                    text: 'Actions',
                                    color: Colors.white,
                                  )),
                            ]),
                          ],
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: itemsPerPage,
                            itemBuilder: (ctx, index){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 15),
                            child: Table(
                              columnWidths: {
                                0: const FlexColumnWidth(1),
                                1: const FlexColumnWidth(1),
                                2: const FlexColumnWidth(1),
                                3: const FlexColumnWidth(1.5),
                              },
                              children: [
                                TableRow(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.grey.shade200
                                        )
                                    ),
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 1.5.h, bottom: 1.5.h),
                                       // margin: EdgeInsets.only(
                                       //     left: 3.w, right: 2.w, top: 5, bottom: 5),
                                        child: GestureDetector(
                                          onTap: () {
                                            Provider.of<MenuAppController>(context, listen: false)
                                                .changeScreen(12);
                                            // Get.offNamed(RoutesName.userDetails);
                                          },
                                          child: Row(
                                            children: [
                                              SizedBox(width: 0.5.w,),
                                              const CircleAvatar(
                                                radius: 17.5,
                                                backgroundColor: Colors.grey,
                                              ),
                                              SizedBox(width: 1.w,),
                                              const AppTextWidget(text: 'Emily',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(
                                            top: 2.2.h, bottom: 2.3.h),
                                        margin: EdgeInsets.only(
                                            right: 2.w, top: 5, bottom: 5),
                                        child: const AppTextWidget(text: 'emily@gmail.com',
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 2.5.h, bottom: 2.3.h),
                                        margin: EdgeInsets.only(right: 8.w, top: 5, bottom: 5),
                                        child: const AppTextWidget(text: 'Active',
                                            fontWeight: FontWeight.w600,
                                            color: primaryColor,
                                            fontSize: 12
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 1.5.h, bottom: 1.5.h),
                                        margin: EdgeInsets.only(right: 2, top: 5, bottom: 5),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                // Handle View Action
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 0.5.h),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    border: Border.all(
                                                      color: Colors.grey.shade300,
                                                      width: 1,
                                                    )
                                                ),
                                                child: Text('VIEW',style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10,
                                                    color: Colors.black
                                                ),),
                                              ),
                                            ),
                                            SizedBox(width: 1.w),
                                            GestureDetector(
                                              onTap: () {
                                                // Handle Edit Action
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 0.5.h),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    border: Border.all(
                                                      color: Colors.grey.shade300,
                                                      width: 1,
                                                    )
                                                ),
                                                child: Text('EDIT',style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10,
                                                    color: Colors.black
                                                ),),
                                              ),
                                            ),
                                            SizedBox(width: 1.w),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 0.5.h),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    border: Border.all(
                                                      color: Colors.grey.shade300,
                                                      width: 1,
                                                    )
                                                ),
                                                child: Text('DELETE',style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10,
                                                    color: Colors.black
                                                ),),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                              ],
                            ),
                          );
                        }),
                        SizedBox(height: 3.h,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            AppTextWidget(  text: 'Showing $startItem to $endItem of $totalItems items',fontSize: 10,),
                              Container(
                                margin: EdgeInsets.only(right: 40, bottom: 20),
                                alignment: Alignment.centerRight,
                                child: PaginationWidget(
                                  currentPage: blogPostProvider.currentPage,
                                  totalPages: blogPostProvider.totalPages,
                                  onPageChanged: (page) {
                                    blogPostProvider.goToPage(page);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),                      ],
                    ),
                    )
              ],
            ),
          ),
        ));
  }
}
