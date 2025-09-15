import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Crash") {
              fatalError("Crash was triggered")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
