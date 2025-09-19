//
//  SnippetListView.swift
//  Code Snippets
//
//  Created by Jeff Braun on 18.09.25.
//

// SnippetListView.swift

import SwiftUI


struct SnippetListView: View {
    
    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject var snippetViewModel: SnippetViewModel
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    
    @State private var isPresentingNewSnippetSheet = false
    @State private var selectedSnippet: FireSnippet?
    
    private let fieldHeight: CGFloat = 54
    
    var body: some View {
        NavigationStack {
            GradientBackground {
                VStack(spacing: 0) {
                    if snippetViewModel.snippets.isEmpty {
                        Text("Keine Snippets vorhanden")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        List {
                            ForEach(snippetViewModel.snippets) { snippet in
                                SnippetListItemView(snippet: snippet)
                                    .environmentObject(categoryViewModel)
                                    .onTapGesture {
                                        selectedSnippet = snippet
                                    }
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(
                                        EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16)
                                    )
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            snippetViewModel.deleteSnippet(snippet: snippet)
                                        } label: {
                                            Label("Löschen", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .navigationDestination(item: $selectedSnippet) { snippet in
                            SnippetDetailView(snippet: snippet)
                                .environmentObject(categoryViewModel)
                        }
                    }
                }
//                .padding()
                .navigationTitle("My Snippets")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isPresentingNewSnippetSheet = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $isPresentingNewSnippetSheet) {
                    NewSnippetSheet(
                        snippetViewModel: snippetViewModel,
                        categoryViewModel: categoryViewModel
                    )
                }
            }
        }
    }
}


#Preview {
    SnippetListView()
}
