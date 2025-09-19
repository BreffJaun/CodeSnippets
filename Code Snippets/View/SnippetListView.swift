//
//  SnippetListView.swift
//  Code Snippets
//
//  Created by Jeff Braun on 18.09.25.
//

import SwiftUI

struct SnippetListView: View {
    
    @EnvironmentObject private var userViewModel: UserViewModel
    @StateObject var snippetViewModel = SnippetViewModel()
    
    @State private var title: String = ""
    @State private var code: String = ""
    
    var body: some View {
        VStack {
            Text("Add new snippet")
                .font(.headline)
            
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextEditor(text: $code)
                .frame(height: 200)
                .cornerRadius(10)
                .border(.gray, width: 0.5)
            
            Button("Add Snippet") {
                Task {
                    await snippetViewModel.addSnippet(title: title, code: code)
                    if snippetViewModel.successMessage != nil  {
                        title = ""
                        code = ""
                    }
                }
            }
            
            if let successMessage = snippetViewModel.successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
            }
            
            if let errorMessage = snippetViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            List(snippetViewModel.snippets) { snippet in
                HStack {
                    Text(snippet.title)
                    Spacer()
                    Text(snippet.code)
                }
                .swipeActions {
                    Button("Delete", role: .destructive) {
                        snippetViewModel.deleteSnippet(snippet: snippet)
                    }
                }
            }
        }
        .onDisappear {
            snippetViewModel.removeListener()
        }
    }
}

#Preview {
    SnippetListView()
}
