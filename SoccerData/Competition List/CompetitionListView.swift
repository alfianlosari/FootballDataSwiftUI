//
//  ContentView.swift
//  SoccerData
//
//  Created by Alfian Losari on 01/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

struct CompetitionListView: View {
    
    private let competitions = Competition.defaultCompetitions
    @State var selectedCompetition: Competition?
    
    var body: some View {
        
        
        List(self.competitions) { competition in
            if Utilities.isRunningOnIpad {
                NavigationLink(destination: MainView(competition: competition)) {
                    Text(competition.name)
                }
                
            } else {
                Text(competition.name)
                    .onTapGesture {
                        self.selectedCompetition = competition
                }
                
            }
        }.sheet(item: self.$selectedCompetition, onDismiss: {
            self.selectedCompetition = nil
        }, content: { (competition) in
            MainView(competition: competition)
        })
            .navigationBarTitle("Competitions")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CompetitionListView()
        }
    }
}
