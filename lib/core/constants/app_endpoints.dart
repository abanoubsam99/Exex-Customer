class AppEndpoints {
  AppEndpoints._();

  static const baseUrl2 = 'https://backend.evexnow.com/';
  // static const baseUrl2 = 'https://jsonplaceholder.typicode.com/';
  static const posts = 'posts';
  static const baseUrl = 'https://backend.evexnow.com/';
  // static const baseUrl = 'https://evex.runasp.net/';

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
  static const occasions = "/api/Occasions";
  static const favorites = "/api/Favorites";
  static const walletData = "/api/Clients/GetMyClientWalletData";

  // Auth — external (Google) login — disabled (App Store guideline 4.8).
  // static const externalLogin = "/EVEX/Account/ExternalLogin";

  // Offices / branches
  static const allOffices = "/api/Home/GetAllOffices";

  // Ports
  static const portPolicy = "/api/Ports/GetPortPolicy"; // + /{portId}

  // Reservations
  static const myReservations = "/api/Reservations/GetMyReservations";
  static const myRequestReservations = "/api/Reservations/GetMyRequestReservations";
  static const billDetailsByClient = "/api/Reservations/GetBillDetailsByClient"; // + /{id}
  static const checkReservationAvailability = "/api/Reservations/CheckReservationAvailabilityByClient"; // + /{portId}?date=
  static const addClientReservation = "/api/Reservations/AddClientReservation";
  static const confirmClientReservation = "/api/Reservations/ConfirmClientReservation";
  static const confirmClientReservation2 = "/api/Reservations/ConfirmClientReservation_2";
  static const verifyPayment = "/api/Reservations/VerifyPayment";
  static const calculatePendingDeposit = "/api/Reservations/CalculatePendingDeposit";
  static const calculateNetCost = "/api/Reservations/Client/CalculateNetCost"; // + /{id}?servicePrice=...
  static const reservationUserNote = "/api/Reservations/GetReservationUserNote"; // + /{id}
  static const editReservationUserNote = "/api/Reservations/EditReservationUserNote";
  static const updateReservationRequest = "/api/Reservations/UpdateReservationRequest"; // + /{id}
  static const updateReservationByClient = "/api/Reservations/UpdateReservationByClient"; // + /{id}
  static const cancelReservation = "/api/Reservations/CancelReservationByClient"; // + /{id}
  static const downloadInfo = "/api/Reservations/DownloadInfo"; // ?id=

  // Accounts
  static const myFinancialOperations = "/api/Accounts/GetMyFinancialOperations";

  // Vendor requests
  static const vendorRequests = "/api/VendorRequests";



  //
  // // TODO: أكّد المسار ده مع الـ backend (لسه placeholder).
  // static const confirmBooking = "/api/Bookings/ConfirmPayment";



}
