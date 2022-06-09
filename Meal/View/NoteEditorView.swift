//
//  NoteEditorView.swift
//  Meal
//
//  Created by Inpyo Hong on 2022/06/01.
//

import SwiftUI

struct NoteEditorView: View {
  @Environment(\.presentationMode) var presentation
  @State var markdownString: String = ""

  var body: some View {
    NavigationView {
      GeometryReader { geometry in
        List {
          HStack {
            Text("Theme:")
            Spacer()

          }

          VStack {
            HStack {
              Text("Raw Markdown:")
                .bold()
              Spacer()
            }
            TextEditor(text: $markdownString)
              .frame(height: geometry.size.height * 0.3)
              .border(.gray, width: 1)
          }
          VStack {
            HStack {
              Text("Rendered Markdown:")
                .bold()
              Spacer()
            }
            HStack {
              Text(markdownString)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding(.top, 4.0)
              Spacer()
            }
            Spacer()
          }
        }
      }
      .navigationTitle("Markdown Preview")
      .navigationBarItems(
        leading: Button(action: cancelEntry) {
          Text("Cancel")
        }
      )

    }.navigationViewStyle(.stack)
  }

  func cancelEntry() {
    presentation.wrappedValue.dismiss()
  }

}

struct NoteEditorView_Previews: PreviewProvider {
  static var previews: some View {
    NoteEditorView()
  }
}
