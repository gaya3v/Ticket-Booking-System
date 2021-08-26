//
//  Person.swift
//  Ticket Reservation System
//
//  Created by Gayathri V on 09/08/21.
//

import Foundation

class TicketSeatData {
    
    var date : Date
    var seatCapacity = 8
    var waitlistCapacity = 3
    private lazy var availableSeatList : [Int] = Array(stride(from: 8, through: 1, by: -1))
   // private lazy var availableSeatList : [Int] = Array(stride(from: seatCapacity, through: 1, by: -1))
    lazy var waitingSeatsAvailable : Int = waitlistCapacity
    private var bookedSeatList : [Int] = []
    private var cancelledSeatListCount : Int = 0
    private var ticketBookingList : [Int : Ticket] = [:] //pnr : Ticket
    private var waitingList: [Int : (start: String, end: String)] = [:]
    
    init(date: Date) {
        self.date = date
    }
    
    func getDate() -> Date {
        return date
    }

    func getAvailableSeatList() -> [Int] {
        return availableSeatList
    }
    
    func getWaitingSeatsAvailable() -> Int {
        return waitingSeatsAvailable
    }
    
    func getWaitingList() -> [Int : (start: String, end: String)] {
        return waitingList
    }
    
    func getBookedSeatList() -> [Int] {
        return bookedSeatList
    }
    
    func getCancelledTicketCount() -> Int {
        return cancelledSeatListCount
    }
    
    func getTicketBookingList() -> [Int : Ticket] {
        return ticketBookingList
    }
    
    func setDate(newDate: Date) {
        date = newDate
    }
    
    func setTicketBookingList(ticketList: [Int : Ticket]) {
         ticketBookingList = ticketList
    }
    
    func setAvailableList (list : [Int]) {
        availableSeatList = list
    }
    
    func setBookedList (list : [Int]) {
        bookedSeatList = list
    }
    
    func setWaitList (list : [Int : (start: String, end: String)]) {
        waitingList = list
    }
    
    func setCancelledTicketCount(count : Int) {
        cancelledSeatListCount = count
    }
    
    func decrementCancellationCount(for date: Date) {
        cancelledSeatListCount -= 1
    }
    func incrementCancellationCount(for date: Date) {
        cancelledSeatListCount += 1
    }
    
    func decrementWaitlistAvailableCount(for date: Date) {
       waitingSeatsAvailable -= 1
    }
    func incrementWaitlistAvailableCount(for date: Date) {
        waitingSeatsAvailable += 1
    }
    
    func getTotalCapacity() -> Int {
        return seatCapacity
    }
    
    func getWaitlistCapacity() -> Int {
        return waitlistCapacity
    }
    
    func addNewTicketBooking(pnrKey: Int, newBooking: Ticket) {
        ticketBookingList[pnrKey] = newBooking
    }

    func addTravelInfoOfSeatToWaitList(pnr: Int, start: String, end: String) {
        waitingList[pnr] = (start: start, end: end)
    }
    
    func removeSeatInfoFromWaitList(key: Int) { //key pnr
        waitingList.removeValue(forKey: key)
    }
    
    func addToWaitingSeatsAvailable() {
        waitingSeatsAvailable+=1
    }
    
    func removeFromWaitingSeatsAvailable() {
        waitingSeatsAvailable-=1
    }

    func addSeatToAvailableList(seatNumber: Int) {
        availableSeatList.append(seatNumber)
    }
    
    func removeSeatFromAvailableList(seatNumber: Int) {
        for i in 0..<availableSeatList.count {
            if availableSeatList[i] == seatNumber {
                availableSeatList.remove(at: i)
                break
            }
        }
    }
    
    func addSeatToBookedList(seatNumber: Int) {
        bookedSeatList.append(seatNumber)
    }
    
    func removeSeatFromBookedList(seatNumber: Int) {
        if let index = bookedSeatList.firstIndex(of: seatNumber) {
            bookedSeatList.remove(at: index)
        }
    }
    
    func addToCancelledListCount() {
        cancelledSeatListCount+=1
    }
    
}
