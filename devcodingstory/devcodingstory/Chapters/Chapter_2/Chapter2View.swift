import SwiftUI

struct Chapter2View: View {
    @State private var inputText: String = ""
    var body: some View {
        GeometryReader { geometry in
            let contentHeight = geometry.size.height - 60
            VStack(spacing: 0) {
                ImageSectionView(height: contentHeight * 0.7)
                DialogueSectionView(height: contentHeight * 0.3)
                InputSectionView(inputText: $inputText)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// 1. 이미지 영역
struct ImageSectionView: View {
    let height: CGFloat
    var body: some View {
        Image("Miso/default")
            .resizable()
            .scaledToFill()
            .frame(height: height)
            .background(Color.black)
            .clipped()
    }
}

// 2. 말풍선(텍스트) 영역
struct DialogueSectionView: View {
    let height: CGFloat
    var body: some View {
        VStack {
            Text("""
“이 팀은 놀러 온 곳 아니에요. 할 거면 제대로 해요.”
SwiftUI로 iOS 앱을 개발하는 건 쉽지 않지만, 우리가 함께 한다면 어떤 어려움도 극복할 수 있을 거예요.
""")
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
        .frame(height: height)
        .background(Color(.systemGray6))
    }
}

// 3. 입력창 영역
struct InputSectionView: View {
    @Binding var inputText: String
    var body: some View {
        HStack(spacing: 8) {
            TextField("메시지를 입력하세요...", text: $inputText)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                )
                .font(.body)
                .frame(height: 60)
            Button(action: {
                print("입력값: \(inputText)")
                inputText = ""
            }) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.blue)
            }
            .frame(height: 60)
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
