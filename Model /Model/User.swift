//
//  User.swift
//  Ticket Reservation System
//
//  Created by Gayathri V on 09/08/21.
//

import Foundation

class User {
    let id: Int
    let firstName: String
    let lastName: String
    let phoneNumber: Int64
    let email: String
    private let username: String
    private let password: String
    private var ticketBookings : [Int] = []
    
    init (id: Int, firstName: String, lastName: String, phoneNumber: Int64, email: String, username: String, password: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.username = username
        self.password = password
    }
    func getUsername() -> String {
        return username
    }
    func getPassword() -> String {
        return password
    }
    func getUserEmail() -> String {
        return email
    }
    func getTicketBookings() -> [Int] {
        return ticketBookings
    }
    func addTicketToUserBookingList(pnr: Int) {
        ticketBookings.append(pnr)
    }
    func getUserId() -> Int {
        return id
    }
}
