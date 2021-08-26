//
//  Station.swift
//  Ticket Reservation System
//
//  Created by Gayathri V on 09/08/21.
//

import Foundation

class Station {
    
    let stationName: String
    let stationCode: Int
    
    init(stationName: String, stationCode: Int) {
        self.stationName = stationName
        self.stationCode = stationCode
    }
    
    func getStationName() -> String {
        return stationName
    }
    
    func getStationCode() -> Int {
        return stationCode
    }
}
