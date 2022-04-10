class API_URL {
  // static const String liveBaseURL =
  //     "https://shiny-awful-wildebeast.gigalixirapp.com/api/v1";
  static const String localBaseURL = "http://192.168.1.239:8080/api";

  static const String baseURL = localBaseURL;
  static const String login = baseURL + "/login";
  static const String signup = baseURL + "/signup";
  static const String sentmail = baseURL + "/sentmail";
  static const String resetpassword = baseURL + "/resetpassword";
}
