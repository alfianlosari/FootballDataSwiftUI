//
//  CompetitionRootView.swift
//  SoccerData
//
//  Created by Alfian Losari on 01/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    let competition: Competition
    var body: some View {
        TabView {
            NavigationView {
                StandingView(competition: self.competition)
                    
            }
        
        
            .tabItem {
                Image(systemName: "table.fill")
                Text("Standings")
            }
            .tag(0)
            
            
            NavigationView {
                MatchListView(competition: competition, type: .latest)
                    .navigationBarTitle("Latest")
            }
            .tabItem {
                Image(systemName: "sportscourt")
                Text("Latest")
            }
            .tag(1)
            
            NavigationView {
                MatchListView(competition: competition, type: .upcoming)
                    .navigationBarTitle("Upcoming")
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("Upcoming")
            }
            .tag(2)
            
       
            NavigationView {
                ScorerListView()
            }
            .tabItem {
                Image(systemName: "person.3.fill")
                Text("Top Scorers")
            }
            .tag(3)
        }
        .edgesIgnoringSafeArea(Utilities.isRunningOnIpad ? .top : .init())
    }
}

struct CompetitionRootView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(competition: Competition.defaultCompetitions[0])
    }
}
