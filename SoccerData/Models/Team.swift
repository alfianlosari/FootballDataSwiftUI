//
//  Team.swift
//  SoccerData
//
//  Created by Alfian Losari on 02/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation

struct Area: Identifiable, Decodable {
    let id: Int
    let name: String
}

struct Team: Identifiable, Decodable {
    
    let id: Int
    let name: String
    
    let area: Area?
    
    let shortName: String?
    let tla: String?
    let clubColors: String?
    let crestUrl: String?
    let address: String?
    let phone: String?
    let website: String?
    let email: String?
    let founded: Int?
    let venue: String?
    let squad: [Player]?
    
}

extension Team {
    
    static var stubTeam: Team {
        let url = Bundle.main.url(forResource: "team", withExtension: "json")!
        let team: Team = Utilities.loadStub(url: url)
        return team
    }
    
    static var dummyTeams: [Team] {
        let teams = ["Arsenal FC", "PSM Makassar", "F.C Barcelona", "Real Madrid C.F", "Bantaeng United", "F.C Internazionale"]
        
        return teams.enumerated().map {
            Team(id: $0.offset, name: $0.element, area: Area(id: 1, name: "England"), shortName: "Arsenal", tla: "ARS", clubColors: "Red/White", crestUrl: "", address: "75 Drayton Park London N5 1BU", phone: "+44 (020) 76195003", website: "http://www.arsenal.com", email: "info@arsenal.co.uk", founded: 1886, venue: "Emirates Stadium", squad: Player.dummyPlayers)
            
        }
    }
}


struct Standing: Identifiable, Decodable {
    
    var id: String {
        "\(type)-\(stage)"
    }
    
    let type: String
    let stage: String
    let table: [TeamStandingTable]
}

struct TeamStandingTable: Identifiable, Decodable {
    
    var id: Int { team.id }
    let position: Int
    let team: Team
    
    let playedGames: Int
    let won: Int
    let draw: Int
    let lost: Int
    let points: Int
    let goalsFor: Int
    let goalsAgainst: Int
    let goalDifference: Int
    
}

extension Standing {
    
    static var dummyStandings: Standing {
        let url = Bundle.main.url(forResource: "standings", withExtension: "json")!
        let standingResponse: StandingResponse = Utilities.loadStub(url: url)
        return standingResponse.standings!.first { $0.type == "TOTAL" }!
        
    }
    
}

