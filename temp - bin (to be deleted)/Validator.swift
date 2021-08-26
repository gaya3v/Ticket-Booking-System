////
////  InputValidator.swift
////  Ticket Reservation System
////
////  Created by Gayathri V on 13/08/21.
////
//
//import Foundation
//
//class Validator : InputValidationProtocol {
//    var database : Database
//    
//    init(database : Database) {
//        self.database = database
//    }
//    //check pnr for avoiding re-generation of same pnr
//    //    func checkIfPnrExist(pnrNum: Int) -> Bool {
//    //        let list = database.getPnrNumberList()
//    //        if list.contains(pnrNum) {
//    //            return true
//    //        }
//    //        return false
//    //    }
//    
//    func dataHasEntry(for date : Date) -> Bool {
//        let data = database.getSeatDetails()
//        if data.keys.contains(date) {
//            return true
//        }
//        return false
//    }
//    
//    func isStationNameValid(stationInput : String) -> Bool {
//        for station in database.getStationList() {
//            if station.getStationName() == stationInput { return true }
//        }
//        return false
//    }
//    
//    func isPassengerCountWithinLimit(enteredCount : Int) -> Bool {
//        let check = enteredCount <= 3 ? true : false
//        return check
//    }
//    
//    func isBookingAllowed(for date : Date, count: Int) -> Bool {
//        let seatDetails = database.getSeatDetails()
//
//        if let entry = seatDetails[date] {
//            //print(entry.getWaitingSeatsAvailable().count)
//            if ((entry.getWaitingSeatsAvailable() > 0) || !(entry.getAvailableSeatList().isEmpty)) && (entry.getAvailableSeatList().count >= count || entry.getWaitingSeatsAvailable() >= count) {
//                return true
//            }
//            else {
//                print("Booking Limit reached. No more bookings allowed")
//                entry.addToCancelledListCount()
//                database.addCancelCount(for: date)
//            }
//        }
//        
//        else if (seatDetails.isEmpty) || seatDetails[date] == nil {
//            database.addSeatDataEntry(for: date)
//            return true
//        }
//        
//        return false
//    }
//    
//    func checkIfUsernameExists(username :String) -> Bool {
//        for user in database.getUserList() {
//            if user.getUsername() == username {
//                return true
//            }
//        }
//        return false
//    }
//    
//    func checkIfPassengerExists(pnr: Int, name : String) -> Bool {
//        let data = database.getSeatDetails()
//        for seatDataValue in data.values {
//            let bookings = seatDataValue.getTicketBookingList()
//            guard let ticket = bookings[pnr]  else { return false }
//            let list = ticket.getPassengerList()
//            for member in list {
//                if member.getPersonName() == name {
//                    return true
//                }
//            }
//        }
//        return false
//    }
//    
//    func isPasswordValid(for username : String, passwordEntered: String) -> Bool {
//        for user in database.getUserList() {
//            if user.getUsername() == username && user.getPassword() == passwordEntered {
//                return true
//            }
//        }
//        return false
//    }
//}
