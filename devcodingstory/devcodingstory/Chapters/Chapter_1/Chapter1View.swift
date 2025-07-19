import SwiftUI

struct Chapter1View: View {
    @StateObject private var scenarioManager = ScenarioManager.shared
    @State private var inputText: String = ""
    @State private var isLoading: Bool = false
    @State private var aiResponse: String = "“이 팀은 놀러 온 곳 아니에요. 할 거면 제대로 해요.”"
    @State private var aiImage: Image = Image("Miso/default")
    @State private var currentAffection: Int = 0
    @State private var showSplash = true
    @State private var showAffectionPopup = false
    @State private var showPurchasePopup = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Main content
                let inputHeight: CGFloat = 60
                let contentHeight = max(0, geometry.size.height - geometry.safeAreaInsets.top - inputHeight)
                let imageHeight = contentHeight * 0.7
                let dialogueHeight = contentHeight * 0.3
                VStack(spacing: 0) {
                    ImageSectionView(image: aiImage)
                        .frame(height: imageHeight)
                    DialogueSectionView(text: aiResponse)
                        .frame(height: dialogueHeight)
                    InputSectionView(
                        inputText: $inputText,
                        isLoading: isLoading
                    ) { message in
                        Task {
                            await sendUserReply(message: message)
                        }
                    }
                        .frame(height: inputHeight)
                }
                .padding(.top, geometry.safeAreaInsets.top)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    Text("현재 호감도 : \(currentAffection)")
                        .frame(maxWidth: .infinity)
                        .frame(height: 24)
                        .background(Color.yellow.opacity(0.6))
                        .foregroundColor(.black)
                }
                
                if showSplash {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    Image("Chapter/chapter1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.8)
                        .opacity(showSplash ? 1 : 0)
                        .animation(.easeOut(duration: 1), value: showSplash)
                }
            }
        }
        .navigationTitle(scenarioManager.getCurrentChapter().map { "Chapter \($0.id): \($0.title)" } ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .alert("챕터1 클리어", isPresented: $showAffectionPopup) {
            Button("확인", role: .cancel) {
                showPurchasePopup = true
            }
        } message: {
            Text("축하합니다! 챕터1을 클리어하셨습니다")
        }
        .alert("결제 안내", isPresented: $showPurchasePopup) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("챕터2를 진행하려면 결제가 필요합니다.")
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
    
    // MARK: - 사용자 입력을 AI에게 전달
    func sendUserReply(message: String) async {
        guard !message.isEmpty else { return }

        isLoading = true
        let promptText = "상대가 이렇게 말했어요: '\(aiResponse)' \n그리고 나는 이렇게 말했어요: '\(message)'\n상대가 다시 대답한다면?"
        do {
            let talk = try await ConversationService.shared.talk(promptText)
            print(talk)
            await MainActor.run {
                aiResponse = talk.response
                aiImage = talk.image
                isLoading = false
                currentAffection += talk.affection
                if currentAffection >= 5 {
                    showAffectionPopup = true
                }
            }
        } catch {
            await MainActor.run {
                aiResponse = "문제가 발생했어요: \(error.localizedDescription)"
                aiImage = Image("Miso/default")
                isLoading = false
            }
        }
    }
}

// 1. 이미지 영역
struct ImageSectionView: View {
    let image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .background(Color.black)
            .clipped()
    }
}

// 2. 말풍선(텍스트) 영역
struct DialogueSectionView: View {
    let text: String
    
    var body: some View {
        VStack {
            Text(text)
                .font(.body)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
    }
}

// 3. 입력창 영역
struct InputSectionView: View {
    @Binding var inputText: String
    var isLoading: Bool = false
    var onSend: (String) -> Void

    init(inputText: Binding<String>, isLoading: Bool = false, onSend: @escaping (String) -> Void = { _ in }) {
        self._inputText = inputText
        self.isLoading = isLoading
        self.onSend = onSend
    }

    var body: some View {
        HStack(spacing: 8) {
            TextField("내 대사 입력...", text: $inputText)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                )
                .font(.body)
                .frame(height: 60)
            Button(action: {
                let text = inputText
                if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    print("입력 : \(text)")
                    onSend(text)
                    inputText = ""
                }
            }) {
                Image(systemName: isLoading ? "hourglass" : "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.blue)
            }
            .frame(height: 60)
            .disabled(isLoading)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .frame(height: 60)
        .overlay(
            Rectangle()
                .stroke(Color.gray.opacity(0.5), lineWidth: 2)
        )
    }
}

#Preview {
    Chapter2View()
}
