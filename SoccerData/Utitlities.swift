//
//  Utitlities.swift
//  SoccerData
//
//  Created by Alfian Losari on 01/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation
import UIKit

struct Utilities {
    
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    static func loadStub<D: Decodable>(url: URL) -> D {
        let data = try! Data(contentsOf: url)
        do {
            let d = try jsonDecoder.decode(D.self, from: data)
            return d
        } catch {
            print(error.localizedDescription)
            fatalError()
        }
        
    }
    
    
    static var isRunningOnIpad: Bool {
        let traitCollection = UIApplication.shared.windows.first!.traitCollection
        switch (traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass)   {
        case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.regular):
            return true
        default:
            return false
        }
    }
    
    
}
