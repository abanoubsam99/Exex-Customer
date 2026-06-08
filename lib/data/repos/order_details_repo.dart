import 'package:evex_user/data/models/order_details_model.dart';

class OrderDetailsRepo {
  /// TODO: لسه مفيش endpoint لتفاصيل الحجز.
  /// لما يتوفر، استبدل الـ mock بـ:
  ///   final response = await DioHelper.getData(url: '${AppEndpoints.orderDetails}/$bookingId');
  ///   return OrderDetailsModel.fromJson(response.data);
  Future<OrderDetailsModel?> getOrderDetails({String? bookingId}) async {
    return const OrderDetailsModel(
      bookingNumber: '20039',
      customer: OrderCustomer(
        name: 'بيشوى باسم صدقى',
        email: 'beshoybassem@gmail.com',
        phone: '+201220789797',
        address: 'مصر , اسيوط , اسيوط الجديدة',
      ),
      status: 'حجز مؤكد',
      createdDate: '16 فبراير 2025',
      createdTime: '12:20 م',
      hallName: 'قاعه البارون',
      eventType: 'فرح',
      venueLocation: 'اسيوط , اسيوط الجديدة',
      eventDay: 'الاثنين',
      eventDate: '5 , اغسطس , 2025',
      basicService: OrderLineItem(
        name: 'عرض الزفاف الشامل',
        price: 1100,
        description: 'تفاصيل الخدمه ويكنك وضع اى وصف ...',
      ),
      additions: [
        OrderLineItem(
          name: 'عرض الزفاف الشامل',
          price: 1100,
          count: 6,
          subName: 'غرفه ميكب',
          subPrice: 0,
        ),
      ],
      buffet: [
        OrderLineItem(
          name: 'عرض الزفاف الشامل',
          price: 1100,
          count: 6,
          subName: 'غرفه ميكب',
          subPrice: 0,
        ),
      ],
      costBreakdown: [
        CostRow(label: 'عموله evex', value: 0),
        CostRow(label: 'رسوم إدارية', value: 0),
        CostRow(label: 'ضريبة', value: 0),
        CostRow(label: 'مبلغ التأمين', value: 0),
        CostRow(label: 'مقدم الحجز', value: 0),
        CostRow(label: 'كاش باك', value: 0, unit: 'نقطة'),
        CostRow(label: 'خصم إضافي من التاجر', value: 0),
        CostRow(label: 'خصم إضافي من evex', value: 0),
        CostRow(
          label: 'تكلفة إضافية من التاجر',
          value: 0,
          subtitle: 'باركينج سيارات بالاضافه الى تكاليف اضافية اخرى',
        ),
        CostRow(
          label: 'تكلفة إضافية من evex',
          value: 0,
          subtitle: 'باركينج سيارات بالاضافه الى تكاليف اضافية اخرى',
        ),
      ],
      totalCost: 1200,
      paid: 0,
      remaining: 0,
      refunded: 0,
    );
  }
}
