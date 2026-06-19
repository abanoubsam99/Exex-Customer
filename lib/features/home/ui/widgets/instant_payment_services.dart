import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/cubits/home/home_state.dart';
import 'package:evex_user/features/home/ui/widgets/service_category_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstantPaymentServices extends StatelessWidget {
  const InstantPaymentServices({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return ServiceCategorySection(
          title: 'الخدمات المباشرة',
          isLoading: state.isLoadingPorts,
          categories: state.paymentPorts,
          selectedCategory: state.selectedPaymentPort,
          selectedType: state.selectedPaymentPortType,
          onSelectCategory: cubit.selectPaymentPort,
          onSelectType: cubit.selectPaymentPortType,
          onOpenPorts: () => NavigationHelper.pushNamed(
            Routes.directServicesListScreen,
          ),
        );
      },
    );
  }
}
