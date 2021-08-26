////
////  ReservationController.swift
////  Ticket Reservation System
////
////  Created by Gayathri V on 09/08/21.
////
//
//import Foundation
//
//class Reservation : BookingProtocol {
//    
//    var db : Database
//    
//    init(db : Database) {
//        self.db = db
//    }
//    
//    func getPassengerSeat(pnr: Int, for date : Date, startPoint : String, endPoint: String) -> (status : SeatStatus, seatNum : Int) {
//        
//        var passengerSeatStatus : SeatStatus = .open
//        var seat = -1
//        let seatData = db.getSeatDetails()
//        
//        if let detail = seatData[date] {
//            let availableSeatList = detail.getAvailableSeatList()
//            // print(availableSeatList)
//            let bookedSeatList = detail.getBookedSeatList()
//            //
//            let availableSeatsForWaitList = detail.getWaitingSeatsAvailable()
//            // print(availableSeatsForWaitList)
//            let totalSeatCapacity = detail.getTotalCapacity()
//            
//            seat = !availableSeatList.isEmpty ? availableSeatList[availableSeatList.endIndex-1] : 0
//            
//            if !(availableSeatList.isEmpty) && bookedSeatList.count < totalSeatCapacity {
//                detail.addSeatToBookedList(seatNumber: seat)
//                db.addToBookedList(dated: date, seatNum: seat)
//                
//                detail.removeSeatFromAvailableList(seatNumber: seat)
//                db.removeAvailableSeat(on: date)
//                passengerSeatStatus = .booked
//            }
//            
//            else if availableSeatList.isEmpty && bookedSeatList.count == totalSeatCapacity && !(availableSeatsForWaitList == 0) {
//                seat = 0
//                detail.addTravelInfoOfSeatToWaitList(pnr: pnr, start: startPoint, end: endPoint)
//                db.addToWaitList(date: date, pnr: pnr, start: startPoint, end: endPoint)
//                
//                detail.removeFromWaitingSeatsAvailable()
//                db.decrementWaitlistAvailableCount(for: date)
//                
//                passengerSeatStatus = .waitingList
//            }
//            
//            else {
//                // detail.addToCancelledListCount()
//                passengerSeatStatus = .cancelled
//            }
//        }
//        
//        return (passengerSeatStatus,seat)
//    }
//    
//    func updateTicketList(newTicket : Ticket, for username : String) {
//        let date = newTicket.getDateOfJourney()
//        let seatData = db.getSeatDetails()
//        if let detail = seatData[date]
//        {
//            let newPnr = newTicket.getPnrNumber()
//            detail.addNewTicketBooking(pnrKey: newPnr, newBooking: newTicket)
//            db.writeToTicketData(pnr: newPnr, travelDate: date, source: newTicket.startPoint, dest: newTicket.destinationPoint, trainno: newTicket.trainNumber)
//            db.addPnrToList(pnr: newPnr, user: username)
//        }
//    }
//    
//    func getValidatedPnrNumber(for user: String) -> Int {
//        let utility = Utility()
//        let randomNumber = utility.generateRandomNumber(startRange: 1, endRange: 20)
//        let list = db.getPnrNumberList()
//        if list.keys.contains(randomNumber) {
//            return getValidatedPnrNumber(for: user)
//        }
//        else {
//            // db.addPnrToList(pnr: randomNumber, user: user)
//            return randomNumber
//        }
//    }
//    
//    func bookTicket (username: String, travelDate: Date, source: String, dest : String, numOfPassengers: Int, nameList: [String]) -> Ticket {
//        
//        let pnr = getValidatedPnrNumber(for: username)
//        
//        var passengerArray : [Passenger] = []
//
//        for name in nameList {
//            let (status,seat) = getPassengerSeat(pnr : pnr,for: travelDate, startPoint: source,endPoint: dest)
//            let newMember = Passenger(name: name, seatStatus: status, seatNumber: seat)
//            if seat > 0 {
//            passengerArray.append(newMember)
//            db.addPassengerInfo(pnr: pnr, name: name, seat: seat, status: status)
//            }
//        }
//        //print(travelDate)
//        let newBooking = Ticket(pnrNumber: pnr, journeyDate: travelDate, startPoint: source, destinationPoint: dest, numberOfPassengers: numOfPassengers, passengers: passengerArray, trainNumber: 1)
//        updateTicketList(newTicket: newBooking, for: username)
//        return newBooking
//    }
//    //MARK: cancel operation methods
// 
//    func getJourneyDistance(trainNumber : Int = 1, startPlace: String, endPlace : String) -> Int {
//        let route = db.getScheduleForTrain(trainNumber: trainNumber)
//        var point1 = 0
//        var point2 = 0
//        for index in 0..<route.endIndex {
//            if route[index].getStationName() == startPlace {
//                point1 = index
//            }
//            if route[index].getStationName() == endPlace {
//                point2 = index
//            }
//        }
//        return abs(point1-point2)
//    }
//    
//    func cancelTicket(pnrNumber : Int, of passengerName : String) {
//        
//        let seatData = db.getSeatDetails()
//        for dataValue in seatData.values {
//            let ticketBookings = dataValue.getTicketBookingList()
//            if let ticket = ticketBookings[pnrNumber] {
//                let people = ticket.getPassengerList()
//                if !(passengerName.isEmpty) {
//                    cancelIndividualTicket(from: people, passengerName: passengerName, in: dataValue, ticket: ticket)
//                }
//                else {
//                    cancelEntireBooking(from: people, in: dataValue, ticket: ticket)
//                }
//            }
//        }
//    }
//    
//    func cancelIndividualTicket(from people : [Passenger], passengerName: String, in data: TicketSeatData, ticket : Ticket) {
//        
//        for person in people {
//            let name = person.getPersonName()
//            let seat = person.getSeatNumber()
//            if name == passengerName {
//                person.setSeatStatus(status: .cancelled)
//                db.cancelPassenger(pnr: ticket.getPnrNumber(), name: name)
//                
//                data.removeSeatFromBookedList(seatNumber: seat)
//                db.removeSeatFromBookedData(date: data.getDate(), seatNumber: seat)
//                
//                updateSeatNumber(of: data, newValueOfSeat: seat, in: ticket)
//                data.addToCancelledListCount()
//                db.addCancelCount(for: ticket.getDateOfJourney())
//                break
//            }
//        }
//        
//    }
//    func cancelEntireBooking(from people : [Passenger], in data: TicketSeatData, ticket : Ticket) {
//        
//        for person in people {
//            let name = person.getPersonName()
//            let seat = person.getSeatNumber()
//            person.setSeatStatus(status: .cancelled)
//            db.cancelPassenger(pnr: ticket.getPnrNumber(), name: name)
//            
//            data.removeSeatFromBookedList(seatNumber: seat)
//            db.removeSeatFromBookedData(date: data.getDate(), seatNumber: seat)
//            
//            updateSeatNumber(of: data, newValueOfSeat: seat, in: ticket)
//            data.addToCancelledListCount()
//            db.addCancelCount(for: ticket.getDateOfJourney())
//        }
//    }
//    
//    func getLongestJourneyInWaitList(in data : TicketSeatData) -> Int {
//        
//        var distance = Int.min
//        var val = 0
//        let stationInfoOfWL = data.getWaitingList()
//        
//        for key in stationInfoOfWL.keys {
//            if let (beginPoint,endPoint) = stationInfoOfWL[key] {
//                let travelLength = getJourneyDistance(startPlace: beginPoint, endPlace: endPoint)
//                if travelLength > distance {
//                    distance = travelLength
//                    val = key
//                }
//            }
//        }
//        return val
//    }
//    
//    func updateSeatNumber(of dataEntry: TicketSeatData, newValueOfSeat : Int, in ticket : Ticket) {
//        
//        if dataEntry.getWaitingSeatsAvailable() == dataEntry.getWaitlistCapacity() && newValueOfSeat > 0 { //if no WL -> booked is there
//            dataEntry.addSeatToAvailableList(seatNumber: newValueOfSeat)
//            db.addAvailableSeat(on: dataEntry.getDate(), num: newValueOfSeat)
//        }
//        
//        else { // WL -> Booked, update booked
//            let val = getLongestJourneyInWaitList(in: dataEntry)
//            dataEntry.removeSeatInfoFromWaitList(key: val)
//            db.removeFromWaitList(date: dataEntry.getDate(), pnr: ticket.getPnrNumber())
//            
//            for passenger in ticket.getPassengerList() {
//                if passenger.getSeatStatus() == .waitingList {
//                    passenger.setSeatNumber(num: newValueOfSeat)
//                    passenger.seatStatus = .booked
//                    break
//                }
//            }
//            dataEntry.addSeatToBookedList(seatNumber: newValueOfSeat)
//            db.addToBookedList(dated: dataEntry.getDate(), seatNum: newValueOfSeat)
//            dataEntry.addToWaitingSeatsAvailable()
//            db.incrementWaitlistAvailableCount(for: ticket.getDateOfJourney())
//        }
//    }
//}
