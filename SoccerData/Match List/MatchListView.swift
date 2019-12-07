//
//  Matchview.swift
//  SoccerData
//
//  Created by Alfian Losari on 01/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI
import Combine

enum MatchListType {
    case latest
    case upcoming
}

struct MatchListView: View {
    
    let competition: Competition
    let type: MatchListType
    @ObservedObject var modelListViewModel = MatchListViewModel()
    
    var body: some View {
        List(self.modelListViewModel.matches) {
            MatchListRow(match: $0)
        }
        .onAppear {
            switch self.type {
            case .latest:
                self.modelListViewModel.fetchLatestMatches(competitionId: self.competition.id)
            case .upcoming:
                self.modelListViewModel.fetchUpcomingMatches(competitionId: self.competition.id)
            }
        }
        
    }
}

struct MatchListRow: View {
    
    var match: Match
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd/MM"
        return formatter
    }()
    
    @ObservedObject var homeImageLoader = ImageLoader()
    @ObservedObject var awayImageLoader = ImageLoader()
    
    init(match: Match) {
        self.match = match
        // TODO: Football DATA API doesn't return crest url for teams, so will pass the team id to retrive the image from image cache if exists
        self.homeImageLoader = ImageLoader(teamId: match.homeTeam.id)
        self.awayImageLoader = ImageLoader(teamId: match.awayTeam.id)
    }
    
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        if (self.homeImageLoader.image != nil) {
                            Image(uiImage: self.homeImageLoader.image!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15)
                        } else {
                            RoundedRectangle(cornerRadius: 7.5)
                                .foregroundColor(.gray)
                                .frame(width: 15, height: 15)
                        }
                        Text(match.homeTeam.name)
                            .font(match.score.isHomeWinner ? .headline : .body)
                    }
                    
                    HStack {
                        if (self.awayImageLoader.image != nil) {
                            Image(uiImage: self.awayImageLoader.image!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15)
                        } else {
                            RoundedRectangle(cornerRadius: 7.5)
                                .foregroundColor(.gray)
                                .frame(width: 15, height: 15)
                        }
                        
                        Text(match.awayTeam.name)
                            .font(match.score.isAwayWinner ? .headline : .body)
                        
                    }
                    
                    
                }
                Spacer()
                
                if match.score.winner != nil {
                    
                    VStack(alignment: .trailing, spacing: 8) {
                        HStack {
                            if match.score.halfTime != nil {
                                MatchListTeamScoreView(title: "HT", score: match.score.halfTime!, isHomeWinner: match.score.isHomeWinner, isAwayWinner: match.score.isAwayWinner)
                            }
                            if match.score.fullTime != nil {
                                MatchListTeamScoreView(title: "FT", score: match.score.fullTime!, isHomeWinner: match.score.isHomeWinner, isAwayWinner: match.score.isAwayWinner)
                            }
                            
                        }
                        Text(MatchListRow.dateFormatter.string(from: match.utcDate))
                    }
                } else {
                    Text(MatchListRow.dateFormatter.string(from: match.utcDate))
                        .font(.headline)
                }
        
            }
            .padding(.vertical)
            
            NavigationLink(destination: MatchDetailView(matchToFetch: match)) {
                EmptyView()
            }
        }
    }
}

struct MatchListTeamScoreView: View {
    
    var title: String
    var score: MatchScoreTime
    var isHomeWinner: Bool
    var isAwayWinner: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Text(title)
                .font(.headline)
            VStack(alignment: .leading, spacing: 16) {
                Text(String(describing: score.homeTeam ?? 0))
                    .font(isHomeWinner ? .headline : .body)
                Text(String(describing: score.awayTeam ?? 0))
                    .font(isAwayWinner ? .headline : .body)
            }
        }
    }
}


struct Matchview_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MatchListView(competition: Competition.defaultCompetitions[0], type: .upcoming)
        }
        
    }
}
