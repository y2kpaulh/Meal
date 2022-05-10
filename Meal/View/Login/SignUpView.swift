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
  let email = "y2kpaulh@gmail.com"
  let password = "123456"
  let displayName = "inpyo_"

  init() {
    //      Auth.auth().createUser(withEmail: self.email, password: self.password) { (authresult, err) in
    //      let uid = authresult?.user.uid
    //      let image = UIImage(named: "riceBowl")?.jpegData(compressionQuality: 0.1)
    //
    //      Storage.storage().reference().child("userImages").child(uid!).putData(image!, metadata: nil) {  (data, err) in
    //        Swift.print(data, err)
    //
    //        Storage.storage().reference().child("userImages").child(uid!).downloadURL { (url, err) in
    //          Swift.print(url, err)
    //
    //            Database.database().reference().child("users").child(uid!).setValue(["nickName": self.displayName, "profileImageUrl": url?.absoluteString])
    //
    //          let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    //            changeRequest?.displayName = self.displayName
    //          changeRequest?.photoURL = url
    //
    //          changeRequest?.commitChanges { _ in
    //            // ...
    //          }
    //        }
    //      }
    //    }
  }

  var body: some View {
    Text("Hello, World!")
  }
}

struct JoinView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView()
  }
}
