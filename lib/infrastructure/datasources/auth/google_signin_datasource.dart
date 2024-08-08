
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSigninDatasource {

  final GoogleSignIn googleSignIn;

  GoogleSigninDatasource( this.googleSignIn);

  Future<GoogleSignInAccount?> signIn() async {
    return await googleSignIn.signIn();
  }

  Future<GoogleSignInAuthentication> getAuthentication(GoogleSignInAccount account) async {
    return await account.authentication;
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
  }

}