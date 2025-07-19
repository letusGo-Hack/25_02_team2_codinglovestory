//
//  ScenarioManager.swift
//  devcodingstory
//
//  Created on 2025-01-23.
//

import Foundation
import SwiftUI

class ScenarioManager: ObservableObject {
    static let shared = ScenarioManager()
    
    @Published var scenario: GameScenario?
    @Published var currentScene: Scene?
    @Published var currentChapter: Int = 1
    @Published var affectionLevel: Int = 0
    @Published var gameEnded: Bool = false
    @Published var currentEnding: Ending?
    
    private init() {
        loadScenario()
    }
    
    // MARK: - 시나리오 로드
    func loadScenario() {
        guard let jsonData = FileReader.readScenarioJSON() else {
            print("Error: Could not read scenario.json")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            scenario = try decoder.decode(GameScenario.self, from: jsonData)
            print("Scenario loaded successfully")
            
            // 첫 번째 씬으로 이동
            if let firstChapter = scenario?.chapters.first,
               let firstScene = firstChapter.scenes.first {
                currentScene = firstScene
            }
        } catch {
            print("Error decoding scenario: \(error)")
        }
    }
    
    // MARK: - 전체 시나리오 가져오기
    func getFullScenario() -> GameScenario? {
        return scenario
    }
    
    // MARK: - 챕터별 시나리오 가져오기
    func getChapter(id: Int) -> Chapter? {
        return scenario?.chapters.first { $0.id == id }
    }
    
    // MARK: - 현재 챕터 가져오기
    func getCurrentChapter() -> Chapter? {
        return getChapter(id: currentChapter)
    }
    
    // MARK: - 캐릭터 정보 가져오기
    func getCharacter(id: String) -> Character? {
        return scenario?.characters.first { $0.id == id }
    }
    
    // MARK: - 모든 캐릭터 가져오기
    func getAllCharacters() -> [Character] {
        return scenario?.characters ?? []
    }
    
    // MARK: - 씬 찾기
    func findScene(id: String) -> Scene? {
        for chapter in scenario?.chapters ?? [] {
            if let scene = chapter.scenes.first(where: { $0.id == id }) {
                return scene
            }
        }
        
        // 엔딩 씬에서도 찾기
        if let endingScene = scenario?.endings.first(where: { $0.scene.id == id })?.scene {
            return endingScene
        }
        
        return nil
    }
    
    // MARK: - 다음 씬으로 이동
    func moveToNextScene(sceneId: String) {
        guard let nextScene = findScene(id: sceneId) else {
            print("Scene not found: \(sceneId)")
            checkForEnding()
            return
        }
        
        currentScene = nextScene
        
        // 챕터가 바뀌었는지 확인
        if sceneId.starts(with: "2-") {
            currentChapter = 2
        } else if sceneId.starts(with: "3-") {
            currentChapter = 3
        }
        
        // 엔딩 체크
        if sceneId.starts(with: "ending-") {
            checkForEnding()
        }
    }
    
    // MARK: - 선택지 선택
    func makeChoice(_ choice: Choice) {
        affectionLevel += choice.affection
        print("Affection level: \(affectionLevel)")
        moveToNextScene(sceneId: choice.nextScene)
    }
    
    // MARK: - 엔딩 체크
    func checkForEnding() {
        guard let endings = scenario?.endings else { return }
        
        // 호감도에 따라 적절한 엔딩 찾기
        let sortedEndings = endings.sorted { $0.requiredAffection > $1.requiredAffection }
        
        for ending in sortedEndings {
            if affectionLevel >= ending.requiredAffection {
                currentEnding = ending
                currentScene = ending.scene
                gameEnded = true
                break
            }
        }
    }
    
    // MARK: - 게임 리셋
    func resetGame() {
        currentScene = scenario?.chapters.first?.scenes.first
        currentChapter = 1
        affectionLevel = 0
        gameEnded = false
        currentEnding = nil
    }
    
    // MARK: - 미소 이미지 가져오기
    func getMisoImage(for emotion: String?) -> String {
        guard let emotion = emotion else { return "default" }
        return "Miso/\(emotion)"
    }
} 