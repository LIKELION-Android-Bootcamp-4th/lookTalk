class AuthEndpoints {


  static const String socialLogin = '/api/auth/sns-login'; // 소셜 로그인

  static const String sellerSignUp = '/api/auth/register/seller'; // 판매자 회원가입

  static const String buyerSignUp = '/api/auth/register/buyer'; // 구매자 회원가입

  static const String checkNickname = '/api/auth/check-nickname'; //GET 닉네임 체크

  static const String nicknameCheck = '/api/auth/check-nickname'; // 닉네임 중복 체크

}