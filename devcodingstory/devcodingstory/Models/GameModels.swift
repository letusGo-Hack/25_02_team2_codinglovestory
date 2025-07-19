//
//  GameModels.swift
//  devcodingstory
//
//  Created on 2025-01-23.
//

import Foundation

// MARK: - 전체 시나리오 구조
struct GameScenario: Codable {
    let gameInfo: GameInfo
    let characters: [Character]
    let chapters: [Chapter]
    let endings: [Ending]
}

// MARK: - 게임 정보
struct GameInfo: Codable {
    let title: String
    let version: String
    let totalChapters: Int
}

// MARK: - 캐릭터
struct Character: Codable {
    let id: String
    let name: String
    let description: String
    let role: String
    let images: [String: String]?
}

// MARK: - 챕터
struct Chapter: Codable {
    let id: Int
    let title: String
    let scenes: [Scene]
}

// MARK: - 씬 (대화 또는 선택지)
struct Scene: Codable {
    let id: String
    let type: SceneType
    let character: String?
    let emotion: String?
    let text: String
    let nextScene: String?
    let choices: [Choice]?
}

// MARK: - 씬 타입
enum SceneType: String, Codable {
    case dialogue
    case choice
}

// MARK: - 선택지
struct Choice: Codable {
    let text: String
    let nextScene: String
    let affection: Int
}

// MARK: - 엔딩
struct Ending: Codable {
    let id: String
    let title: String
    let requiredAffection: Int
    let scene: Scene
}

// MARK: - 엔딩 타입 Enum
enum EndingType: String, CaseIterable {
    case good
    case friend
    case bad
    
    var title: String {
        switch self {
        case .good: return "해피 엔딩"
        case .friend: return "친구 엔딩"
        case .bad: return "배드 엔딩"
        }
    }
    
    var minAffection: Int {
        switch self {
        case .good: return 30
        case .friend: return 15
        case .bad: return 0
        }
    }
} 