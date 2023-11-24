//
//  VerseTextView.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/09/07.
//

import SwiftUI

struct VerseTextView: View {
  var verse: String

  var body: some View {
    Text(verse)
      .lineSpacing(6)
      .multilineTextAlignment(.leading)
      .foregroundStyle(Color.mealTheme)
      .font(.custom("NanumMyeongjoOTF", size: 20))
      .padding(.top, 4)
  }
}

struct VerseTextView_Previews: PreviewProvider {
  static var previews: some View {
    VerseTextView(verse: "test verse")
  }
}
