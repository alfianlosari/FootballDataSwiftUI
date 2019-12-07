//
//  TeamDetailView.swift
//  SoccerData
//
//  Created by Alfian Losari on 01/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

struct TeamDetailView: View {
    
    var teamToFetch: Team
    @ObservedObject var teamDetailViewModel = TeamDetailViewModel()
    
    
    var body: some View {
        List {
            if teamDetailViewModel.team != nil {
                TeamHeaderView(team: teamDetailViewModel.team!)
                ClubInformationView(team: teamDetailViewModel.team!)
                if teamDetailViewModel.team!.squad != nil {
                    TeamSquadView(players: teamDetailViewModel.team!.squad!)
                }
            }
        }
        .onAppear(perform: {
            self.teamDetailViewModel.fetchUpcomingMatches(teamId: self.teamToFetch.id)
        })
        .navigationBarTitle(teamToFetch.name)
    }
}

struct LeftRightRow: View {
    
    let title: String
    let subtitle: String
        
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.body)
                .multilineTextAlignment(.leading)
            Spacer()
            Text(subtitle)
                .font(.headline)
                .multilineTextAlignment(.trailing)
        }
    }
    
}

struct TeamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TeamDetailView(teamToFetch: Team.stubTeam)
        }
    }
}

struct TeamHeaderView: View {
    
    let team: Team
    @ObservedObject var imageLoader = ImageLoader()
    
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                if imageLoader.image != nil {
                    Image(uiImage: imageLoader.image!)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 240)
                }
                else {
                    RoundedRectangle(cornerRadius: 120)
                        .foregroundColor(.gray)
                        .frame(width: 240, height: 240)
                }
                Text("\(team.name) (\(team.tla ?? team.name))")
                    .font(.headline)
                Text(team.area?.name ?? "")
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding(.vertical)
        .onAppear {
            guard let crest = self.team.crestUrl, let crestURL = URL(string: crest) else {
                return
            }
            self.imageLoader.downloadImage(url: crestURL, teamId: self.team.id)
        }
    }
}

struct ClubInformationView: View {
    
    let team: Team
    
    var body: some View {
        Section(header: Text("Club Information")) {
            LeftRightRow(title: "Founded", subtitle: String(describing: team.founded ?? 0))
            LeftRightRow(title: "Venue", subtitle: team.venue ?? "")
            LeftRightRow(title: "Club Colors", subtitle: team.clubColors ?? "")
            LeftRightRow(title: "Address", subtitle: team.address ?? "")
            LeftRightRow(title: "Phone", subtitle: team.phone ?? "")
            LeftRightRow(title: "Website", subtitle: team.website ?? "")
            LeftRightRow(title: "Email", subtitle: team.email ?? "")
        }
    }
}

struct TeamSquadView: View {
    
    let players: [Player]
    
    var body: some View {
        Section(header: Text("Squads")) {
            ForEach(players) { player in
                ZStack {
                    HStack(alignment: .top) {
                        if (player.shirtNumber != nil) {
                            Text(String(describing: player.shirtNumber!))
                        }
                        
                        Text("\(player.name) (\(player.nationality ?? ""))")
                            .font(.headline)
                        Spacer()
                        Text(player.position ?? player.role ?? "")
                        
                    }
                    
                    NavigationLink(destination: PlayerDetailView(player: player)) {
                        EmptyView()
                        
                    }
                }
            }
        }
    }
}
