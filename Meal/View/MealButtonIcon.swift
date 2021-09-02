import SwiftUI

struct MealButtonIcon: View {
  let width: CGFloat
  let height: CGFloat
  let radius: CGFloat
  let gradientColors = Gradient(
    colors: [Color.gradientDark, Color.gradientLight])

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: radius)
        .fill(
          LinearGradient(
            gradient: gradientColors,
            startPoint: .leading,
            endPoint: .trailing))
        .frame(width: width, height: height)
      Image(uiImage: UIImage(named: "riceBowlIcon")!)
        .font(.title)
        .colorInvert()
    }
  }
}

struct MealButtonIcon_Previews: PreviewProvider {
  static var previews: some View {
    MealButtonIcon(width: 50, height: 50, radius: 10)
      .previewLayout(.sizeThatFits)
  }
}
