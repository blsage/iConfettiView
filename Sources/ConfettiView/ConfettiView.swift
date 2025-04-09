//
//  SwiftUIView.swift
//  UnionConfetti
//
//  Created by Benjamin Sage on 12/15/24.
//

import SwiftUI

/// A SwiftUI view that displays a confetti animation when triggered.
///
/// Use `ConfettiView` to overlay a confetti animation on your content. It is ideal for celebratory effects
/// and can be toggled on or off using the `isPresented` binding. When triggered, the animation automatically
/// resets after 5 seconds by setting `isPresented` to `false`.
///
/// - Parameters:
///   - isPresented: A binding to a `Bool` that starts the confetti animation when set to `true`.
///
/// ### Example Usage:
/// ```swift
/// struct ContentView: View {
///     @State private var showConfetti = false
///
///     var body: some View {
///         Button("Rain on me") {
///             showConfetti = true
///         }
///         .overlay(ConfettiView(isPresented: $showConfetti))
///     }
/// }
/// ```
public struct ConfettiView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    /// A binding to control the visibility of the confetti animation.
    @Binding var isPresented: Bool

    /// Creates a new `ConfettiView` instance.
    ///
    /// Use this initializer to set up the confetti animation by binding it to a Boolean value.
    ///
    /// - Parameter isPresented: A binding to a `Bool` that determines whether the confetti animation is shown.
    ///
    /// ### Example:
    /// ```swift
    /// @State private var showConfetti = false
    ///
    /// var body: some View {
    ///     ConfettiView(isPresented: $showConfetti)
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity)
    /// }
    /// ```
    public init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }

    public var body: some View {
        GeometryReader { proxy in
            ConfettiRepresentable(isPresented: $isPresented)
                .offset(y: -proxy.size.height / 2 - safeAreaInsets.top)
        }
        .edgesIgnoringSafeArea(.all)
        .allowsHitTesting(false)
    }
}

private struct ConfettiView_Previews: View {
    @State var showConfetti = false

    var body: some View {
        Button("Hello world") {
            showConfetti = true
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(ConfettiView(isPresented: $showConfetti))
    }
}

#Preview {
    ConfettiView_Previews()
}
