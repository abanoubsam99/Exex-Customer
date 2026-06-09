import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/cubits/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingServicesType extends StatelessWidget {
  const BookingServicesType({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.selectedBookingPort == null) return const SizedBox.shrink();
        final types = state.selectedBookingPort!.portTypeDtos;
        return SizedBox(
          height: 30.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: types.length,
            itemBuilder: (context, index) {
              final type = types[index];
              final isSelected = state.selectedBookingPortType?.id == type.id;
              return Center(
                child: GestureDetector(
                  onTap: () {
                    context.read<HomeCubit>().selectBookingPortType(type);
                    NavigationHelper.pushNamed(
                      Routes.instantBookingServicesScreen,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.h,
                      horizontal: 18.w,
                    ),
                    decoration: ShapeDecoration(
                      color: isSelected ? AppColors.blacksoft : Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1.5,
                          color: Color(0xFF2C262C),
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      type.nameAr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : AppColors.blacksoft,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => 10.horizontalSpace,
          ),
        );
      },
    );
  }
}
