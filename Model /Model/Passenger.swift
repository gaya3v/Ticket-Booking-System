//
//  class model.swift
//  Ticket Reservation System
//
//  Created by Gayathri V on 07/08/21.
//

import Foundation

class Passenger {

    let name: String
    var seatNumber: Int
    var seatStatus: SeatStatus
    init (name: String, seatStatus: SeatStatus , seatNumber: Int) {
        //self.id = id
        self.name = name
        self.seatNumber = seatNumber
        self.seatStatus = seatStatus
    }
   // func getPersonId() -> Int { return id }
    func getPersonName() -> String { return name }
    func getSeatStatus() -> SeatStatus { return seatStatus }
    func getSeatNumber() -> Int { return seatNumber }
    func setSeatNumber(num : Int) { seatNumber = num }
    func setSeatStatus (status : SeatStatus) { seatStatus = status }
}


