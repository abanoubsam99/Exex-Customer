// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ExpansionItem extends StatefulWidget {
//   final String title;
//   final Widget? count;
//   final List<Widget> children;
//   final double? fontSize;
//   const ExpansionItem({
//     super.key,
//     required this.title,
//     required this.children,
//     this.count,
//     this.fontSize,
//   });

//   @override
//   State<ExpansionItem> createState() => _ExpansionItemState();
// }

// class _ExpansionItemState extends State<ExpansionItem>
//     with AutomaticKeepAliveClientMixin {
//   final GlobalKey expansionTileKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Container(
//       // clipBehavior: Clip.antiAlias,
//       margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//       decoration: ShapeDecoration(
//         // color: Colors.red,
//         shape: RoundedRectangleBorder(
//           side: const BorderSide(width: 2, color: AppColors.grey3),
//           borderRadius: BorderRadius.circular(16.r),
//         ),
//       ),
//       child: ListTileTheme(
//         child: Theme(
//           data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//           child: ExpansionTile(
            
//             iconColor: Colors.grey.shade800,
//             collapsedIconColor: Colors.grey.shade800,

//             shape: const Border(),
//             // tilePadding: EdgeInsets.symmetric(horizontal: 24.w),
//             minTileHeight: 40.h,
//             // childrenPadding: EdgeInsets.symmetric(
//             //   horizontal: 24.w,
//             //   vertical: 16.h,
//             // ),
//             g,
//             expandedCrossAxisAlignment: CrossAxisAlignment.end,
//             title: const Text('Level One'),
//             // backgroundColor: Colors.amber,
//             children: [
//               Container(
//                 width: double.infinity,
//                 decoration: ShapeDecoration(
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     side: const BorderSide(width: 1, color: AppColors.grey3),
//                     borderRadius: BorderRadius.circular(16.r),
//                   ),
//                 ),
//                 child: Column(children: widget.children),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;
// }
