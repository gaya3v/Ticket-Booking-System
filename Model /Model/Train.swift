////
////  Train.swift
////  Ticket Reservation System
////
////  Created by Gayathri V on 09/08/21.
////
//
//import Foundation
//
class Train {
    
    let trainNumber: Int
    var trainSchedule: [Station]
    
    init(trainNumber: Int, trainSchedule: [Station]) {
        self.trainNumber = trainNumber
        self.trainSchedule = trainSchedule
    }
    
    func getTrainNumber() -> Int {
        return trainNumber
    }
    
    func getTrainSchedule() -> [Station] {
        return trainSchedule
    }
    
}
