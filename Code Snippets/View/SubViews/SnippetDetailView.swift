//
//  SnippetDetailView.swift
//  Code Snippets
//
//  Created by Jeff Braun on 19.09.25.
//

import SwiftUI

struct SnippetDetailView: View {
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    let snippet: FireSnippet
    
    var body: some View {
        GradientBackground {
        ScrollView {
            
                VStack(alignment: .leading, spacing: 20) {
                    Text(snippet.title)
                        .font(.largeTitle)
                        .bold()
                    
                    if let categoryId = snippet.categoryId,
                       let category = categoryViewModel.categories.first(where: { $0.id == categoryId }) {
                        Text("Category: \(category.title)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Text("No Category")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("Code")
                        .font(.title2)
                        .bold()
                    
                    Text(snippet.code)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .textSelection(.enabled) // Ermöglicht das Kopieren des Codes
                }
                .padding()
            }
            .navigationTitle("Snippet Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    SnippetDetailView()
//}
