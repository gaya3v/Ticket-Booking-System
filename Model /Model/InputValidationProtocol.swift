//
//  InputValidationProtocol.swift
//  Ticket Reservation System
//
//  Created by Gayathri V on 13/08/21.
//

import Foundation

protocol InputValidationProtocol {
    
    func isStationNameValid(stationInput: String) -> Bool
    
    func isPassengerCountWithinLimit(enteredCount: Int) -> Bool
    
    func isBookingAllowed(for date : Date, count: Int) -> Bool
    
    func isPasswordValid(for username : String, passwordEntered: String) -> Bool
    
    func checkIfUsernameExists(username :String) -> Bool
    
    func checkIfPassengerExists(pnr: Int, name : String) -> Bool
    
}
