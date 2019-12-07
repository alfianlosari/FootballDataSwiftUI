//
//  ScorerListView.swift
//  SoccerData
//
//  Created by Alfian Losari on 01/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

struct ScorerListView: View {
    
    let scorers = Scorer.stubScores
    
    var body: some View {
        List(self.scorers) { scorer in
            ZStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(scorer.player.name)
                            .font(.headline)
                        Text(scorer.team.name)
                            .font(.subheadline)
                    }
                    Spacer()
                    Text(String(describing: scorer.numberOfGoals))
                        .font(.headline)
                    
                }
                
                NavigationLink(destination: PlayerDetailView(player: scorer.player)) {
                    EmptyView()
                }
            }
        }.navigationBarTitle("Top Scorers")
    }
}

struct ScorerListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScorerListView()
        }
        
    }
}
