//
//  InputValidator.swift
//  Ticket Reservation System
//
//  Created by Gayathri V on 13/08/21.
//

import Foundation

class Validator : InputValidationProtocol {
    var database : Database
    
    init(database : Database) {
        self.database = database
    }
    //check pnr for avoiding re-generation of same pnr
    //    func checkIfPnrExist(pnrNum: Int) -> Bool {
    //        let list = database.getPnrNumberList()
    //        if list.contains(pnrNum) {
    //            return true
    //        }
    //        return false
    //    }
    
    func dataHasEntry(for date : Date) -> Bool {
        let data = database.getPnrticketDict()
        for val in data.values {
            if val.getDateOfJourney() == date {
                return true
            }
        }
        return false
    }
    
    func isStationNameValid(stationInput : String) -> Bool {
        for station in database.getStationList() {
            if station.getStationName() == stationInput { return true }
        }
        return false
    }
    
    func isPassengerCountWithinLimit(enteredCount : Int) -> Bool {
        let check = enteredCount <= 3 ? true : false
        return check
    }
    
    func isBookingAllowed(for date : Date, count: Int) -> Bool {
        let openSeatList = database.getAvailableSeatRegister()
        
        if let entry = openSeatList[date] {
            //print(entry.getWaitingSeatsAvailable().count)
            if (entry.count > 0) && (entry.count >= count)  {
                return true
            }
            
            else if (entry.count < 0) && (entry.count < count) {
                print("Booking Limit reached. No more bookings allowed")
                for ticketInfo in database.getTicketSeatDataRegister() {
                    if ticketInfo.date == date {
                        ticketInfo.cancellistCount+=1
                        return false
                    }
                }
            }
            
            for entry in database.getTicketSeatDataRegister() {
                if entry.waitlistAvailable > 0 && entry.waitlistAvailable >= count {
                    return true
                }
            }
        }
        
        else if openSeatList[date] == nil {
            database.initAvailableSeats(for: date)
            return true
        }
        print("Booking failed")
        return false
    }
    
    func checkIfUsernameExists(username :String) -> Bool {
        for user in database.getUserList() {
            if user.getUsername() == username {
                return true
            }
        }
        return false
    }
    
    func checkIfPassengerExists(pnr: Int, name : String) -> Bool {
        let peopleData = database.getPassengerList()
        for person in peopleData {
            if (person.pnr == pnr) && (person.name == name) {
                return true
            }
        }
        return false
    }
    
    func isPasswordValid(for username : String, passwordEntered: String) -> Bool {
        for user in database.getUserList() {
            if user.getUsername() == username && user.getPassword() == passwordEntered {
                return true
            }
        }
        return false
    }
}
