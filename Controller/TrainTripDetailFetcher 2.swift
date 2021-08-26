//
//  TrainTripDetailFetcher.swift
//  Ticket Reservation System
//
//  Created by Gayathri V on 13/08/21.
//

import Foundation

class TrainTripDetailFetcher : InfoFetcherProtocol {
    
    var database : Database
    
    init(database : Database) {
        self.database = database
    }
    
    func prepareTripChart(on date : Date) {
        let tickets = database.getPnrticketDict()
        print("\n\t PNR \t Name \t\t\t\t Source \t\t Destination \t Seat no. ")
        print("   ------------------------------------------------------------------")
        
        for key in tickets.keys {
            guard let ticket = tickets[key] else { return }
            if ticket.getDateOfJourney() == date {
                let passengerList = database.getPassengerList()
                
                for person in passengerList {
                    if !(person.status == .cancelled) && person.pnr == ticket.getPnrNumber() {
                        print ("\t\t",person.pnr, terminator: " ")
                        print("\t ", person.name, terminator: " ")
                        print("\t\t\t\t", ticket.getStartingPointOfJourney(), terminator: " ")
                        print("\t\t\t\t", ticket.getDestinationPointOfJourney(), terminator: " ")
                        if person.status == .booked {
                            print("\t\t\t\t", person.seat, terminator: " ")
                        }
                        else if person.status == .waitingList {
                            print("\t\t\t\t", "WL", terminator: " ")
                        }
                        print("\n")
                    }
                }
            }
        }
    }
    
    func fetchTrainStatus(for date : Date) {
        
        if let openData = database.getAvailableSeatRegister()[date], let bookedData = database.getBookedListRegister()[date] {
            let (cc,wla) = database.getCountDetails(for: date)
            print("\n Booked - ",bookedData)
            print("\n Open - ",openData)
            print("\n Cancelled - ",cc)
            print("\n Waiting List Seats Available - ",wla)
        }
        else {
            print("No Bookings done on the given date yet.")
        }
    }
}
