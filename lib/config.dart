class Config {
  static const String appName = "Queue App";
  //static const String apiURL = 'http://queueapi.ethiopiankidneyassociation.com/api/'; //PROD_URL
  //static const String socketURL = 'http://queueapi.ethiopiankidneyassociation.com/';
  static const String apiURL = 'http://10.0.2.2:8080/api/'; //PROD_URL
  static const String socketURL = 'http://10.0.2.2:8080/';

  static const loginAPI = "auth/signin";
  static const registerAPI = "auth/signup";
  static const userProfileAPI = "userProfile";
  static const allBranch = "allBranch";
}
