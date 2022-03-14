import 'package:firebase_auth/firebase_auth.dart';

class ExceptionMessageCreator {
  static String createFromFirebaseAuthException(
      FirebaseAuthException exception) {
    switch (exception.code) {
      case "invalid-email":
        return "メールアドレスが間違っています。";
      case "user-disabled":
        return "このメールアドレスは無効になっています。";
      case "user-not-found":
        return "そのメールアドレスは登録されていません。";
      case "wrong-password":
        return "そのパスワードは間違っています。";
      case "email-already-in-use":
        return "そのメールアドレスは既に登録されています。";
      case "operation-not-allowed":
        return "そのメールアドレスとパスワードでのログインは無効になっています。";
      case "weak-password":
        return "パスワードは6文字以上にしてください。";
      default:
        return "予期せぬエラーが発生しました。${exception.message}";
    }
  }
}
