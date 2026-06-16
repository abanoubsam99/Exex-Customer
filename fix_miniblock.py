import sys

with open("lib/features/order_details/ui/order_details_screen.dart", "r", encoding="utf-8") as f:
    code = f.read()

# Fix _miniBlock
code = code.replace("""  Widget _miniBlock({
    String? icon,
    required String line1,
    required String line2,
    String? tag,
    Color? line1Color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImageHandler(icon,
            width: 18.r, height: 18.r),
        8.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(line1,
                  style: TextStyle(
                    color: AppColors.blacksoft,
                    fontSize: 13.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                  )),
              2.verticalSpace,
              Text(line2, style: AppTextStyles.font12greyRegular),
            ],
          ),
        ),
      ],
    );
  }""", """  Widget _miniBlock({  
     String? icon,
    required String line1,
    required String line2,
    String? tag,
    Color? line1Color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(icon!=null) ...[
          CustomImageHandler(icon, width: 20.r, height: 20.r),
          8.horizontalSpace,
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(line1,
                      style: TextStyle(
                        color: line1Color ?? AppColors.blacksoft,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                      )),
                  if (tag != null) ...[
                    8.horizontalSpace,
                    Text(tag,
                        style: TextStyle(
                          color: AppColors.orangeColor,
                          fontSize: 10.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ],
              ),
              2.verticalSpace,
              Text(line2, style: AppTextStyles.font12greyRegular),
            ],
          ),
        ),
      ],
    );
  }""")

with open("lib/features/order_details/ui/order_details_screen.dart", "w", encoding="utf-8") as f:
    f.write(code)
