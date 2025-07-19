//
//  FileReader.swift
//  devcodingstory
//
//  Created on 2025-01-23.
//

import Foundation

class FileReader {
    
    /// Bundle에서 파일을 읽어 String으로 반환하는 범용 함수
    static func readTextFile(fileName: String, fileExtension: String) -> String? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("Error: Could not find file \(fileName).\(fileExtension)")
            return nil
        }
        
        do {
            return try String(contentsOf: url, encoding: .utf8)
        } catch {
            print("Error reading file: \(error)")
            return nil
        }
    }
    
    /// Bundle에서 JSON 파일을 읽어 Data로 반환하는 함수
    static func readJSONFile(fileName: String) -> Data? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("Error: Could not find file \(fileName).json")
            return nil
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Error reading JSON file: \(error)")
            return nil
        }
    }
    
    /// scenario.txt 파일을 읽어 String으로 반환하는 특화 함수
    static func readScenarioText() -> String? {
        return readTextFile(fileName: "scenario", fileExtension: "txt")
    }
    
    /// scenario.json 파일을 읽어 Data로 반환하는 특화 함수
    static func readScenarioJSON() -> Data? {
        return readJSONFile(fileName: "scenario")
    }
} 