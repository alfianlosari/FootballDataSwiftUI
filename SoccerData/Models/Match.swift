//
//  Match.swift
//  SoccerData
//
//  Created by Alfian Losari on 01/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation

struct MatchResponse: Decodable {
    
    var matches: [Match]
    
}

struct Match: Identifiable, Decodable {
    
    var id: Int
    var utcDate: Date
    var status: String
    var matchday: Int
    var stage: String?
    var group: String?
    
    var homeTeam: Team
    var awayTeam: Team
    
    var score: MatchScore
}


extension Match {
    
    static var stubMatches: [Match] {
        let url = Bundle.main.url(forResource: "matches", withExtension: "json")!
        let matchResponse: MatchResponse = Utilities.loadStub(url: url)
        return matchResponse.matches
    }
    
    static var stubFinishedMatches: [Match] {
        let url = Bundle.main.url(forResource: "finished_matches", withExtension: "json")!
        let matchResponse: MatchResponse = Utilities.loadStub(url: url)
        return matchResponse.matches.reversed()
    }
    
}

struct MatchScore: Decodable {
    var winner: String?
    var duration: String?
    
    var fullTime: MatchScoreTime?
    var halfTime: MatchScoreTime?
    var extraTime: MatchScoreTime?
    var penalties: MatchScoreTime?
    
    var isHomeWinner: Bool {
        return (winner ?? "").lowercased().contains("home")
    }
    
    var isAwayWinner: Bool {
        return (winner ?? "").lowercased().contains("away")
    }
    
}


extension MatchScore {
    
    static var dummyMatchScores: [MatchScore] {
        return [
            MatchScore(winner: "HOME", duration: "REGULAR", fullTime: MatchScoreTime(homeTeam: 3, awayTeam: 1), halfTime: MatchScoreTime(homeTeam: 1, awayTeam: 2), extraTime: nil, penalties: nil),
            MatchScore(winner: "AWAY", duration: "REGULAR", fullTime: MatchScoreTime(homeTeam: 4, awayTeam: 5), halfTime: MatchScoreTime(homeTeam: 4, awayTeam: 0), extraTime: nil, penalties: nil),
            MatchScore(winner: "AWAY", duration: "REGULAR", fullTime: MatchScoreTime(homeTeam: 2, awayTeam: 3), halfTime: MatchScoreTime(homeTeam: 2, awayTeam: 1), extraTime: nil, penalties: nil)
        ]
    }
    
    
}

struct MatchScoreTime: Decodable {
    
    var homeTeam: Int?
    var awayTeam: Int?
    
}


