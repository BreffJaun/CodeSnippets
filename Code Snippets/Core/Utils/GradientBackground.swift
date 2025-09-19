//
//  GradientBackground.swift
//  Reiseapp
//
//  Created by Oliver Bogumil on 08.09.25.
//

import SwiftUI

struct GradientBackground<Content: View>: View {
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("PrimaryGradientStart"),
                    Color("PrimaryGradientEnd")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            
            content
        }
    }
}
