import 'package:evex_user/data/models/branch.dart';
import 'package:evex_user/data/models/contact_info.dart';

class ContactUsState {
  final bool isLoading;
  final ContactInfo? contactInfo;
  final List<Branch> branches;
  final String? errorMessage;

  const ContactUsState({
    this.isLoading = false,
    this.contactInfo,
    this.branches = const [],
    this.errorMessage,
  });

  ContactUsState copyWith({
    bool? isLoading,
    ContactInfo? contactInfo,
    List<Branch>? branches,
    String? errorMessage,
  }) {
    return ContactUsState(
      isLoading: isLoading ?? this.isLoading,
      contactInfo: contactInfo ?? this.contactInfo,
      branches: branches ?? this.branches,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
