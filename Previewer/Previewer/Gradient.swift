import SwiftUI

private struct Gradient: ViewModifier {

    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .background {
                LinearGradient(
                    colors: [.purple, .yellow],
                    startPoint: isAnimating ? .topLeading : .bottomLeading,
                    endPoint: isAnimating ? .bottomTrailing : .topTrailing
                )
                .overlay {
                    Color.black.opacity(0.1)
                }
                .onAppear {
                    withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: true)) {
                        isAnimating.toggle()
                    }
                }
            }
    }
}

extension View {

    func gradient() -> some View {
        modifier(Gradient())
    }
}
