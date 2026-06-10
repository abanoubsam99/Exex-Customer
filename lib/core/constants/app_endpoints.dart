class AppEndpoints {
  AppEndpoints._();

  static const baseUrl2 = 'https://jsonplaceholder.typicode.com/';
  static const posts = 'posts';
  static const baseUrl = 'https://evex.runasp.net/';
  // static const baseUrl = "https://backend.evexnow.com/";

  /// End Points
  static const register = "EVEX/Account/Register";
  static const login = "EVEX/Account/Login";
  static const addPhone = "api/Manage/AddPhoneNumber";
  static const getUserData = "/api/Manage/GetUserData";
  static const updateClient = "/api/Clients/UpdateClient";
  static const changePassword = "/EVEX/Account/ChangePassword";
  static const deleteAccount = "api/Manage/DeleteUserAccount";
  static const confirmPhoneNumber = "api/Manage/ConfirmPhoneNumber";
  static const forgetPassword = "EVEX/Account/ForgetPassword";
  static const resetPassword = "/EVEX/Account/ResetPassword";
  static const governorates = "/api/GovernoratesAndCities/GetAllGovernorates";
  static const cities = "/api/GovernoratesAndCities/{govId}";
  static const addClient = "/api/Clients/AddClient";
  //Home & profile
  static const getHomeUserAppInfo = "/api/Home/GetHomeUserAppInfo";
  static const sepcialOffers = "/api/Services/GetAllServicesByClient?specialOffer=true";
  static const ports = "/api/Ports/Filter";
  static const newSuggestion = "/api/Suggestions";
  // Contact us
  static const contactInfo = "/api/Home/GetEVEXContactInfoAndSocialMedia";
  static const branches = "/api/Home/GetAllBranchs";
  //Services
  static const services = "api/Services/GetAllServices";
  static const addition = "api/Additions/GetAllAdditions";
  static const serviceData = "api/Services/GetServiceData";
  static const reviews = "/api/Reviews";
  static const favorites = "/api/Favorites";
  static const walletData = "/api/Clients/GetMyClientWalletData";





  // TODO: أكّد المسار ده مع الـ backend (لسه placeholder).
  static const joinRequest = "/api/Merchants/JoinRequest";
  // TODO: أكّد المسار ده مع الـ backend (لسه placeholder).
  static const confirmBooking = "/api/Bookings/ConfirmPayment";



}
