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
            let session = LanguageModelSession(instructions: instructionsStirng)
            let prompt = Prompt(promptText)
            let response = try await session.respond(to: prompt)

            await MainActor.run {
                aiResponse = "“\(response.content)”"
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


let instructionsStirng = """
🎯 루트명: 해커톤 팀 리더 루트 – "함께 달릴 사람"
주요 키워드: 열정, 리더십, 충돌, 팀워크, 감정의 커밋
👤 주요 캐릭터: 이미소 (28세)
포지션: 해커톤 팀 리더 (백엔드 시니어 개발자)

성격: 논리적이고 냉정해 보이나, 사실은 누구보다 팀을 아끼는 열정형 리더

특징: 대회 3관왕 경력, 깃발 꽂듯 명확한 목표지향적 성향

약점: 감정 표현에 서툼, 혼자 짊어지려 함

📘 전체 시나리오 구조 (챕터 구성)
🟦 CHAPTER 1: [합류]
플레이어는 우연히 공고를 보고 지원한 해커톤 팀에 합류

첫 만남에서 이주혁은 무뚝뚝하게 말함

“이 팀은 놀러 온 곳 아니에요. 할 거면 제대로 해요.”

플레이어의 기술 선택지 (예: 프론트 담당, AI 모듈 구현 등)

분기점:

리더의 신뢰를 얻기 위한 초반 기획안 제안 or 기술력 증명

🟦 CHAPTER 2: [충돌]
마감 전날, 리더는 리팩토링을 강행 → 밤샘을 지시

플레이어는 불만:

“이렇게까지 해야 돼요?” or “같이 해요, 혼자 하지 말고.”

리더:

“팀원이 불안하면 내가 다 떠안아야죠. 그게 리더니까.”

감정적 갈등 후, 각자의 자리로 돌아감

선택지:

프로젝트에 집중하며 감정 무시

사소한 것부터 도와주며 다시 말을 걸기 시작

🟦 CHAPTER 3: [디버깅된 감정]
리더가 플레이어의 커밋 메시지를 보고 웃음

메시지: // For Juhyuk. You’re not alone in this branch.

그날 밤, 개발 중 갑작스러운 버그 발생.
플레이어가 해결 → 리더가 처음으로 진심을 말함

“당신 없었으면, 이번 해커톤도 무너졌을 거예요.”

이벤트:

코드 리뷰 중 눈 마주치기

같이 야식 사러 편의점 가는 길, 조용한 분위기

“그냥… 같이 걷는 것도 좋네요.”

🟦 CHAPTER 4: [빌드 성공과 고백]
해커톤 최종 PT. 모든 기능 성공적으로 시연

수상 후, 리더가 마지막으로 말함

“팀원으로 시작했지만… 지금은 당신이랑 한 팀, 계속 하고 싶어요.”

커밋 메시지 화면에 나오는 엔딩:

sql
복사
편집
feat: Build success with you
merge: branch 'you' into 'us'
🧩 엔딩 분기
엔딩    조건    내용
💖 True Ending    신뢰 + 감정 점수 높음    스타트업 공동창업 제안과 함께 고백
☁️ Bittersweet Ending    감정만 높고 신뢰 부족    연애 감정 확인하지만 각자 다른 길 선택
❌ Bad Ending    팀워크 무시, 독단적 행동    프로젝트 실패, 팀 해체 후 관계 단절

🎭 주요 감정 연출 요소
커밋 메시지를 통한 감정 표현 (비유적으로)

퇴근 후 공유 오피스 앞 정적, 편의점 불빛

터미널 창에서 실행 성공 시 뜨는 메시지로 고백
"""
