//
//  Scorer.swift
//  SoccerData
//
//  Created by Alfian Losari on 01/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation

struct ScoreResponse: Decodable {
    
    var scorers = [Scorer]()
    
}


struct Scorer: Identifiable, Decodable {
    
    var id: Int? {
        player.id
    }
    
    let player: Player
    let team: Team
    let numberOfGoals: Int
    
}


extension Scorer {
    
    static var dummyScorers: [Scorer] {
        Player.dummyPlayers.enumerated().map {
            Scorer(player: $0.element, team: Team.dummyTeams.randomElement() ?? Team.dummyTeams[0], numberOfGoals: Int.random(in: 4...30))
        }.sorted { $0.numberOfGoals > $1.numberOfGoals }
        
    }
    
    static var stubScores: [Scorer] {
        let url = Bundle.main.url(forResource: "scorer", withExtension: "json")!
        let scoreResponse: ScoreResponse = Utilities.loadStub(url: url)
        return scoreResponse.scorers
        
    }
    
}
