//
//  ContentView.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI
import PartialSheet
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

struct ContentView: View {

  init() {
    //    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    //    changeRequest?.displayName = "Inpyo Hong"
    //    changeRequest?.commitChanges { _ in
    //      // ...
    //    }

    //    if Auth.auth().currentUser != nil {
    //      let user = Auth.auth().currentUser
    //      if let user = user {
    //        // The user's ID, unique to the Firebase project.
    //        // Do NOT use this value to authenticate with your backend server,
    //        // if you have one. Use getTokenWithCompletion:completion: instead.
    //        let uid = user.uid
    //        let email = user.email
    //        let displayName = user.displayName
    //        let photoURL = user.photoURL
    //        Swift.print(uid, email, displayName, photoURL)
    //      }
    //    }

  }

  var body: some View {
    NavigationView {

      TodayMealView()
        .navigationBarHidden(true)

      //      SignUpView()
      //      if Auth.auth().currentUser != nil {
      //        let user = Auth.auth().currentUser
      //        if let user = user {
      //          // The user's ID, unique to the Firebase project.
      //          // Do NOT use this value to authenticate with your backend server,
      //          // if you have one. Use getTokenWithCompletion:completion: instead.
      //          let uid = user.uid
      //          let email = user.email
      //          let displayName = user.displayName
      //
      //          let photoURL = user.photoURL
      //        }
      //
      //        TodayMealView()
      //          .navigationBarHidden(true)
      //      } else {
      //        LoginView()
      //      }

    }
    .navigationViewStyle(StackNavigationViewStyle())
    .attachPartialSheetToRoot()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
