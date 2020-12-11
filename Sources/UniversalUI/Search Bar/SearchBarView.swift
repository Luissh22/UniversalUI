//
//  SearchBarView.swift
//  
//
//  Created by Luis Abraham on 2020-12-11.
//

import SwiftUI

struct SearchBarView: View {
    
    let placeholder: LocalizedStringKey
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color.secondarySystemBackground)
                .cornerRadius(8)
                .overlay(searchBarOverlay)
                .padding(.horizontal, 10)
                .onTapGesture {
                    isEditing = true
                }
            
            if isEditing {
                Button {
                    isEditing = false
                    text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil,
                                                    from: nil,
                                                    for: nil)
                } label: {
                    Text("Cancel")
                        .padding(.trailing, 10)
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                }
            }
        }
    }
    
    private var searchBarOverlay: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
                
            if isEditing {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(placeholder: "Search", text: .constant(""))
    }
}
