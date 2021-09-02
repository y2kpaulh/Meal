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
    NotificationView(title: "창세기 1:1-5", message: "8/12,목요일", verses: "태초에 하나님이 천지를 창조하시니라\n그 땅이 혼돈하고 공허하며 흑암이 깊음 위에 있고 하나님의 영은 수면 위에 운행하시니라\n하나님이 이르시되 빛이 있으라 하시니 빛이 있었고 \n그 빛이 하나님이 보시기에 좋았더라 하나님이 빛과 어둠을 나누사\n하나님이 빛을 낮이라 부르시고 어둠을 밤이라 부르시니라 저녁이 되고 아침이 되니 이는 첫째 날이니라")
  }
}
