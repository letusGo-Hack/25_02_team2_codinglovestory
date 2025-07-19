//
//  MainView.swift
//  devcodingstory
//
//  Created by 상선 on 7/19/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                NavigationLink(destination: Chapter1View()) {
                    Image("Title")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 300)
                        .padding()
                }
                .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일 제거
                
                Text("탭하여 시작하기")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 50)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .toolbar(.hidden, for: .navigationBar) // iOS 16+ 지원
        }
    }
}

#Preview {
    MainView()
} 