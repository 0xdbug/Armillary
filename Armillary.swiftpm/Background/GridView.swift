import SwiftUI

struct GridView: View {
    var gridColor: UIColor = .init(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // vertical
                ForEach(0 ..< Int(geometry.size.width / 40 + 1), id: \.self) { index in
                    Rectangle()
                        .fill(Color(uiColor: gridColor).opacity(0.43))
                        .frame(width: 2)
                        .position(x: CGFloat(index) * 40, y: geometry.size.height / 2)
                        .frame(height: geometry.size.height)
                }

                // horizontal
                ForEach(0 ..< Int(geometry.size.height / 40 + 1), id: \.self) { index in
                    Rectangle()
                        .fill(Color(uiColor: gridColor).opacity(0.43))
                        .frame(height: 2)
                        .position(x: geometry.size.width / 2, y: CGFloat(index) * 40)
                        .frame(width: geometry.size.width)
                }
            }
        }
    }
}
