//
//  TeamDetailViewModel.swift
//  SoccerData
//
//  Created by Alfian Losari on 02/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation
import Combine

class TeamDetailViewModel: ObservableObject {
    
    @Published var team: Team?
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
    var service = FootballDataService.shared
    
    func fetchUpcomingMatches(teamId: Int) {
        error = nil
        isLoading = true
        
        service.fetchTeamDetail(teamId: teamId) { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let team):
                    self.team = team
                    
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }
    
}


