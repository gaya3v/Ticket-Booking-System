//
//  enums.swift
//  Ticket Reservation System
//
//  Created by Gayathri V on 09/08/21.
//

import Foundation

//enum Gender {
//    case male
//    case female
//}

enum SeatStatus : String,CaseIterable {
    case open
    case booked
    case waitingList
    case cancelled
    
    var rawValue: String {
        switch self {
        case .open: return "open"
        case .booked: return "booked"
        case .waitingList: return "waitingList"
        case .cancelled: return "cancelled"
        }
    }
}
