//
//  AuthenticationModel.swift
//  Meal
//
//  Created by Inpyo Hong on 2022/09/14.
//

import SwiftUI
import FirebaseAuth

final class AuthenticationModel: ObservableObject {
  var user: User? {
    didSet {
      objectWillChange.send()
    }
  }

  func listenToAuthState() {
    Auth.auth().addStateDidChangeListener { [weak self] _, user in
      guard let self = self else {
        return
      }
      self.user = user
    }
  }

  func signUp(
    emailAddress: String,
    password: String
  ) {
    Auth.auth().createUser(withEmail: emailAddress, password: password)
  }

  func signIn(
    emailAddress: String,
    password: String
  ) {
    Auth.auth().signIn(withEmail: emailAddress, password: password)
  }

  func signOut() {
    try? Auth.auth().signOut()
  }
}
