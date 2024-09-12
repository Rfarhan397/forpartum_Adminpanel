import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constant.dart';
import '../../../model/res/components/custom_appBar.dart';
import '../../../model/res/components/custom_dropDown.dart';
import '../../../model/res/components/custom_switch_widget.dart';
import '../../../model/res/widgets/app_text.dart.dart';
import '../../../model/res/widgets/custom_richtext.dart';
import '../../../provider/dropDOwn/dropdown.dart';

class MenuSettingsDetailScreen extends StatelessWidget {
  MenuSettingsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dropdownProvider = Provider.of<DropdownProviderN>(context,listen: false);
    return Scaffold(
      backgroundColor: Color(0xffFFFAF9),
      appBar: CustomAppbar(text: 'Settings'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
              thickness: 1.0,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppTextWidget(
                          text: 'Global Settings',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        CustomRichText(
                          firstText: 'App Name:',
                          secondText: 'Forpartum',
                          press: () {},
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          children: [
                            AppTextWidget(
                              text: 'Default language:',
                            ),
                            SizedBox(
                              width: 0.5.w,
                            ),
                            // buildDropDown(context, 2),
                            //CategoryPopupMenu(),
                            // CustomDropdownWidget(
                            //   index: 1,
                            //   items: ['English', 'French'],
                            //   dropdownType: 'Language',
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppTextWidget(
                              text: 'Time Zone:',
                            ),
                            SizedBox(
                              width: 0.5.w,
                            ),
                            // CustomDropdownWidget(
                            //   index: 2,
                            //   items: ['Uk', 'France'],
                            //  dropdownType: 'TimeZone',
                            // ),                             //buildDropDownT(context, 3),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        AppTextWidget(
                          text: 'Privacy Settings',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        AppTextWidget(
                          text:
                              'Date Retention Period: [ Input Field] (in days)',
                          textAlign: TextAlign.start,
                          fontSize: 10,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        buildToggleContainer('User Data Export'),
                        SizedBox(
                          height: 2.h,
                        ),
                        buildToggleContainer('User Data Deletion'),
                        SizedBox(
                          height: 5.h,
                        ),
                        AppTextWidget(
                          text: 'Admin Account Management',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(25)),
                                  child: const AppTextWidget(
                                      text: 'Admin Name',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      AppTextWidget(
                                        text: 'Jane Smith',
                                        fontSize: 12,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      AppTextWidget(
                                        text: 'Jane Smith',
                                        fontSize: 12,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      AppTextWidget(
                                        text: 'Jane Smith',
                                        fontSize: 12,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      AppTextWidget(
                                        text: 'Jane Smith',
                                        fontSize: 12,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      AppTextWidget(
                                        text: 'Jane Smith',
                                        fontSize: 12,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(25)),
                                  child: const AppTextWidget(
                                      text: 'Email',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      AppTextWidget(
                                        text: 'john@example.com',
                                        fontSize: 12,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      AppTextWidget(
                                        text: 'john@example.com',
                                        fontSize: 12,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      AppTextWidget(
                                        text: 'john@example.com',
                                        fontSize: 12,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      AppTextWidget(
                                        text: 'john@example.com',
                                        fontSize: 12,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      AppTextWidget(
                                        text: 'john@example.com',
                                        fontSize: 12,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(25)),
                                  child: const AppTextWidget(
                                      text: 'Actions',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildRow(),
                                    buildRow(),
                                    buildRow(),
                                    buildRow(),
                                    buildRow(),
                                  ],
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextWidget(
                          text: 'Feature Toggles ',
                          fontSize: 24,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        buildToggleContainer('Mood Tracker'),
                        SizedBox(
                          height: 2.h,
                        ),
                        buildToggleContainer('Stress Energy Tracker'),
                        SizedBox(
                          height: 2.h,
                        ),
                        buildToggleContainer('Pain Symptom Tracker'),
                        SizedBox(
                          height: 2.h,
                        ),
                        buildToggleContainer('Sleep Tracker'),
                        SizedBox(
                          height: 2.h,
                        ),
                        buildToggleContainer('Meal Plans'),
                        SizedBox(
                          height: 2.h,
                        ),
                        buildToggleContainer('Milestone Tracker '),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildToggleContainer(text) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal:10.w),
      width: 18.w,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.1), // Adjust opacity for softer shadow
              offset: Offset(0, 5), // Shadow is offset to the bottom
              blurRadius: 8,
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppTextWidget(
            text: text,
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          CustomSwitchWidgetF(),
        ],
      ),
    );
  }

  Padding buildRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.5),
      child: Row(
        children: [
          //SizedBox(height:10,),
          AppTextWidget(
            text: '[Edit]',
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          SizedBox(
            width: 20,
          ),
          AppTextWidget(
            text: '[Delete]',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}

// Consumer<DropdownProviderN> buildDropDown(BuildContext context, int index) {
//   final List<String> language = [
//     'English',
//     'French',
//   ];
//   return Consumer<DropdownProviderN>(
//     builder: (context, dropdownProvider, child) {
//       return Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Align(
//             alignment: Alignment.centerRight,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   height: 4.h,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: primaryColor,
//                         width: 1.0,
//                       ),
//                       color: Colors.white),
//                   child: GestureDetector(
//                     onTap: () {
//                       dropdownProvider
//                           .closeOtherDropdowns(index); // Close other dropdowns
//                       dropdownProvider.toggleDropdownVisibility(index);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           AppTextWidget(
//                             text: dropdownProvider.selectedLanguage,
//                             color: primaryColor,
//                           ),
//                           Icon(
//                             dropdownProvider.isDropdownVisible(index)
//                                 ? Icons.keyboard_arrow_up_outlined
//                                 : Icons.keyboard_arrow_down_rounded,
//                             color: primaryColor,
//                             size: 20,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (dropdownProvider.isDropdownVisible(index))
//             Positioned(
//               top: 4.2.h,
//               child: Container(
//                 height: 100,
//                 width: 100,
//                 color: Colors.red,
//                 child: PopupMenuButton<int>(
//                   itemBuilder: (context) => [
//                     // PopupMenuItem 1
//                     PopupMenuItem(
//                       value: 1,
//                       // row with 2 children
//                       child: Row(
//                         children: [
//                           Icon(Icons.star),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Text("Get The App")
//                         ],
//                       ),
//                     ),
//                     // PopupMenuItem 2
//                     PopupMenuItem(
//                       value: 2,
//                       // row with two children
//                       child: Row(
//                         children: [
//                           Icon(Icons.chrome_reader_mode),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Text("About")
//                         ],
//                       ),
//                     ),
//                   ],
//                   offset: Offset(0, 100),
//                   color: Colors.grey,
//                   elevation: 2,
//                   // on selected we show the dialog box
//                   onSelected: (value) {
//                     // if value 1 show dialog
//                     if (value == 1) {
//                       _showDialog(context);
//                       // if value 2 show dialog
//                     } else if (value == 2) {
//                       _showDialog(context);
//                     }
//                   },
//                 ),
//               ),
//               // Container(
//               //   width: 11.5.h,
//               //   decoration: BoxDecoration(
//               //     borderRadius: BorderRadius.circular(10),
//               //     border: Border.all(
//               //       color: primaryColor,
//               //       width: 1.0,
//               //     ),
//               //     color: Colors.white,
//               //   ),
//               //   child: Column(
//               //     crossAxisAlignment: CrossAxisAlignment.start,
//               //     children: language.map((language) {
//               //       return GestureDetector(
//               //         onTap: () {
//               //           dropdownProvider.setSelectedLanguage(language);
//               //           dropdownProvider.toggleDropdownVisibility(index);
//               //         },
//               //         child: Container(
//               //           padding: EdgeInsets.symmetric(
//               //               vertical: 8.0, horizontal: 5.0),
//               //           child: AppTextWidget(
//               //             text: language,
//               //             fontSize: 10,
//               //             textAlign: TextAlign.start,
//               //             softWrap: false,
//               //             color: Colors.black,
//               //           ),
//               //         ),
//               //       );
//               //     }).toList(),
//               //   ),
//               // ),
//             ),
//         ],
//       );
//     },
//   );
// }


// Consumer<DropdownProviderN> buildDropDownT(BuildContext context, int index) {
//   final List<String> TimeZone = [
//     'Mountain Time',
//     'Forest Time',
//   ];
//   return Consumer<DropdownProviderN>(
//     builder: (context, dropdownProvider, child) {
//       return Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Align(
//             alignment: Alignment.centerRight,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 9.w,
//                   height: 4.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(
//                       color: primaryColor,
//                       width: 1.0,
//                     ),
//                   ),
//                   child: GestureDetector(
//                     onTap: () {
//                       dropdownProvider
//                           .closeOtherDropdowns(index); // Close other dropdowns
//                       dropdownProvider.toggleDropdownVisibility(index);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           AppTextWidget(
//                             text: dropdownProvider.selectedTimeZone,
//                             color: primaryColor,
//                           ),
//                           Icon(
//                             dropdownProvider.isDropdownVisible(index)
//                                 ? Icons.keyboard_arrow_up_outlined
//                                 : Icons.keyboard_arrow_down_rounded,
//                             color: primaryColor,
//                             size: 20,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (dropdownProvider.isDropdownVisible(index))
//             Positioned(
//               top: 4.2.h,
//               child: Container(
//                 width: 9.w,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: primaryColor,
//                       width: 1.0,
//                     ),
//                     color: Colors.blue),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: TimeZone.map((timeZone) {
//                     return GestureDetector(
//                       onTap: () {
//                         dropdownProvider.setSelectedTimeZone(timeZone);
//                         dropdownProvider.toggleDropdownVisibility(index);
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                             vertical: 8.0, horizontal: 5.0),
//                         child: AppTextWidget(
//                           text: timeZone,
//                           fontSize: 10,
//                           textAlign: TextAlign.start,
//                           softWrap: false,
//                           color: Colors.black,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//         ],
//       );
//     },
//   );
// }
// Consumer<DropdownProviderN> buildDropDownT(BuildContext context, int index) {
//
//   OverlayEntry? _overlayEntry;
//
//   return Consumer<DropdownProviderN>(
//     builder: (context, dropdownProvider, child) {
//       void showDropdown() {
//         _overlayEntry = _createOverlayEntry(context, index, dropdownProvider);
//         Overlay.of(context)?.insert(_overlayEntry!);
//       }
//
//       void hideDropdown() {
//         _overlayEntry?.remove();
//       }
//
//       return GestureDetector(
//         onTap: () {
//           dropdownProvider.closeOtherDropdowns(index); // Close other dropdowns
//           if (dropdownProvider.isDropdownVisible(index)) {
//             hideDropdown();
//             dropdownProvider.toggleDropdownVisibility(index);
//           } else {
//             showDropdown();
//             dropdownProvider.toggleDropdownVisibility(index);
//           }
//         },
//         child: Container(
//           height: 4.h,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: primaryColor,
//               width: 1.0,
//             ),
//             color: Colors.white,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 AppTextWidget(
//                   text: dropdownProvider.selectedLanguage,
//                   color: primaryColor,
//                 ),
//                 Icon(
//                   dropdownProvider.isDropdownVisible(index)
//                       ? Icons.keyboard_arrow_up_outlined
//                       : Icons.keyboard_arrow_down_rounded,
//                   color: primaryColor,
//                   size: 20,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
//
// OverlayEntry _createOverlayEntry(BuildContext context, int index,
//     DropdownProviderN dropdownProvider) {
//   final RenderBox renderBox = context.findRenderObject() as RenderBox;
//   final Size size = renderBox.size;
//   final Offset offset = renderBox.localToGlobal(Offset.zero);
//
//   return OverlayEntry(
//     builder: (context) {
//       final List<String> language = [
//         'English',
//         'French',
//       ];
//       return Positioned(
//         left: offset.dx,
//         top: offset.dy + size.height,
//         width: size.width,
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//
//             width: 100,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(
//                 color: primaryColor,
//                 width: 1.0,
//               ),
//               color: Colors.white,
//             ),
//             child: ListView(
//               padding: EdgeInsets.zero,
//               shrinkWrap: true,
//               children: language.map((language) {
//                 return GestureDetector(
//                   onTap: () {
//                     dropdownProvider.setSelectedLanguage(language);
//                     dropdownProvider.toggleDropdownVisibility(index);
//                     Overlay.of(context)?.dispose();
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
//                     child: AppTextWidget(
//                       text: language,
//                       fontSize: 10,
//                       textAlign: TextAlign.start,
//                       softWrap: false,
//                       color: Colors.black,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
