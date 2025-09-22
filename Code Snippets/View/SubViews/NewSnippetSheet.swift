//
//  NewSnippetSheet.swift
//  Code Snippets
//
//  Created by Jeff Braun on 19.09.25.
//

import SwiftUI

struct NewSnippetSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var snippetViewModel: SnippetViewModel
    @ObservedObject var categoryViewModel: CategoryViewModel
    
    @State private var title: String = ""
    @State private var code: String = ""
    @State private var selectedCategoryId: String? = nil
    @State private var isShowingCategorySheet = false
    
    private let fieldHeight: CGFloat = 54
    
    var body: some View {
        GradientBackground {
            VStack(spacing: 0) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .padding(8)
                    }
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .tint(Color("AccentColor"))
                    
                    Spacer()
                    
                    Button {
                        isShowingCategorySheet = true
                    } label: {
                        Image(systemName: "folder.badge.plus")
                            .font(.title3)
                            .padding(8)
                    }
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("New Snippet")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                        
                        TextField("Title", text: $title)
                            .padding()
                            .frame(height: fieldHeight)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        TextEditor(text: $code)
                            .frame(height: 200)
                            .padding(4)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                            .scrollContentBackground(.hidden)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Picker("Category", selection: $selectedCategoryId) {
                                Text("None").tag(nil as String?)
                                ForEach(categoryViewModel.categories) { category in
                                    Text(category.title)
                                        .tag(category.id as String?)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            Task {
                                await snippetViewModel.addSnippet(
                                    title: title,
                                    code: code,
                                    categoryId: selectedCategoryId
                                )
                                if snippetViewModel.successMessage != nil {
                                    dismiss()
                                }
                            }
                        }) {
                            Text("Add Snippet")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .frame(height: fieldHeight)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(title.isEmpty || code.isEmpty)
                    }
                    .navigationTitle("New Snippet")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                dismiss()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add Snippet") {
                                Task {
                                    await snippetViewModel.addSnippet(
                                        title: title,
                                        code: code,
                                        categoryId: selectedCategoryId
                                    )
                                    if snippetViewModel.successMessage != nil {
                                        dismiss()
                                    }
                                }
                            }
                            .disabled(title.isEmpty || code.isEmpty)
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                isShowingCategorySheet = true
                            }) {
                                Label("Add Category", systemImage: "folder.badge.plus")
                            }
                        }
                    }
                    .sheet(isPresented: $isShowingCategorySheet) {
                        CategoryListView()
                            .environmentObject(categoryViewModel)
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $isShowingCategorySheet) {
                CategoryListView()
                    .environmentObject(categoryViewModel)
            }
        }
    }
}


//#Preview {
//    NewSnippetSheet()
//}
