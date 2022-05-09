//
//  SignUpView.swift
//  Meal
//
//  Created by Inpyo Hong on 2022/05/08.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import UIKit

struct SignUpView: View {
  init() {
    //    Auth.auth().createUser(withEmail: "y2kpaulh@gmail.com", password: "hiphop0816") { authResult, _ in
    //      Swift.print("authResult", authResult)
    //      AppSettings[.userId] = "y2kpaulh@gmail.com"
    //    }

    Auth.auth().createUser(withEmail: "paulh@naver.com", password: "123456") { authResult, error in
      Swift.print(authResult, error)

      if Auth.auth().currentUser != nil {
        let user = Auth.auth().currentUser
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          let uid = user.uid
          let image = UIImage(named: "riceBowl")!.jpegData(compressionQuality: 0.1)
          Storage.storage().reference().child("userImages").child(uid).putData(image!, metadata: nil) { data, error in
            Swift.print(data, error)

            Storage.storage().reference().child("userImages").child(uid).downloadURL { (url, _) in
              Swift.print(url, error)
              Database.database().reference().child("users").child(uid).setValue(["name": "inpyo", "profileImageUrl": url?.absoluteString])
            }
          }
        }
      }

    }

  }
  var body: some View {
    Text("Hello, SignUpView!")
  }
}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView()
  }
}
