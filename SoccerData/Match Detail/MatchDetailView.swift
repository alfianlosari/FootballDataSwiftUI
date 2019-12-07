//
//  MatchDetailView.swift
//  SoccerData
//
//  Created by Alfian Losari on 01/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI
import Foundation

struct MatchDetailView: View {
    
    let matchToFetch: Match
    
    @ObservedObject var matchDetailViewModel = MatchDetailViewModel()
    @ObservedObject var homeImageLoader = ImageLoader()
    @ObservedObject var awayImageLoader = ImageLoader()
    
    init(matchToFetch: Match) {
        self.matchToFetch = matchToFetch
        // TODO: Football DATA API doesn't return crest url for teams, so will pass the team id to retrive the image from image cache if exists
        self.homeImageLoader = ImageLoader(teamId: matchToFetch.homeTeam.id)
        self.awayImageLoader = ImageLoader(teamId: matchToFetch.awayTeam.id)
    }
    
    var matchDetail: MatchDetail {
        matchDetailViewModel.match!
    }
    
    var body: some View {
        List {
            if matchDetailViewModel.match != nil {
                VStack(spacing: 16) {
                    HStack {
                        HStack(spacing: 24) {
                            VStack {
                                if homeImageLoader.image != nil {
                                    Image(uiImage: homeImageLoader.image!)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 120)
                                }
                                else {
                                    RoundedRectangle(cornerRadius: 60)
                                        .foregroundColor(.gray)
                                        .frame(width: 120, height: 120)
                                }
                                
                                Text(matchDetail.homeTeam.name)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                            }
                            
                            
                            Text("\(matchDetail.score?.fullTime?.homeTeam ?? 0)")
                                .font(.largeTitle)
                        }
                        Spacer()
                        Text("-")
                            .font(.title)
                        Spacer()
                        HStack(spacing: 24) {
                            Text("\(matchDetail.score?.fullTime?.awayTeam ?? 0)")
                                .font(.largeTitle)
                            VStack {
                                if awayImageLoader.image != nil {
                                    Image(uiImage: awayImageLoader.image!)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 120)
                                }
                                else {
                                    RoundedRectangle(cornerRadius: 60)
                                        .foregroundColor(.gray)
                                        .frame(width: 120, height: 120)
                                }
                                
                                Text(matchDetail.awayTeam.name)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                            }
                            
                            
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Text("HT \(matchDetail.score?.halfTime?.homeTeam ?? 0) - \(matchDetail.score?.halfTime?.awayTeam ?? 0)")
                            .font(.subheadline)
                        Spacer()
                    }
                    
                    Divider()
                    
                    
                    VStack(spacing: 4) {
                        HStack {
                            Spacer()
                            Text(matchDetail.competition.name)
                                .font(.headline)
                            Text("Matchday \(matchDetail.matchday)")
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.bottom)
                        LeftRightRow(title: "Venue", subtitle: matchDetail.venue)
                        LeftRightRow(title: "Attendance", subtitle: "\(matchDetail.attendance == nil ? "-" : "\(matchDetail.attendance!)")")
                        LeftRightRow(title: "Date", subtitle: Utilities.dateFormatter.string(from: matchDetail.utcDate))
                    }
                    .padding(.bottom)
                    
                }
                
                
                if matchDetail.goals != nil && !matchDetail.goals!.isEmpty {
                    Section(header: Text("Scorers")) {
                        MatchHomeAwaySection(homeTeamId: matchDetail.homeTeam.id, awayTeamId: matchDetail.awayTeam.id, data: matchDetail.goals!) { (home, away) in
                            MatchDetailGoalRow(homeGoal: home, awayGoal: away)
                        }
                        
                        
                    }.tag("scorers")
                }
                
                if matchDetail.bookings != nil && !matchDetail.bookings!.isEmpty {
                    Section(header: Text("Bookings")) {
                        MatchHomeAwaySection(homeTeamId: matchDetail.homeTeam.id, awayTeamId: matchDetail.awayTeam.id, data: matchDetail.bookings!) { (home, away)  in
                            MatchDetailBookingRow(home: home, away: away)
                        }
                        
                    }.tag("bookings")
                }
                
                if matchDetail.substitutions != nil && !matchDetail.substitutions!.isEmpty {
                    Section(header: Text("Substitutions")) {
                        MatchHomeAwaySection(homeTeamId: matchDetail.homeTeam.id, awayTeamId: matchDetail.awayTeam.id, data: matchDetail.substitutions!) { (home, away)  in
                            MatchDetailSubstitutionRow(home: home, away: away)
                        }
                    }
                }
                
                Section(header: Text("Team Details")) {
                    ListMiddleRow(title: "Captain", leftValue: matchDetail.homeTeam.captain?.name ?? "", rightValue: matchDetail.awayTeam.captain?.name ?? "-")
                    ListMiddleRow(title: "Coach", leftValue: matchDetail.homeTeam.coach?.name ?? "", rightValue: matchDetail.awayTeam.coach?.name ?? "-")
                    
                }
                
                
                if matchDetail.homeTeam.lineup != nil && matchDetail.awayTeam.lineup != nil {
                    Section(header: Text("Lineup")) {
                        MatchPlayerHomeAwaySection(homes: matchDetail.homeTeam.lineup!, aways: matchDetail.awayTeam.lineup!) { (home, away)  in
                            MatchDetailPlayerRow(home: home, away: away)
                        }
                    }.tag("lineup")
                }
                
                if matchDetail.homeTeam.bench != nil && matchDetail.awayTeam.bench != nil {
                    Section(header: Text("Bench")) {
                        MatchPlayerHomeAwaySection(homes: matchDetail.homeTeam.bench!, aways: matchDetail.awayTeam.bench!) { (home, away)  in
                            MatchDetailPlayerRow(home: home, away: away)
                        }
                    }.tag("bench")
                }
                
                if matchDetail.referees != nil {
                    Section(header: Text("Referee")) {
                        ForEach(matchDetail.referees!) {
                            MatchRefereeRow(referee: $0)
                        }
                    }.tag("referees")
                }
            }
        }
        .onAppear(perform: {
            self.matchDetailViewModel.fetchMatchDetail(matchId: self.matchToFetch.id)
        })
            .navigationBarTitle("Match Detail")
    }
}

