//
//  MatchDetail.swift
//  SoccerData
//
//  Created by Alfian Losari on 01/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation

struct MatchDetailResponse: Decodable {
    
    var match: MatchDetail
}

struct MatchDetail: Identifiable, Decodable {
    
    var id: Int
    var competition: MatchDetailCompetition
    var utcDate: Date
    var status: String
    var attendance: Int?
    var venue: String
    var matchday: Int
    var score: MatchScore?
    var homeTeam: MatchDetailTeam
    var awayTeam: MatchDetailTeam
    var goals: [MatchDetailGoal]?
    var bookings: [MatchDetailBooking]?
    var substitutions: [MatchDetailSubtitution]?
    var referees: [Player]?
}

extension MatchDetail {
    
    static var stub: MatchDetail {
        let url = Bundle.main.url(forResource: "match_detail", withExtension: "json")!
        let response: MatchDetailResponse = Utilities.loadStub(url: url)
        return response.match
    }
    
}

struct MatchDetailCompetition: Decodable {
    var id: Int
    var name: String
}

struct MatchDetailTeam:  Decodable {
    var id: Int
    var name: String
    var coach: Player?
    var captain: Player?
    var lineup: [Player]?
    var bench: [Player]?
}

struct MatchDetailGoal: Identifiable, Equatable, Decodable {
    
    var id: Int {
        team.id
    }
    
    var minute: Int
    var extraTime: Int?
    var team: MatchDetailTeam
    var scorer: Player?
    var assist: Player?
    
    static func == (lhs: MatchDetailGoal, rhs: MatchDetailGoal) -> Bool {
        return lhs.team.id == rhs.team.id && lhs.minute == rhs.minute && (lhs.scorer?.id ?? 0) == (rhs.scorer?.id ?? 0)
    }
    
}



struct MatchDetailBooking: Identifiable, Decodable, Equatable {
    
    var id: Int {
        team.id
    }
    
    var minute: Int
    var team: MatchDetailTeam
    var player: Player
    var card: String
    
    var isYellowCard: Bool {
        card == "YELLOW_CARD"
    }
    
    var isRedCard: Bool {
        card == "RED_CARD"
    }
    
    static func == (lhs: MatchDetailBooking, rhs: MatchDetailBooking) -> Bool {
          return lhs.team.id == rhs.team.id && lhs.minute == rhs.minute && (lhs.player.id) == (rhs.player.id)
      }
      
    
}

struct MatchDetailSubtitution: Identifiable, Decodable, Equatable {
    var id: Int {
        team.id
    }
    
    var minute: Int
    var team: MatchDetailTeam
    var playerOut: Player
    var playerIn: Player
    
    static func == (lhs: MatchDetailSubtitution, rhs: MatchDetailSubtitution) -> Bool {
        return lhs.team.id == rhs.team.id && lhs.minute == rhs.minute && (lhs.playerIn.id) == (rhs.playerIn.id) && (lhs.playerOut.id) == (rhs.playerOut.id)
    }
    
}
