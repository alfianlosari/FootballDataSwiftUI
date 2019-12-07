//
//  MatchDetailViewModel.swift
//  SoccerData
//
//  Created by Alfian Losari on 03/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation
import Combine

class MatchDetailViewModel: ObservableObject {
    
    @Published var match: MatchDetail?
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
    var service = FootballDataService.shared
    
    func fetchMatchDetail(matchId: Int) {
        error = nil
        isLoading = true
        
        service.fetchMatchDetail(matchId: matchId) { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(var match):
                    // Football Data API Free Plan doesn't return all match detail data (squad, bench, scorer, etcs)
                    // Stubbing is done to demo the UI
                    // Consider using paid plan and remove stub to show realtime data
                    
                    let stubURL = Bundle.main.url(forResource: "match_detail", withExtension: "json")!
                    let stubMatchResponse: MatchDetailResponse = Utilities.loadStub(url: stubURL)
                    let stubMatch = stubMatchResponse.match
                    match.attendance = stubMatch.attendance
                    
                    match.bookings = stubMatch.bookings
                    match.substitutions = stubMatch.substitutions
                   
                    match.homeTeam.id = stubMatch.homeTeam.id
                    match.homeTeam.captain = stubMatch.homeTeam.captain
                    match.homeTeam.coach = stubMatch.homeTeam.coach
                    match.homeTeam.lineup = stubMatch.homeTeam.lineup
                    match.homeTeam.bench = stubMatch.homeTeam.bench
                    
                    match.awayTeam.id = stubMatch.awayTeam.id
                    match.awayTeam.captain = stubMatch.awayTeam.captain
                    match.awayTeam.coach = stubMatch.awayTeam.coach
                    match.awayTeam.lineup = stubMatch.awayTeam.lineup
                    match.awayTeam.bench = stubMatch.awayTeam.bench
                    
                    
                    var goals = [MatchDetailGoal]()

                    let homeGoalCount = match.score?.fullTime?.homeTeam ?? 0

                    for _ in 0..<homeGoalCount {
                        goals.append(MatchDetailGoal(minute: (1...90).randomElement() ?? 0, extraTime: 0, team: match.homeTeam, scorer: Player.homeRandomPlayer, assist: nil))
                    }
                    
                    let awayGoalCount = match.score?.fullTime?.awayTeam ?? 0

                    
                    for _ in 0..<awayGoalCount {
                         goals.append(MatchDetailGoal(minute: (1...90).randomElement() ?? 0, extraTime: 0, team: match.awayTeam, scorer: Player.awayRandomPlayer, assist: nil))
                    }
                    match.goals = goals.sorted { $0.minute < $1.minute }
                    
                    
                    self.match = match
                    
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }
}


fileprivate extension Player {
    
    static var homeRandomPlayer: Player {
        return ["Ronaldo", "Rivaldo", "Ronaldinho", "Kaka"].enumerated().map { Player(id: $0.offset, name: $0.element, firstName: nil, dateOfBirth: nil, countryOfBirth: nil, nationality: nil, position: nil, shirtNumber: nil, role: nil)}.randomElement()!
        
        
    }
    
    static var awayRandomPlayer: Player {
        return ["Gabriel Batistuta", "Thierry Henry", "Zlatan Ibrahimovic", "Steven Gerrard"].enumerated().map { Player(id: 1000 + $0.offset, name: $0.element, firstName: nil, dateOfBirth: nil, countryOfBirth: nil, nationality: nil, position: nil, shirtNumber: nil, role: nil)}.randomElement()!
    }
    
    
    
    
}
