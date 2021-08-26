//
//  BookingProtocol.swift
//  Ticket Reservation System
//
//  Created by Gayathri V on 09/08/21.
//

import Foundation

protocol BookingProtocol {
    
    func bookTicket(username: String, travelDate: Date, source: String, dest: String, numOfPassengers: Int, nameList: [String]) -> Ticket
    
    func cancelTicket (pnrNumber: Int, of passenger: String)
    
}
