//
//  CategoryListView.swift
//  Code Snippets
//
//  Created by Jeff Braun on 19.09.25.
//

import SwiftUI

struct CategoryListView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var categoryViewModel: CategoryViewModel
    @State private var newCategoryTitle: String = ""
    
    var body: some View {
        NavigationStack {
            GradientBackground {
                VStack {
                    HStack {
                        TextField("New category title", text: $newCategoryTitle)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        Button("Add") {
                            categoryViewModel.addCategory(title: newCategoryTitle)
                            newCategoryTitle = ""
                        }
                        .tint(Color("AccentColor"))
                    }
                    .padding()
                    
                    List {
                        ForEach(categoryViewModel.categories) { category in
                            Text(category.title)
                                .swipeActions {
                                    Button("Delete", role: .destructive) {
                                        categoryViewModel.deleteCategory(category: category)
                                    }
                                }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
                .navigationTitle("Categories")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CategoryListView()
}

