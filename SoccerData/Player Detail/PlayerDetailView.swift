//
//  PlayerDetailView.swift
//  SoccerData
//
//  Created by Alfian Losari on 01/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

struct PlayerDetailView: View {
    
    let player: Player
    
    var body: some View {
        List {
            LeftRightRow(title: "Full Name", subtitle: player.name)
            if (player.shirtNumber != nil) {
                LeftRightRow(title: "Shirt Number", subtitle: String(describing: player.shirtNumber!))
            }
            
            if player.position != nil {
                LeftRightRow(title: "Position", subtitle: player.position!)
            }
            
            if player.nationality != nil {
                LeftRightRow(title: "Nationality", subtitle: player.nationality!)
            }
            
            if player.countryOfBirth != nil {
                LeftRightRow(title: "Country of Birth", subtitle: player.countryOfBirth!)
            }
            
            if player.dateOfBirth != nil {
                LeftRightRow(title: "Date of Birth", subtitle: player.dateOfBirth!.replacingOccurrences(of: "T00:00:00Z", with: ""))
            }
        }
        .navigationBarTitle(player.name)
    }
}

struct PlayerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlayerDetailView(player: Player.dummyPlayers[0])
        }
    }
}
