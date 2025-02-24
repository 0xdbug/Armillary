import SwiftUI

struct PageControlButton: ButtonStyle {
    var opacity: CGFloat
    var color: UIColor

    init(color: UIColor = .systemBlue, opacity: CGFloat = 1) {
        self.opacity = opacity
        self.color = color
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 30, height: 30)
            .padding()
            .background(Color(color.withAlphaComponent(opacity)))
            .foregroundStyle(.white)
            .clipShape(Circle())
            .fontWeight(.bold)
            .font(.title)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 1), value: configuration.isPressed)
    }
}

struct DefaultButton: ButtonStyle {
    var opacity: CGFloat
    var color: UIColor
    
    init(color: UIColor = .systemBlue, opacity: CGFloat = 1) {
        self.opacity = opacity
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding([.top, .bottom], 12)
            .padding([.leading, .trailing], 20)
            .background(Color(color.withAlphaComponent(opacity)))
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .fontWeight(.bold)
            .font(.title2)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 1), value: configuration.isPressed)
    }
}