struct MatchDetailPlayerRow: View {
    
    var home: Player?
    var away: Player?
    
    func playerRow(with player: Player) -> String {
        "\(player.shirtNumber != nil ? "\(player.shirtNumber!)" : "") \(player.name) (\(player.position!))"
        
    }
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            HStack {
                if home != nil {
                    
                    Text(playerRow(with: home!))
                }
                Spacer()
                
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            
            HStack {
                Spacer()
                
                if away != nil {
                    
                    Text(playerRow(with: away!))
                        .multilineTextAlignment(.trailing)
                }
                
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
        }
        
        
    }
}

struct MiddleSpacer: View {
    var body: some View {
        Rectangle()
            .frame(width: 75)
            .foregroundColor(.white)
    }
}

struct ListMiddleRow: View {
    
    var title: String
    var leftValue: String
    var rightValue: String
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Text(leftValue)
                Spacer()
                
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            
            HStack {
                Text(formattedMiddle)
                    .font(.headline)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            
            
            HStack {
                Spacer()
                Text(rightValue)
                    .multilineTextAlignment(.trailing)
                
                
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
        }
    }
    
    var formattedMiddle: String {
        return title.paddedToWidth(12)
    }
}


struct MatchHomeAwaySection<T: Identifiable, K, Content: View>: View where T.ID == K, T: Equatable {
    
    var homeTeamId: K
    var awayTeamId: K
    var data: [T]
    var content: (T?, T?) -> Content
    
    var homes: [T] {
        return data.filter { $0.id == homeTeamId}
    }
    
    var aways: [T] {
        return data.filter { $0.id == awayTeamId }
    }
    
    var totalCount: Int {
        return homes.count >= aways.count ? homes.count : aways.count
    }
    
    func homeAt(index: Int) -> T? {
        guard homes.count > index else {
            return nil
        }
        return homes[index]
    }
    
    func awayAt(index: Int) -> T? {
        guard aways.count > index else {
            return nil
        }
        return aways[index]
    }
    
    
    var body: some View {
        ForEach(0..<self.totalCount) {
            self.content(self.homeAt(index: $0), self.awayAt(index: $0))
        }
        
    }
}

struct MatchPlayerHomeAwaySection<T: Identifiable, Content: View>: View where T: Equatable {
    
    var homes: [T]
    var aways: [T]
    var content: (T?, T?) -> Content
    
    var totalCount: Int {
        return homes.count >= aways.count ? homes.count : aways.count
    }
    
    func homeAt(index: Int) -> T? {
        guard homes.count > index else {
            return nil
        }
        return homes[index]
    }
    
    func awayAt(index: Int) -> T? {
        guard aways.count > index else {
            return nil
        }
        return aways[index]
    }
    
    
    var body: some View {
        ForEach(0..<self.totalCount) {
            self.content(self.homeAt(index: $0), self.awayAt(index: $0))
        }
    }
}



struct MatchDetailGoalRow: View {
    
    var homeGoal: MatchDetailGoal?
    var awayGoal: MatchDetailGoal?
    
    var body: some View {
        HStack(spacing: 0) {
            
            HStack {
                if homeGoal != nil {
                    Text("⚽️ \(homeGoal!.minute)'")
                    Text(homeGoal!.scorer!.name)
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            
            
            
            HStack {
                if awayGoal != nil {
                    Text("⚽️ \(awayGoal!.minute)'")
                    Text(awayGoal!.scorer!.name)
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
}



struct MatchDetailBookingRow: View {
    
    var home: MatchDetailBooking?
    var away: MatchDetailBooking?
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                if home != nil {
                    Text("\(home!.isRedCard ? "🟥" : "🟨" ) \(home!.minute)'")
                    Text(home!.player.name)
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            
            
            HStack {
                if away != nil {
                    
                    Text("\(home!.isRedCard ? "🟥" : "🟨" ) \(away!.minute)'")
                    Text(away!.player.name)
                    
                }
                Spacer()
                
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
}


struct MatchDetailSubstitutionRow: View {
    
    var home: MatchDetailSubtitution?
    var away: MatchDetailSubtitution?
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                if home != nil {
                    
                    Text("\(home!.minute)'")
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.green)
                            Text("\(home!.playerIn.name)")
                            
                        }
                        
                        HStack {
                            Image(systemName: "arrow.left.circle.fill")
                                .foregroundColor(.red)
                            
                            Text("\(home!.playerOut.name)")
                            
                        }
                    }
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            HStack {
                if away != nil {
                    
                    Text("\(away!.minute)'")
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.green)
                            
                            Text("\(away!.playerIn.name)")
                            
                        }
                        HStack {
                            Image(systemName: "arrow.left.circle.fill")
                                .foregroundColor(.red)
                            
                            Text("\(away!.playerOut.name)")
                        }
                    }
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
        }
        
    }
    
}


struct MatchRefereeRow: View {
    
    var referee: Player
    
    var body: some View {
        HStack {
            Text("\(referee.name) \(referee.nationality ?? "")")
        }
    }
    
}

struct MatchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MatchDetailView(matchToFetch: Match.stubMatches[0])
        }
        
    }
}

