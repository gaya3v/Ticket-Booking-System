//
//  ReservationController.swift
//  Ticket Reservation System
//
//  Created by Gayathri V on 09/08/21.
//

import Foundation

class Reservation : BookingProtocol {
    
    var db : Database
    
    init(db : Database) {
        self.db = db
    }
    
    func getPassengerSeat(pnr: Int, for date : Date, startPoint : String, endPoint: String) -> (status : SeatStatus, seatNum : Int) {
        
        var passengerSeatStatus : SeatStatus = .open
        var seat = -1
        //let seatData = db.getPnrticketDict().values
        var (newCancelCount,newWaitListCount) = db.getCountDetails(for: date)
        
        if let availableSeatList = db.getAvailableSeatRegister()[date], let bookedSeatList = db.getBookedListRegister()[date] {
            // print(availableSeatsForWaitList)
            let totalSeatCapacity = db.seatCapacity
            
            seat = !availableSeatList.isEmpty ? availableSeatList[availableSeatList.endIndex-1] : 0
            
            if !(availableSeatList.isEmpty) && bookedSeatList.count < totalSeatCapacity {
                db.addToBookedList(dated: date, seatNum: seat)
                db.removeAvailableSeat(on: date)
                passengerSeatStatus = .booked
            }
            
            else if availableSeatList.isEmpty && bookedSeatList.count == totalSeatCapacity && !(newWaitListCount == 0) {
                seat = 0
                db.addToWaitList(date: date, pnr: pnr, start: startPoint, end: endPoint)
                newWaitListCount-=1
                db.setWaitlistAvailableCount(for: date, newSeatCount: newWaitListCount)
                passengerSeatStatus = .waitingList
            }
            
            else {
                newCancelCount+=1
                db.setCancelCount(for: date, newCount: newCancelCount)
                passengerSeatStatus = .cancelled
            }
        }
        return (passengerSeatStatus,seat)
    }
    
    func updateTicketList(newTicket : Ticket, for username : String) {
        
        let newPnr = newTicket.getPnrNumber()
        
        db.addPnrToList(pnr: newPnr, user: username)
        db.addTicketToList(pnr: newPnr,newTicket: newTicket)
        
    }
    
    func getValidatedPnrNumber(for user: String) -> Int {
        let utility = Utility()
        let randomNumber = utility.generateRandomNumber(startRange: 1, endRange: 20)
        let list = db.getPnrNumberList()
        if list.keys.contains(randomNumber) {
            return getValidatedPnrNumber(for: user)
        }
        else {
            return randomNumber
        }
    }
    
    func bookTicket (username: String, travelDate: Date, source: String, dest : String, numOfPassengers: Int, nameList: [String]) -> Ticket {
        
        if db.getBookedListRegister()[travelDate] == nil {
            db.initBookedSeats(for: travelDate)
            db.initCounters(for: travelDate)
        }
        let pnr = getValidatedPnrNumber(for: username)
        
        var passengerArray : [Passenger] = []
        
        for name in nameList {
            let (status,seat) = getPassengerSeat(pnr : pnr,for: travelDate, startPoint: source,endPoint: dest)
            let newMember = Passenger(name: name, seatStatus: status, seatNumber: seat)
            if seat >= 0 {
                passengerArray.append(newMember)
                db.addPassengerInfo(pnr: pnr, name: name, seat: seat, status: status)
            }
        }
        
        let newBooking = Ticket(pnrNumber: pnr, journeyDate: travelDate, startPoint: source, destinationPoint: dest, numberOfPassengers: numOfPassengers, passengers: passengerArray, trainNumber: 1)
        updateTicketList(newTicket: newBooking, for: username)
        return newBooking
    }
    //MARK: cancel operation methods
    
    func getJourneyDistance(trainNumber : Int = 1, startPlace: String, endPlace : String) -> Int {
        let route = db.getScheduleForTrain(trainNumber: trainNumber)
        var point1 = 0
        var point2 = 0
        for index in 0..<route.endIndex {
            if route[index].getStationName() == startPlace {
                point1 = index
            }
            if route[index].getStationName() == endPlace {
                point2 = index
            }
        }
        return abs(point1-point2)
    }
    
    func cancelTicket(pnrNumber : Int, of passengerName : String) {
        let ticketData = db.getPnrticketDict()
        let date : Date! = ticketData[pnrNumber]?.getDateOfJourney()
        
        let passengerData = db.getPassengerList()
        for person in passengerData{
            if person.pnr == pnrNumber {
                if !(passengerName.isEmpty) {
                    cancelIndividualTicket(from: db.getPassengerList(), passengerName: passengerName, on: date)
                    break
                }
                else {
                    cancelEntireBooking(from: db.getPassengerList(),on: date,pnr: pnrNumber)
                }
            }
        }
    }
    
    func cancelIndividualTicket(from people : [BookedPassenger], passengerName: String, on date : Date)  {
        
        for person in people {
            let seat = person.seat
            if person.name == passengerName {
                //person.status = .cancelled
                db.cancelPassenger(pnr: person.pnr, name: person.name)
                if seat > 0 {
                    db.removeSeatFromBookedData(date: date, seatNumber: seat)
                }
                else if seat == 0 {
                    db.removeFromWaitList(date: date, pnr: person.pnr)
                }
                updateSeatNumber(of: person.pnr, newValueOfSeat: seat, on: date)
                var (cancelCount,_) = db.getCountDetails(for: date)
                cancelCount+=1
                db.setCancelCount(for: date, newCount: cancelCount)
                break
            }
        }
        
    }
    func cancelEntireBooking(from people : [BookedPassenger], on date : Date, pnr : Int) {
        
        for person in people {
            if person.pnr == pnr {
                let name = person.name
                let seat = person.seat
                db.cancelPassenger(pnr: pnr, name: name)
                db.removeSeatFromBookedData(date: date, seatNumber: seat)
                updateSeatNumber(of: pnr, newValueOfSeat: seat, on: date)
                var (cancelCount,_) = db.getCountDetails(for: date)
                cancelCount+=1
                db.setCancelCount(for: date, newCount: cancelCount)
            }
        }
    }
    
    func getLongestJourneyInWaitList(on date : Date) -> Int {
        
        var distance = Int.min
        var val = 0
        let list = db.getWaitlistRegister()
        for entry in list {
            if entry.date == date {
                let (beginPoint,endPoint) = (entry.start,entry.end)
                let travelLength = getJourneyDistance(startPlace: beginPoint, endPlace: endPoint)
                if travelLength > distance {
                    distance = travelLength
                    val = entry.pnr
                }
            }
        }
        return val
    }
    
    func updateSeatNumber(of pnr: Int, newValueOfSeat : Int, on date: Date) {
        var (_,waitingSeatsLeft) = db.getCountDetails(for: date)
        if waitingSeatsLeft == db.waitlistCapacity && newValueOfSeat > 0 { //if no WL -> booked is there
            db.addAvailableSeat(on: date, num: newValueOfSeat)
        }
        
        else { // WL -> Booked, update booked
            let val = getLongestJourneyInWaitList(on: date)
            db.removeFromWaitList(date: date, pnr: val)
            
            for passenger in db.getPassengerList() {
                if passenger.status == .waitingList {
                    db.setSeatNumberAndStatus(newSeat: newValueOfSeat, status: .booked, passenger: passenger.name, pnr: val)
                    break
                }
            }
            
            db.addToBookedList(dated: date, seatNum: newValueOfSeat)
            waitingSeatsLeft+=1
            db.setWaitlistAvailableCount(for: date, newSeatCount: waitingSeatsLeft)
        }
    }
}
