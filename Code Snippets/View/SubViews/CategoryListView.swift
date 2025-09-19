//
//  CategoryListView.swift
//  Code Snippets
//
//  Created by Jeff Braun on 19.09.25.
//

import SwiftUI

struct CategoryListView: View {
    
    @EnvironmentObject private var categoryViewModel: CategoryViewModel
    @State private var newCategoryTitle: String = ""
    
    var body: some View {
        NavigationView {
            GradientBackground {
                VStack {
                    HStack {
                        TextField("New category title", text: $newCategoryTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("Add") {
                            categoryViewModel.addCategory(title: newCategoryTitle)
                            newCategoryTitle = ""
                        }
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
            }
        }
    }
}

#Preview {
    CategoryListView()
}
