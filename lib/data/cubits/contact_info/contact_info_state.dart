class ContactInfoState {
  final bool isLoading;
  final List<String> phones;
  final bool hasError;

  const ContactInfoState({
    this.isLoading = false,
    this.phones = const [],
    this.hasError = false,
  });

  ContactInfoState copyWith({
    bool? isLoading,
    List<String>? phones,
    bool? hasError,
  }) {
    return ContactInfoState(
      isLoading: isLoading ?? this.isLoading,
      phones: phones ?? this.phones,
      hasError: hasError ?? this.hasError,
    );
  }
}
