//
//  StandingView.swift
//  SoccerData
//
//  Created by Alfian Losari on 01/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

struct StandingView: View {
    
    let competition: Competition
    @ObservedObject var standingViewModel = StandingViewModel()
    
    var body: some View {
        List {
            Section(header: VStack(spacing: 8) {
                Text(competition.name)
                    .font(.headline)
                Divider()
                
                HStack {
                    Text("Club")
                        .font(.headline)
                    Spacer()
                    Text(self.headerText())
                        .font(.headline)
                        .multilineTextAlignment(.trailing)
                }
                
            }.padding(.vertical)) {
                ForEach(self.standingViewModel.table) { (teamStanding) in
                    StandingTeamRow(teamStanding: teamStanding)
                }
            }
        }
        .onAppear(perform: {
            self.standingViewModel.fetchLatestStanding(competitionId: self.competition.id)
        })
        .navigationBarTitle("Standings")
    }
    
    func headerText() -> String {
        let headers = ["MP","W","D","L","GF","GA","GD","Pts"].map { $0.padding(toLength: 3, withPad: " ", startingAt: 0)}.reduce("", +)
        return headers
    }
    
    
 
}

struct StandingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StandingView(competition: Competition.defaultCompetitions[0])
        }
        
    }
}

struct StandingTeamRow: View {
    
    var teamStanding: TeamStandingTable
    @ObservedObject var imageLoader = ImageLoader()
    
    init(teamStanding: TeamStandingTable) {
        self.teamStanding = teamStanding
        guard let crestText = self.teamStanding.team.crestUrl, let crestURL = URL(string: crestText) else {
            return
        }
        self.imageLoader.downloadImage(url: crestURL, teamId: teamStanding.team.id)
    }
    
    var body: some View {
        ZStack {
            HStack() {
                if Utilities.isRunningOnIpad {
                    Text(self.positionText(with: teamStanding.position))

                    if (imageLoader.image != nil) {
                        Image(uiImage: imageLoader.image!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                    } else {
                        RoundedRectangle(cornerRadius: 12.5)
                            .foregroundColor(.gray)
                            .frame(width: 25, height: 25)
                    }
                    
                } else {
                    Text(self.positionText(with: teamStanding.position))
                    
                    if (imageLoader.image != nil) {
                        Image(uiImage: imageLoader.image!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                    } else {
                        RoundedRectangle(cornerRadius: 7.5)
                            .foregroundColor(.gray)
                            .frame(width: 15, height: 15)
                    }
                    
                    Text(teamStanding.team.shortName ?? teamStanding.team.name)
                        .multilineTextAlignment(.leading)
                }
                
              
                Spacer()
                Text(self.pointRepresentationRowText(with: teamStanding))
                    .frame(width: 210)
                    .multilineTextAlignment(.trailing)
            }
            NavigationLink(destination: TeamDetailView(teamToFetch: teamStanding.team)) {
                EmptyView()
            }
        }
    }
    
    func positionText(with pos: Int) -> String {
         let positionText = String(describing: pos)
         return positionText.padding(toLength: 2, withPad: " ", startingAt: 0)
     }
     
     func pointRepresentationRowText(with table: TeamStandingTable) -> String {
         let rows = ["\(table.playedGames)","\(table.won)", "\(table.draw)","\(table.lost)","\(table.goalsFor)","\(table.goalsAgainst)","\(table.goalDifference)","\(table.points)"].map { $0.padding(toLength: 4, withPad: " ", startingAt: 0)}.reduce("", +)
         return rows
     }
     
}
