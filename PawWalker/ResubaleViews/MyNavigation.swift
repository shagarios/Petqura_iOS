//
//  MyNavigation.swift
//  PawWalker
//
//  Created by shagar on 09/11/24.
//
import SwiftUI

struct MyNavigation<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack(root: content)
        } else {
            NavigationView(content: content)
        }
    }
}
