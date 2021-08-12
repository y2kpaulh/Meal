//
//  NotificationView.swift
//  MealWatch Extension
//
//  Created by Inpyo Hong on 2021/08/06.
//

import SwiftUI

struct NotificationView: View {
  var title: String?
  var message: String?
  var verses: String?

  var body: some View {
    VStack {
      VStack {
        HStack(alignment: .center) {
          MealTitleLabel(size: 34, textColor: Color.white)
          Text(message ?? "")
            .foregroundColor(.gray)
        }
      }

      Text(title ?? "")
        .fontWeight(.bold)

      Text(verses ?? "").padding()
    }

  }
}

struct NotificationView_Previews: PreviewProvider {
  static var previews: some View {
    NotificationView()
  }
}
