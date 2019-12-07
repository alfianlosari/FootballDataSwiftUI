//
//  MatchListViewModel.swift
//  SoccerData
//
//  Created by Alfian Losari on 02/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation
import Combine

class MatchListViewModel: ObservableObject {
    
    @Published var matches: [Match] = []
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
    var service = FootballDataService.shared
    
    func fetchUpcomingMatches(competitionId: Int) {
        error = nil
        isLoading = true
        
        service.fetchUpcomingMatches(competitionId: competitionId) { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let matches):
                    self.matches = matches
                    
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }
    
    func fetchLatestMatches(competitionId: Int) {
        error = nil
        isLoading = true
        
        service.fetchLatestMatches(competitionId: competitionId) { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let matches):
                    self.matches = matches.reversed()
                    
                case .failure(let error):
                    self.error = error
                }
            }
            
        }
    }
    
}
