//
//  Player.swift
//  SoccerData
//
//  Created by Alfian Losari on 01/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation

struct Player: Identifiable, Decodable, Equatable {
    
    var id: Int?
    var name: String
    var firstName: String?
    var dateOfBirth: String?
    var countryOfBirth: String?
    var nationality: String?
    var position: String?
    var shirtNumber: Int?
    var role: String?
    
    
}




extension Player {
    
    static var dummyPlayers: [Player] {
        return [
            Player(id: 1, name: "Cristiano Ronaldo", firstName: "CR7", dateOfBirth: "1999-11-12", countryOfBirth: "Portugal", nationality: "Portugal", position: "Attacker", shirtNumber: 7),
            Player(id: 2, name: "Ronaldo", firstName: "Ronaldo", dateOfBirth: "1999-11-12", countryOfBirth: "Portugal", nationality: "Brazil", position: "Attacker", shirtNumber: 9),
            Player(id: 3, name: "Kurniawan Dwi Julianto", firstName: "Kurniawan", dateOfBirth: "1999-11-12", countryOfBirth: "Portugal", nationality: "Indonesia", position: "Attacker", shirtNumber: 10),
            Player(id: 4, name: "Thierry Henry", firstName: "Ongry", dateOfBirth: "1999-11-12", countryOfBirth: "Portugal", nationality: "France", position: "Attacker", shirtNumber: 14),
            Player(id: 5, name: "Fransesco Totti", firstName: "Totti", dateOfBirth: "1999-11-12", countryOfBirth: "Portugal", nationality: "Italy", position: "Attacker", shirtNumber: 11),
        ]
        
        
    }
    
}
