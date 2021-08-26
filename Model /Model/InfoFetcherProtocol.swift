//
//  InfoFetcherProtocol.swift
//  Ticket Reservation System
//
//  Created by Gayathri V on 13/08/21.
//

import Foundation

protocol InfoFetcherProtocol {
    
    func fetchTrainStatus(for date: Date)
    
    func prepareTripChart(on date: Date)
    
}
