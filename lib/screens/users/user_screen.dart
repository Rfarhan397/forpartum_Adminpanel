import 'package:flutter/material.dart';
import 'package:forpartum_adminpanel/model/res/constant/app_assets.dart';
import 'package:forpartum_adminpanel/model/res/routes/routes_name.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
import '../../model/user_model/user_model.dart';
import '../../provider/blog/blog_provider.dart';
import '../../provider/dropDOwn/dropdown.dart';
import '../../provider/stream/streamProvider.dart';
import '../../provider/user_provider/user_provider.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dropdownProvider = Provider.of<DropdownProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final blogPostProvider = Provider.of<BlogPostProvider>(context);

    final users = userProvider.users;
    final activeUsersCount = users.where((user) => user.status == 'isActive').length;
    final totalUsersCount = users.length;
    // Get the current month and year
    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;

    // Filter users who created their accounts in the current month
    final newSignupsCount = users.where((user) {
      final createdAtTimestampString = user.createdAt;
      if (createdAtTimestampString != null) {
        final createdAtTimestamp = int.tryParse(createdAtTimestampString);
        if (createdAtTimestamp != null) {
          final createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtTimestamp);
          return createdAt.month == currentMonth && createdAt.year == currentYear;
        }
      }
      return false;
    }).length;

    final currentUserPage = blogPostProvider.currentUserPage;
    const itemsPerPage = 8;
    final totalItems = users.length;
    final totalPages = (totalItems / itemsPerPage).ceil();

    final startItem = (currentUserPage - 1) * itemsPerPage;
    final endItem = currentUserPage * itemsPerPage > totalItems
        ? totalItems
        : currentUserPage * itemsPerPage;
    final paginatedUsers = users.sublist(startItem, endItem);

    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
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
                    items: <String>['Last 30 Days', 'Last 10 Days', 'Yesterday']
                        .map((String value) {
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
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
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
                    count: totalUsersCount.toString(),
                    percentageIncrease: '12% increase from last month',
                    increaseColor: Colors.green,
                  ),
                  StatsCard(
                    progressIcon: 'assets/icons/arrowdown.svg',
                    iconPath: AppIcons.activeUser,
                    iconBackgroundColor: primaryColor,
                    title: 'Active Users',
                    count: activeUsersCount.toString(),
                    percentageIncrease: '10% decrease from last month',
                    increaseColor: Colors.red,
                  ),
                  StatsCard(
                    progressIcon: 'assets/icons/arrowUp.svg',
                    iconPath: AppIcons.time,
                    iconBackgroundColor: secondaryColor,
                    title: 'New Signups',
                    count: newSignupsCount.toString(),
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
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1.5),
                      },
                      children: [
                        TableRow(children: [
                          Container(
                            width: 10.w,
                            padding: EdgeInsets.only(top: 1.5.h, bottom: 1.5.h),
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
                            padding: EdgeInsets.only(top: 1.5.h, bottom: 1.5.h),
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
                            padding: EdgeInsets.only(top: 1.5.h, bottom: 1.5.h),
                            margin: EdgeInsets.only(
                                left: 1.w, right: 10.w, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(25)),
                            child: const AppTextWidget(
                                text: 'Status', color: Colors.white),
                          ),
                          Container(
                              alignment: Alignment.center,
                              padding:
                                  EdgeInsets.only(top: 1.5.h, bottom: 1.5.h),
                              margin: EdgeInsets.only(
                                  left: 1.w, right: 19.w, top: 5, bottom: 5),
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
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   itemCount: paginatedUsers.length,
                    //   itemBuilder: (ctx, index) {
                    //     final user = paginatedUsers[index];
                    //     return Padding(
                    //       padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
                    //       child: Table(
                    //         columnWidths: const {
                    //           0: FlexColumnWidth(1),
                    //           1: FlexColumnWidth(1),
                    //           2: FlexColumnWidth(1),
                    //           3: FlexColumnWidth(1.5),
                    //         },
                    //         children: [
                    //           TableRow(
                    //             decoration: BoxDecoration(
                    //               color: Colors.white,
                    //               shape: BoxShape.rectangle,
                    //               borderRadius: BorderRadius.circular(8),
                    //               border: Border.all(
                    //                 width: 1,
                    //                 color: Colors.grey.shade200,
                    //               ),
                    //             ),
                    //             children: [
                    //               InkWell(
                    //                 onTap: () {
                    //                   // Provider.of<MenuAppController>(context, listen: false).changeScreen(12);
                    //                   Provider.of<MenuAppController>(context, listen: false).changeScreenWithParams(
                    //                    12,
                    //                   parameters: user,
                    //                   );
                    //                 },
                    //                 child: Row(
                    //                   children: [
                    //                     SizedBox(width: 0.5.w),
                    //                      CircleAvatar(
                    //                        radius: 17.5,
                    //                        backgroundColor: Colors.grey,
                    //                        backgroundImage: user.imageUrl.isNotEmpty ? NetworkImage(user.imageUrl):
                    //                      AssetImage(AppAssets.logoImage),
                    //                      ),
                    //                     SizedBox(width: 1.w),
                    //                     Container(
                    //
                    //                         padding: EdgeInsets.only(
                    //                             top: 1.5.h, bottom: 1.5.h),
                    //                         margin: EdgeInsets.only(
                    //                             top: 5, bottom: 5),
                    //                         child:  AppTextWidget(
                    //                           text: user.name,
                    //                           color: Colors.black,
                    //                         )),
                    //                   ],
                    //                 ),
                    //               ),
                    //               Container(
                    //                 alignment: Alignment.centerLeft,
                    //                   padding: EdgeInsets.only(
                    //                       top: 1.5.h, bottom: 1.5.h),
                    //                   margin: EdgeInsets.only(
                    //                       left:0,top: 5, bottom: 5),
                    //                   child:  AppTextWidget(
                    //                     text: user.email,
                    //                     color: Colors.black,
                    //                   )),
                    //               Container(
                    //                 alignment: Alignment.centerLeft,
                    //                   padding: EdgeInsets.only(
                    //                       top: 1.5.h, bottom: 1.5.h),
                    //                   margin: EdgeInsets.only(
                    //                     right: 8.w,
                    //                       left:3.w,top: 5, bottom: 5),
                    //                   child:  AppTextWidget(
                    //                     text: 'Active',
                    //                     color: Colors.black,
                    //                   )),
                    //               Container(
                    //                 alignment: Alignment.centerLeft,
                    //                 padding: EdgeInsets.only(
                    //                     top: 1.5.h, bottom: 1.5.h),
                    //                 margin: EdgeInsets.only(
                    //                     right:2.w,top: 5, bottom: 5),
                    //                 child: Row(
                    //                   children: [
                    //                     _buildActionButton('VIEW', onTap: () {}),
                    //                     SizedBox(width: 0.5.w),  // Space between buttons
                    //                     _buildActionButton('EDIT', onTap: () {}),
                    //                     SizedBox(width: 0.5.w),  // Space between buttons
                    //
                    //                     _buildActionButton('DELETE', onTap: () {}),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    // ),
                    StreamBuilder<List<User>>(
                        stream: Provider.of<StreamDataProvider>(context).getUsers(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No users found'));
                          }

                          final users = snapshot.data!;
                          final totalItems = users.length;
                          final currentUserPage =
                              blogPostProvider.currentUserPage;
                          final totalPages = (totalItems / itemsPerPage).ceil();

                          final startItem =
                              (currentUserPage - 1) * itemsPerPage;
                          final endItem =
                              currentUserPage * itemsPerPage > totalItems
                                  ? totalItems
                                  : currentUserPage * itemsPerPage;
                          final paginatedUsers =
                              users.sublist(startItem, endItem);

                          return Column(children: [
                            //_buildUserTableHeader(),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: paginatedUsers.length,
                              itemBuilder: (ctx, index) {
                                final user = paginatedUsers[index];
                                return _buildUserRow(context, user);
                              },
                            ),
                          ]);
                        }),
                    SizedBox(height: 3.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTextWidget(
                              text:
                                  'Showing ${startItem + 1} to $endItem of $totalItems items',
                              fontSize: 10),
                          Container(
                            margin:
                                const EdgeInsets.only(right: 40, bottom: 20),
                            alignment: Alignment.centerRight,
                            child: PaginationWidget(
                              currentPage: currentUserPage,
                              totalPages: totalPages,
                              onPageChanged: (page) {
                                blogPostProvider.goToUserPage(page);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildUserTableHeader() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1.5),
      },
      children: [
        TableRow(children: [
          _buildHeaderCell('User Name'),
          _buildHeaderCell('Email'),
          _buildHeaderCell('Status'),
          _buildHeaderCell('Actions'),
        ]),
      ],
    );
  }
  Widget _buildHeaderCell(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 5),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: AppTextWidget(text: text, color: Colors.white),
    );
  }
  Widget _buildUserRow(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1.5),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1,
                color: Colors.grey.shade200,
              ),
            ),
            children: [
              Row(
                children: [
                  SizedBox(width: 0.5.w),
                  CircleAvatar(
                    radius: 17.5,
                    backgroundColor: Colors.grey,
                    backgroundImage: user.imageUrl.toString().isNotEmpty
                        ? NetworkImage(user.imageUrl.toString())
                        : const AssetImage(AppAssets.logoImage),
                  ),
                  SizedBox(width: 1.w),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    child: AppTextWidget(text: user.name.toString(), color: Colors.black),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                child: AppTextWidget(text: user.email.toString(), color: Colors.black),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                child: const AppTextWidget(text: 'Active', color: Colors.black),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                child: Row(
                  children: [
                    _buildActionButton('VIEW', onTap: () {
                      Provider.of<MenuAppController>(context, listen: false)
                          .changeScreenWithParams(12, parameters: user);
                    }),
                    // SizedBox(width: 0.5.w),
                    // _buildActionButton('EDIT', onTap: () {}),
                    SizedBox(width: 0.5.w),
                    _buildActionButton('DELETE', onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildActionButton(String label, {required VoidCallback onTap}) {
    return InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, fontSize: 10, color: Colors.black),
        ),
      ),
    );
  }
}
