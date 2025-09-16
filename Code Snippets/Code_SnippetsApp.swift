import SwiftUI
import Firebase

@main
struct Code_SnippetsApp: App {
    
    @StateObject private var userViewModel = UserViewModel()
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .environmentObject(userViewModel)
    }
}

