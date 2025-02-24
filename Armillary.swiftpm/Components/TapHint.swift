import SwiftUI

struct TapHint: View {
    @State private var opacity: Double = 0.7

    var body: some View {
        HStack(spacing: 8) {
            HStack {
                Text("Back")
                    .font(.system(size: 17))
            }
            .padding(.leading, 90)
            Spacer()
            HStack {
                Text("Next")
                    .font(.system(size: 17))
            }
            .padding(.trailing, 90)
        }
        .foregroundStyle(.gray.opacity(opacity))
    }
}
