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
    Auth.auth().signIn(withEmail: "y2kpaulh@gmail.com", password: "123456") {  authResult, error in
      Swift.print(authResult, error)
    }
  }
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
