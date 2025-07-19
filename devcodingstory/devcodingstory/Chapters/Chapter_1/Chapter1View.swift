//
//  Chapter1View.swift
//  devcodingstory
//
//  Created by Grok on 2025-07-19.
//

import SwiftUI

struct Chapter1View: View {
    @StateObject private var scenarioManager = ScenarioManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            // 챕터 타이틀
            if let chapter = scenarioManager.getCurrentChapter() {
                Text("Chapter \(chapter.id): \(chapter.title)")
                    .font(.title2)
                    .padding(.top)
            }
            
            // 현재 씬 표시
            if let scene = scenarioManager.currentScene {
                SceneView(scene: scene)
            }
            
            // 호감도 표시 (디버깅용)
            HStack {
                Text("호감도: \(scenarioManager.affectionLevel)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 씬 뷰
struct SceneView: View {
    let scene: GameScene
    @StateObject private var scenarioManager = ScenarioManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            // 캐릭터 이미지 (미소인 경우)
            if scene.character == "miso", let emotion = scene.emotion {
                Image(scenarioManager.getMisoImage(for: emotion))
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .padding()
            }
            
            // 대화 텍스트
            Text(scene.text)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Spacer()
            
            // 선택지 또는 다음 버튼
            if scene.type == .choice, let choices = scene.choices {
                // 선택지 표시
                VStack(spacing: 15) {
                    ForEach(choices, id: \.text) { choice in
                        Button(action: {
                            scenarioManager.makeChoice(choice)
                        }) {
                            Text(choice.text)
                                .font(.callout)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            } else if let nextScene = scene.nextScene {
                // 다음 버튼
                Button(action: {
                    scenarioManager.moveToNextScene(sceneId: nextScene)
                }) {
                    Text("다음")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 100)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            
            // 게임 종료 시
            if scenarioManager.gameEnded {
                VStack(spacing: 15) {
                    if let ending = scenarioManager.currentEnding {
                        Text(ending.title)
                            .font(.title)
                            .foregroundColor(.orange)
                    }
                    
                    Button(action: {
                        scenarioManager.resetGame()
                    }) {
                        Text("처음부터 다시 시작")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .padding(.bottom, 30)
    }
}

#Preview {
    NavigationStack {
        Chapter1View()
    }
}
