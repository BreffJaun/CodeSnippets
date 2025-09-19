//
//  SnippetListItemView.swift
//  Code Snippets
//
//  Created by Jeff Braun on 19.09.25.
//

import SwiftUI

// SnippetListItemView.swift

import SwiftUI

struct SnippetListItemView: View {
    
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    let snippet: FireSnippet
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(snippet.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let categoryId = snippet.categoryId,
                   let category = categoryViewModel.categories.first(where: { $0.id == categoryId }) {
                    Text(category.title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.7))
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

//#Preview {
//    SnippetListItemView( )
//}
