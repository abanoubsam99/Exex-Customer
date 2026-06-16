import sys

with open("lib/features/order_details/ui/order_details_screen.dart", "r", encoding="utf-8") as f:
    code = f.read()

# Replace the build method list
target_build_list = """                        _SectionHeader('الخدمات الأساسية'),
                        10.verticalSpace,
                        _BasicServiceCard(item: order.basicService),
                        20.verticalSpace,

                        _SectionHeader('الإضافات'),
                        10.verticalSpace,
                        ...order.additions
                            .map((a) => _AdditionCard(item: a)),
                        20.verticalSpace,

                        _SectionHeader('البوفيه'),
                        10.verticalSpace,
                        ...order.buffet.map((a) => _AdditionCard(item: a)),
                        20.verticalSpace,

                        _SectionHeader('تفاصيل التكلفة'),
                        10.verticalSpace,
                        _CostBreakdownCard(rows: order.costBreakdown),
                        20.verticalSpace,

                        _TotalCard(order: order),"""

replacement_build_list = """                        _SectionHeader('الخدمات الأساسية'),
                        10.verticalSpace,
                        _AdditionsListCard(items: [order.basicService]),
                        20.verticalSpace,

                        if (order.additions.isNotEmpty) ...[
                          _SectionHeader('الإضافات'),
                          10.verticalSpace,
                          _AdditionsListCard(items: order.additions),
                          20.verticalSpace,
                        ],

                        if (order.buffet.isNotEmpty) ...[
                          _SectionHeader('البوفيه'),
                          10.verticalSpace,
                          _AdditionsListCard(items: order.buffet),
                          20.verticalSpace,
                        ],

                        _SectionHeader('تفاصيل التكلفة'),
                        10.verticalSpace,
                        _CostAndTotalCard(order: order),"""

code = code.replace(target_build_list, replacement_build_list)

import re

# Remove old cards and replace with new ones
# The old cards span from `class _BasicServiceCard` to the end of `class _TotalCard` methods.
# We can use regex to replace from `//  Basic service card` up to `//  Notes field`
target_regex = re.compile(r'// ─────────────────────────────────────────────────────────────────────────\n//  Basic service card\n// ─────────────────────────────────────────────────────────────────────────.*?(?=// ─────────────────────────────────────────────────────────────────────────\n//  Notes field\n// ─────────────────────────────────────────────────────────────────────────)', re.DOTALL)

replacement_cards = """// ─────────────────────────────────────────────────────────────────────────
//  Additions list card
// ─────────────────────────────────────────────────────────────────────────
class _AdditionsListCard extends StatelessWidget {
  final List<OrderLineItem> items;
  const _AdditionsListCard({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AdditionItem(item: item),
              if (i != items.length - 1)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final dashWidth = 5.0;
                      final dashCount = (constraints.constrainWidth() / (2 * dashWidth)).floor();
                      return Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(dashCount, (_) {
                          return SizedBox(
                            width: dashWidth,
                            height: 1,
                            child: const DecoratedBox(decoration: BoxDecoration(color: Color(0xFFEDEDED))),
                          );
                        }),
                      );
                    },
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _AdditionItem extends StatelessWidget {
  final OrderLineItem item;
  const _AdditionItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8.r, height: 8.r,
              decoration: BoxDecoration(color: AppColors.orangeColor, shape: BoxShape.circle),
            ),
            8.horizontalSpace,
            Expanded(
              child: Text(item.name,
                  style: TextStyle(
                    color: AppColors.blacksoft,
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                  )),
            ),
            if (item.price == 0) ...[
              CustomImageHandler(AppImages.imagesGift, width: 20.r, height: 20.r),
              8.horizontalSpace,
            ],
            _priceText(item.price),
          ],
        ),
        if (item.count != null) ...[
          4.verticalSpace,
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Text('عدد ${item.count}',
                style: AppTextStyles.font12greyRegular),
          ),
        ],
        if (item.description != null) ...[
          6.verticalSpace,
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Text(item.description!, style: AppTextStyles.font12greyRegular),
          ),
        ],
        if (item.subName != null) ...[
          10.verticalSpace,
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.lightestPrimaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(item.subName!,
                      style: TextStyle(
                        color: AppColors.orangeColor,
                        fontSize: 12.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
              const Spacer(),
              _priceText(item.subPrice ?? 0),
            ],
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
//  Cost and Total card
// ─────────────────────────────────────────────────────────────────────────
class _CostAndTotalCard extends StatelessWidget {
  final OrderDetailsModel order;
  const _CostAndTotalCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFEDEDED)),
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Column(
              children: order.costBreakdown.map((row) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(row.label,
                                textAlign: TextAlign.right,
                                style: AppTextStyles.font14BlacksoftRegular),
                            if (row.subtitle != null) ...[
                              2.verticalSpace,
                              Text('• ${row.subtitle!}',
                                  textAlign: TextAlign.right,
                                  style: AppTextStyles.font12greyRegular),
                            ],
                          ],
                        ),
                      ),
                      Text.rich(
                        textDirection: TextDirection.rtl,
                        TextSpan(children: [
                          TextSpan(
                            text: '${row.value} ',
                            style: TextStyle(
                              color: AppColors.blacksoft,
                              fontSize: 14.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: row.unit,
                            style: TextStyle(
                              color: AppColors.blueGrey,
                              fontSize: 12.r,
                              fontFamily: 'Almarai',
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 20.h,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: 1,
                    margin: EdgeInsets.symmetric(horizontal: 14.w),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final dashWidth = 5.0;
                        final dashCount = (constraints.constrainWidth() / (2 * dashWidth)).floor();
                        return Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(dashCount, (_) {
                            return SizedBox(
                              width: dashWidth,
                              height: 1,
                              child: const DecoratedBox(decoration: BoxDecoration(color: Color(0xFFEDEDED))),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: -1,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 10.r,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      border: const Border(
                        top: BorderSide(color: Color(0xFFEDEDED)),
                        bottom: BorderSide(color: Color(0xFFEDEDED)),
                        right: BorderSide(color: Color(0xFFEDEDED)),
                      ),
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(10.r)),
                    ),
                  ),
                ),
                Positioned(
                  right: -1,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 10.r,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      border: const Border(
                        top: BorderSide(color: Color(0xFFEDEDED)),
                        bottom: BorderSide(color: Color(0xFFEDEDED)),
                        left: BorderSide(color: Color(0xFFEDEDED)),
                      ),
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(10.r)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('إجمالي التكلفة',
                          style: AppTextStyles.font16BlackBold),
                    ),
                    _priceText(order.totalCost, numberSize: 22, unitSize: 14),
                  ],
                ),
                12.verticalSpace,
                _totalRow('المدفوع', order.paid),
                8.verticalSpace,
                _totalRow('المتبقي', order.remaining),
                8.verticalSpace,
                _totalRow('المسترد', order.refunded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String label, num value) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: AppTextStyles.font14BlacksoftRegular),
        ),
        Text.rich(
          textDirection: TextDirection.rtl,
          TextSpan(children: [
            TextSpan(
              text: '$value ',
              style: TextStyle(
                color: AppColors.blacksoft,
                fontSize: 14.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: 'جنيه',
              style: TextStyle(
                color: AppColors.blueGrey,
                fontSize: 12.r,
                fontFamily: 'Almarai',
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

"""

code = target_regex.sub(replacement_cards, code)

with open("lib/features/order_details/ui/order_details_screen.dart", "w", encoding="utf-8") as f:
    f.write(code)
