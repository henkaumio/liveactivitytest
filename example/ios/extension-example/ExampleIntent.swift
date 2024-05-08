//
//  ExampleIntent.swift
//  Runner
//
//  Created by Henk van der Sloot on 08.02.24.
//
import AppIntents
import Foundation


@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct PauseIntent: LiveActivityIntent {
    
    static var title: LocalizedStringResource = "pause"
    static var description = IntentDescription("pause")

    func perform() async throws -> some IntentResult {

        NotificationCenter.default.post(name: NSNotification.Name("pause"), object: nil)
        
        print("setting paused default to true")
       
        return .result()
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct PlayIntent: LiveActivityIntent {
    
    static var title: LocalizedStringResource = "play"
    static var description = IntentDescription("play")
    
    func perform() async throws -> some IntentResult {
        NotificationCenter.default.post(name: NSNotification.Name("play"), object: nil)
        return .result()
    }
}

