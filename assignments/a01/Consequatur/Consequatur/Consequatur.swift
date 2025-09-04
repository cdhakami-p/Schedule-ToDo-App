//
//  Consequatur.swift
//  Consequatur
//
//  Created by Hwee Hong Chia on 2/17/25.
//

import Foundation

class Consequatur {
    
    static let shared = Consequatur()
    
    let booksWords: [String] = ["novel", "story", "author", "library", "fiction"]
    let planetsWords: [String] = ["mars", "jupiter", "saturn", "venus", "earth"]
    let moviesWords: [String] = ["comedy", "action", "thriller", "drama", "horror"]
    let foodWords: [String] = ["pizza", "burger", "sushi", "pasta", "taco"]
    let gamesWords: [String] = ["chess", "poker", "soccer", "basketball", "tennis"]

    private var inputStrings: [String] = []
    private var outputStrings: [String] = []

    func oneInteraction(_ input: String) -> String {
        let lowercasedInput = input.lowercased()

        var responses: [String] = []

        if containsWord(from: booksWords, in: lowercasedInput) {
            responses.append("I love books! Do you have a favorite author?")
        }
        if containsWord(from: planetsWords, in: lowercasedInput) {
            responses.append("Space is fascinating! Have you ever looked at the stars?")
        }
        if containsWord(from: moviesWords, in: lowercasedInput) {
            responses.append("Movies are great! What’s your favorite genre?")
        }
        if containsWord(from: foodWords, in: lowercasedInput) {
            responses.append("Food is life! What’s your favorite dish?")
        }
        if containsWord(from: gamesWords, in: lowercasedInput) {
            responses.append("I enjoy games too! Do you prefer board games or video games?")
        }

        let response = responses.isEmpty ? "That's interesting! Tell me more." : responses.joined(separator: " ")

        inputStrings.append(input)
        outputStrings.append(response)

        return response
    }

    private func containsWord(from category: [String], in text: String) -> Bool {
        for word in category {
            if text.contains(word) {
                return true
            }
        }
        return false
    }

    func getInputHistory() -> [String] {
        return inputStrings
    }

    func getOutputHistory() -> [String] {
        return outputStrings
    }
}
