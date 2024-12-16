<h1 align="center"> ConfettiView 🎉</p>
<h3 align="center"> The prettiest SwiftUI-native confetti view available </h3>
<p align="center">
    <img src="" alt="CI" />
</p>

<br/>

## Get Started

1. Install `ConfettiView`
2. Add `ConfettiView` to your project
```swift
import SwiftUI
import ConfettiView

struct ContentView: View {
    @State var showConfetti = false

    var body: some View {
        ConfettiView(isPresented: $showConfetti)
    }
}
```
