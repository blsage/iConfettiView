<h1 align="center">UnionConfetti 🎉</h1>
<h3 align="center">The prettiest SwiftUI‑native confetti.</h3>
<p align="center">
    <img src="./Resources/example1.gif" alt="UnionConfetti demo" />
</p>

<br/>

## Get Started

1. Install **UnionConfetti** from Swift Package Manager  
   `https://github.com/unionst/union-confetti`

2. Drop `ConfettiView` into your view hierarchy

```swift
import SwiftUI
import UnionConfetti

struct ContentView: View {
    @State private var showConfetti = false

    var body: some View {
        Button("Rain on me") {
            showConfetti = true
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(ConfettiView(isPresented: $showConfetti))
    }
}
