//
//  ContentView.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI
import PartialSheet
import FirebaseAuth

struct ContentView: View {

  init() {
    //    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    //    changeRequest?.displayName = "Inpyo Hong"
    //    changeRequest?.commitChanges { _ in
    //      // ...
    //    }

  }
  var body: some View {
    NavigationView {

      SignUpView()
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
      //          //            var multiFactorString = "MultiFactor: "
      //          //            for info in user.multiFactor.enrolledFactors {
      //          //              multiFactorString += info.displayName ?? "[DispayName]"
      //          //              multiFactorString += " "
      //          //            }
      //          //            // ...
      //
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
