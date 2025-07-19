//
//  Chapter3View.swift
//  devcodingstory
//
//  Created by hanseoyoung on 7/19/25.
//

import SwiftUI
import FoundationModels

struct Chapter3View: View {
    @StateObject private var scenarioManager = ScenarioManager.shared
    @State private var aiResponse: String = "이 팀은 놀러 온 곳 아니에요. 할 거면 제대로 해요."
    @State private var userInput: String = ""
    @State private var isLoading: Bool = false

    init() {
        scenarioManager.changeChapter(to: 3)
    }

    var body: some View {
        VStack(spacing: 0) {
            // 캐릭터 이미지
            Image(uiImage: UIImage(named: "characterScene") ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)

            // 대사 말풍선 영역
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(aiResponse)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                }
                .background(Color(red: 1.0, green: 0.85, blue: 0.88))
            }

            Divider()

            // 사용자 입력 영역
            HStack {
                TextField("내 대사 입력...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)

                Button(action: {
                    Task {
                        await sendUserReply()
                    }
                }) {
                    Image(systemName: isLoading ? "hourglass" : "arrow.up.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(userInput.isEmpty || isLoading ? .gray : .blue)
                }
                .disabled(userInput.isEmpty || isLoading)
                .padding(.trailing)
            }
            .padding(.vertical, 10)
            .background(Color.white)
        }
        .ignoresSafeArea()
    }

    // MARK: - 사용자 입력을 AI에게 전달
    func sendUserReply() async {
        guard !userInput.isEmpty else { return }

        isLoading = true
        let promptText = "상대가 이렇게 말했어요: '\(aiResponse)' \n그리고 나는 이렇게 말했어요: '\(userInput)'\n상대가 다시 대답한다면?"
        userInput = ""

        do {
            let talk = try await ConversationService.shared.talk(promptText)
            
            await MainActor.run {
                aiResponse = "“\(talk.response)”"
                isLoading = false
            }
        } catch {
            await MainActor.run {
                aiResponse = "“문제가 발생했어요: \(error.localizedDescription)”"
                isLoading = false
            }
        }
    }
}

#Preview {
    Chapter3View()
}
