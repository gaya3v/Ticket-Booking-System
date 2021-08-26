////
////  TrainTripDetailFetcher.swift
////  Ticket Reservation System
////
////  Created by Gayathri V on 13/08/21.
////
//
//import Foundation
//
//class TrainTripDetailFetcher : InfoFetcherProtocol {
//    
//    var database : Database
//    
//    init(database : Database) {
//        self.database = database
//    }
//    
//    func prepareTripChart(on date : Date) {
//        
//        let seatDetail = database.getSeatDetails()
//        guard let ticketList = seatDetail[date]?.getTicketBookingList() else { return }
//        print("\n\t PNR \t Name \t\t\t\t Source \t\t Destination \t Seat no. ")
//        print("   ------------------------------------------------------------------")
//        
//        for key in ticketList.keys {
//            guard let ticket = ticketList[key] else { return }
//            let passengerList = ticket.getPassengerList()
//            
//            for person in passengerList {
//                if !(person.getSeatStatus() == .cancelled) {
//                    print ("\t\t",ticket.getPnrNumber(), terminator: " ")
//                    print("\t ", person.getPersonName(), terminator: " ")
//                    print("\t\t\t\t", ticket.getStartingPointOfJourney(), terminator: " ")
//                    print("\t\t\t\t", ticket.getDestinationPointOfJourney(), terminator: " ")
//                    if person.getSeatStatus() == .booked {
//                        print("\t\t\t\t", person.getSeatNumber(), terminator: " ")
//                    }
//                    else if person.getSeatStatus() == .waitingList {
//                        print("\t\t\t\t", "WL", terminator: " ")
//                    }
//                    print("\n")
//                }
//            }
//        }
//    }
//    
//    func fetchTrainStatus(for date : Date) {
//        
//        let data = database.getSeatDetails()
//        if let detail = data[date] {
//            print("\n Booked - ", detail.getBookedSeatList())
//            print("\n Open - ",detail.getAvailableSeatList())
//            print("\n Cancelled - ",detail.getCancelledTicketCount())
//            print("\n Waiting List Seats Available - ",detail.getWaitingSeatsAvailable())
//        }
//        else {
//            print("No Bookings done on the given date yet.")
//        }
//    }
//}
