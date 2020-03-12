import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/models/user.dart';
import 'package:main/services/firestore.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userCreation(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  // Auth onChange user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
      .map((FirebaseUser user) => _userCreation(user));
  }

  // anonymous sign-in
  Future anonSignIn() async {
    try {
      AuthResult res = await _auth.signInAnonymously();
      FirebaseUser user = res.user;
      return _userCreation(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  // email sign-in
  Future signInWithEmail(String email, String password) async {
    try{
      AuthResult res = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("We signed in");
      FirebaseUser user = res.user;
      return _userCreation(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  // email register
  Future registerWithEmail(String email, String password) async {
    try{
      AuthResult res = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = res.user;
      await FirestoreService(uid: user.uid).onUserRegister();
      return _userCreation(user);
    } catch (err){
      print(err.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (err) {
      print(err.toString());
    }
  }
}