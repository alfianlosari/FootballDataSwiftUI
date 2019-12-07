//
//  StandingViewModel.swift
//  SoccerData
//
//  Created by Alfian Losari on 02/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation
import Combine

class StandingViewModel: ObservableObject {
    
    @Published var table: [TeamStandingTable] = []
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
    var service = FootballDataService.shared
    
    func fetchLatestStanding(competitionId: Int) {
        error = nil
        isLoading = true
        
        service.fetchLatestStandings(competitionId: competitionId) { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let table):
                    self.table = table
                    
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }
}
