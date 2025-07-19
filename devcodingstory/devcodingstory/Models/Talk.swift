//
//  Talk.swift
//  devcodingstory
//
//  Created by 최완복 on 7/19/25.
//

import Foundation
import FoundationModels
import SwiftUI

@Generable
public struct Talk: Identifiable {
    public let id = UUID()
    
    @Guide(description: "The text of the user's request")
    public let request: String
    @Guide(description: "The text of the character's response")
    public let response: String
    @Guide(description: "A score from -5 to 5 representing the character's affection, determined based on the character's response text")
    public let affection: Int
    
    /// Name of the image asset
    @Guide(description: "Determines the ImageName enum case based on the response text content")
    public let imageName: ImageName

    /// SwiftUI Image for the asset
    public var image: Image {
        Image("Miso/\(imageName.rawValue)")
    }
    
    @Generable
    public enum ImageName: String {
        case angry, bad, coding, crying, `default`, goodEnding, smile1, smile2, smile3
    }
}
