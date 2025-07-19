//
//  Chapter1View.swift
//  devcodingstory
//
//  Created by 최완복 on 2025-07-19.
//

import SwiftUI

struct Chapter1View: View {
    var body: some View {
        VStack {
            Text("Welcome to Chapter 1")
                .font(.largeTitle)
                .padding()
            Text("This is the starting point of your developer dating simulation.")
        }
    }
}

#Preview {
    Chapter1View()
} 