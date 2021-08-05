//
//  PlanView.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/08/05.
//

import SwiftUI

struct PlanView: View {
    @Environment(\.verticalSizeClass) var
        verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var
        horizontalSizeClass: UserInterfaceSizeClass?
    var isIPad: Bool {
        horizontalSizeClass == .regular &&
            verticalSizeClass == .regular
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: -4) {
            HStack(alignment: .center, spacing: -16) {
                Image(uiImage: UIImage(named: "bible")!)
                    .renderingMode(.template)
                    .foregroundColor(Color(UIColor.label))
                    .padding([.leading, .trailing], 10)
                
                
                VStack(alignment: .leading, spacing: -10) {
                    HStack{
                        Text("끼니")
                            .font(.custom("NanumBrushOTF", size: 30))
                            .foregroundColor(Color(UIColor.label))
                            .bold()
                        
                        Text("08.05, 목요일")
                            .font(.footnote)
                            .foregroundColor(Color(UIColor.label))
                            .bold()
                    }
                    
                    Text("마태복음 11:11 - 12:11")
                        .foregroundColor(Color(UIColor.label))
                        .bold()
                }
                .padding(.horizontal)
                .font(.footnote)
                .foregroundColor(Color(UIColor.systemGray))
            }
            
            Text("Donec ullamcorper nulla non metus auctor fringilla. Nulla vitae elit libero, a pharetra augue. Nullam quis risus eget urna mollis ornare vel eu leo. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit.")
                .lineLimit(3)
                .font(.footnote)
                .foregroundColor(Color(UIColor.label))
                .padding(10)
        }
        .padding(10)
        .frame(width: isIPad ? 644 : nil)
        .background(Color.itemBkgd)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 10)
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView()
            .previewLayout(.sizeThatFits)
            .colorScheme(.dark)
        
        
        PlanView()
            .previewLayout(.sizeThatFits)
            .colorScheme(.light)
        
    }
}
