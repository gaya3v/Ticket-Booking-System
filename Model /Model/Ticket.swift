//
//  Ticket.swift
//  Ticket Reservation System
//
//  Created by Gayathri V on 09/08/21.
//

import Foundation

class Ticket {
    
    private var pnrNumber: Int
    var journeyDate: Date
    var startPoint: String
    var destinationPoint: String
    var numberOfPassengers: Int
    private var passengers: [Passenger]
    var trainNumber: Int
    
    init(pnrNumber: Int, journeyDate: Date, startPoint: String, destinationPoint: String, numberOfPassengers: Int, passengers: [Passenger], trainNumber: Int) {
        self.pnrNumber = pnrNumber
        self.journeyDate = journeyDate
        self.startPoint = startPoint
        self.destinationPoint = destinationPoint
        self.numberOfPassengers = numberOfPassengers
        self.passengers = passengers
        self.trainNumber = trainNumber
    }
    
    func getPnrNumber() -> Int {
        return pnrNumber
    }
    
    func getPassengerList () -> [Passenger] {
        return passengers
    }
    
    func addPassengerListInBooking(passengersList: [Passenger]) {
        passengers = passengersList
    }
    
    func getDateOfJourney() -> Date {
        return journeyDate
    }

    func getStartingPointOfJourney() -> String {
        return startPoint
    }
    
    func getDestinationPointOfJourney() -> String {
        return destinationPoint
    }
    
    func getBookedTrainNumber() -> Int {
        return trainNumber
    }

    func removePassengerFromList(personAt index : Int) {
        passengers.remove(at: index)
    }
    
}


