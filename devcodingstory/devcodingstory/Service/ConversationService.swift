//
//  ConversationService.swift
//  devcodingstory
//
//  Created by 최완복 on 7/19/25.
//

import Foundation
import FoundationModels

final class ConversationService {
    static let shared = ConversationService()
    
    lazy var session: LanguageModelSession = {
        guard let instructions = FileReader.readScenarioText() else {
            preconditionFailure("instructions not found")
        }
        return LanguageModelSession(
            tools: [],
            instructions: instructions
        )
    }()
    
    func talk(_ text: String) async throws -> Talk {
        let response = try await session.respond(
            to: text,
            generating: Talk.self
        )
        return response.content
    }
}
