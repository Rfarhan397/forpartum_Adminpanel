import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../model/res/routes/routes_name.dart';
import '../../model/user_model/user_model.dart';
import '../../provider/user_provider/user_provider.dart';

class UserDataSource extends DataTableSource {
  final List<User> users;
  final BuildContext context;

  UserDataSource({required this.users, required this.context});

  @override
  DataRow getRow(int index) {
    final user = users[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
            GestureDetector(
              onTap: (){
                Get.toNamed(RoutesName.userDetails);
              },
              child: Row(
                        children: [
              const CircleAvatar(
                radius: 20.5,
                backgroundColor: Colors.grey,
              ),
               SizedBox(width: 2.w),
              Text(user.name.toString(),style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 12
              ),)
                        ],
                      ),
            )),
        DataCell(Text(user.email.toString(),style: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          fontSize: 12,
    ),)),
        DataCell(Text(user.status.toString().isNotEmpty? 'Active' : 'Inactive', style: TextStyle(color: user.status.toString().isNotEmpty ? Colors.red : Colors.red))),
        DataCell(
            Row(
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
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  color: Colors.black
                ),),
              ),
            ),
            const SizedBox(width: 8),
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
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.black
                ),),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
              //  Provider.of<UserProvider>(context, listen: false).deleteUser(user);
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
                child: Text('DELETE',style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.black
                ),),
              ),
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}
