//
//  LoginView.swift
//  Meal
//
//  Created by Inpyo Hong on 2022/05/08.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

struct LoginView: View {
  init() {
    //    Auth.auth().signIn(withEmail: "y2kpaulh@gmail.com", password: "hiphop0816") {  authResult, _ in
    //      Swift.print("authResult", authResult!)
    //      AppSettings[.isLoggedIn] = true
    //    }
  }

  var body: some View {
    Text("Hello, LoginView!")
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
