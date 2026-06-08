class AppEndpoints {
  AppEndpoints._();

  static const baseUrl2 = 'https://jsonplaceholder.typicode.com/';
  static const posts = 'posts';
  static const baseUrl = 'https://evex.runasp.net/';
  // static const baseUrl = "https://backend.evexnow.com/";
  static const register = "EVEX/Account/Register";
  static const login = "EVEX/Account/Login";
  static const addPhone = "api/Manage/AddPhoneNumber";
  static const deleteAccount = "api/Manage/DeleteAccount";
  static const confirmPhoneNumber = "api/Manage/ConfirmPhoneNumber";
  static const forgetPassword = "EVEX/Account/ForgetPassword";
  static const resetPassword = "/EVEX/Account/ResetPassword";
  // TODO: أكّد المسار ده مع الـ backend (لسه placeholder).
  static const changePassword = "api/Manage/ChangePassword";

  static const governorates = "/api/GovernoratesAndCities/GetAllGovernorates";
  static const cities = "/api/GovernoratesAndCities/{govId}";
  static const addClient = "/api/Clients/AddClient";

  //Home & profile
  static const getHomeUserAppInfo = "/api/Home/GetHomeUserAppInfo";
  static const sepcialOffers =
      "/api/Services/GetAllServicesByClient?specialOffer=true";

  static const ports = "/api/Ports/Filter";
  static const getUserData = "/api/Manage/GetUserData";
  static const updateClient = "/api/Clients/UpdateClient";

  // TODO: أكّد المسار ده مع الـ backend (لسه placeholder).
  static const joinRequest = "/api/Merchants/JoinRequest";
  // TODO: أكّد المسار ده مع الـ backend (لسه placeholder).
  static const newSuggestion = "/api/Suggestions/AddSuggestion";

  //Services
  static const services = "api/Services/GetAllServices";
  static const addition = "api/Additions/GetAllAdditions";
  static const serviceData = "api/Services/GetServiceData";
}
