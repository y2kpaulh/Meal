//
//  ContentView.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI
import PartialSheet
import PopupView

struct ContentView: View {
  @State private var selected = false
  @State private var verseIndex: VerseIndex?

  var body: some View {
    NavigationView {
      TodayMealView()
        .navigationBarHidden(true)
        .onPreferenceChange(VerseIndexPreferenceKey.self) {
          if let index = $0 {
            self.verseIndex = index
            self.selected = true
          }
        }
        .popup(isPresented: self.$selected, type: .floater(), position: .top, animation: .spring()) {
          FloatTopSecond()
        }

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

func createTopToast() -> some View {

  VStack {
    Spacer(minLength: 20)
    HStack {
      Image("shop_NA")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 50, height: 50)
        .cornerRadius(25)

      VStack(alignment: .leading, spacing: 2) {
        HStack {
          Text("Nik")
            .foregroundColor(.white)
            .fontWeight(.bold)
          Spacer()
          Text("11:30")
            .font(.system(size: 12))
            .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
        }

      }
    }
    indicator
      .padding([.top, .bottom], 10)
  }
  .frame(height: 130)
  .background(Color.gray)
}

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    var rgbValue: UInt64 = 0
    scanner.scanHexInt64(&rgbValue)

    let r = (rgbValue & 0xff0000) >> 16
    let g = (rgbValue & 0xff00) >> 8
    let b = rgbValue & 0xff

    self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
  }
}
struct FloatTopSecond: View {
  var body: some View {
    HStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 2) {
        Text("We give you a gift!")
          .foregroundColor(.white)
          .font(.system(size: 18))

        Text("30% discount until the end of the month on all products of the company.")
          .foregroundColor(.white)
          .font(.system(size: 16))
          .opacity(0.8)
      }

      Spacer()

      Image("gift")
        .aspectRatio(1.0, contentMode: .fit)
    }
    .padding(16)
    .background(Color(hex: "9265F8").cornerRadius(12))
    .shadow(color: Color(hex: "9265F8").opacity(0.5), radius: 40, x: 0, y: 12)
    .padding(.horizontal, 16)
  }
}
