//
//  InputController.swift
//  Ticket Reservation System
//
//  Created by Gayathri V on 09/08/21.
//

import Foundation

class InputController {
    
    let dbData = Database()
    lazy var reservation = Reservation(db: dbData)
    lazy var userInputValidator = Validator(database: dbData)
    lazy var tripInfoFetcher = TrainTripDetailFetcher(database: dbData)
    
    
    func getStringInput() -> String {
        let string = readLine()
        if let input = string {
            return input
        }
        print("Invalid input !")
        return ""
    }
    
    //MARK:- User inputs
    
    func inputPnrNumberFromUser() -> Int {
        print("\n Enter PNR number : ", terminator: " ")
        let string = getStringInput()
        if let num = Int(string) {
            return num
        }
        print("Invalid numerical input !")
        return 0
    }
    
    func inputJourneyDate() -> Date {
        print("\n Enter the date of journey (in YYYY/MM/DD) : ", terminator: " ")
        let string = getStringInput()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if let journeyDate = dateFormatter.date(from: string) { return journeyDate }
        print("Invalid date format ! Try again.")
        return inputJourneyDate()
    }
    
    func inputStationName() -> String {
        print(" Enter station name : ", terminator: " ")
        let string = getStringInput()
        if userInputValidator.isStationNameValid(stationInput: string) { return string }
        print("\n Station does not exist. Try again.")
        return inputStationName()
    }
    
    func inputPassengersCount() -> Int {
        print("\n Enter No. of passengers travelling : ", terminator: " ")
        let string = getStringInput()
        if let memberCount = Int(string) {
            if !(userInputValidator.isPassengerCountWithinLimit(enteredCount: memberCount)) {
                print("\n Booking tickets for more than 3 passengers is not allowed")
                return inputPassengersCount()
            }
            return memberCount
        }
        print("Invalid count of passengers !")
        return inputPassengersCount()
    }
    
    func inputPassengerName() -> String {
        print("Enter the name of travelling person : ", terminator: " ")
        let string = getStringInput()
        return string
    }
    
    func inputPassengerNameList (passengerCount : Int) -> [String]
    {
        var countIndex = 0
        var passengerNameList : [String] = []
        while (countIndex < passengerCount) {
            print("\n Person ", countIndex+1, "name - " , terminator: " ")
            let passenger = inputPassengerName()
            passengerNameList.append(passenger)
            countIndex+=1
        }
        return passengerNameList
    }
    //MARK: Book ticket
    func bookTicket(for user: String) {
        let journeyDate = inputJourneyDate()
        //print(journeyDate)
        print("\nStation List - ")
        for station in dbData.getStationList() { print(station.getStationName(), terminator: " ") }
        //Start point
        print("\n Starting point of journey - ", terminator: " ")
        let startPoint = inputStationName()
        //Destination
        print("\n Destination point of journey - ", terminator: " ")
        let endPoint = inputStationName()
        //check station points
        if startPoint == endPoint { print("\n Start and end points cannot be the same") }
        //continue
        else {
            let memberCount = inputPassengersCount()
            //check if booking can be done
            if  userInputValidator.isBookingAllowed(for: journeyDate, count : memberCount) {
                
                let memberList  = inputPassengerNameList(passengerCount: memberCount)
                
                let ticket = reservation.bookTicket(username: user, travelDate: journeyDate, source: startPoint, dest: endPoint, numOfPassengers: memberCount, nameList: memberList)
                
                //print details
                let dateOfJourney = Utility.dateToString(date: ticket.getDateOfJourney())
                
                print("\n ------- TICKET DETAILS : -------- ")
                print("\n  PNR No. : ",ticket.getPnrNumber(), terminator: " ")
                print("\n  Date : ",dateOfJourney, terminator: " ")
                
                let travelList = ticket.getPassengerList()
                print("\n  Booking status - ")
                
                for member in travelList {
                    print(" \t\(member.getPersonName()) : ", "Seat No. ",member.getSeatNumber(),"\t Status: ", member.getSeatStatus())
                }
                
                print("\n  Source station : ", ticket.getStartingPointOfJourney())
                print("\n  Destination station : ", ticket.getDestinationPointOfJourney())
            }
        }
    }
    
    func trainBookingStatus() {
        let date = inputJourneyDate()
        tripInfoFetcher.fetchTrainStatus(for: date)
    }
    
    func prepareChart() {
        let tripDate = inputJourneyDate()
        if userInputValidator.dataHasEntry(for: tripDate) {
            tripInfoFetcher.prepareTripChart(on: tripDate)
        }
        else {
            print("Chart cannot be prepared. No Bookings done yet.")
        }
        
    }
    //MARK: Cancel ticket
    func cancelTicket(user: String) {
        
        let pnr = inputPnrNumberFromUser()
        let pnrList = dbData.getPnrNumberList()
        
        if  !(pnrList.keys.contains(pnr)) {
            print("PNR does not exist.")
        }
        
        else if !(pnrList[pnr] == user) {
            print("\n Access to ticket denied. Cancellation cannot be done !")
        }
        
        else {
            print(" 1. Cancel entire booking \n 2.Cancel single ticket \n 3. back to menu")
            let str = getStringInput()
            if let choice = Int(str) {
                switch choice {
                
                case 1:
                    print(" --- Cancel all tickets in booking --- ")
                    reservation.cancelTicket(pnrNumber: pnr, of: "")
                    print("\nEntire Ticket with pnr number \(pnr) has been cancelled successfully")
                    
                case 2:
                    print(" --- Cancel individual ticket --- ")
                    let name = inputPassengerName()
                    if !(userInputValidator.checkIfPassengerExists(pnr: pnr, name: name)) {
                        print("\nPassenger does not exist. Cancellation process failed!")
                    }
                    else {
                        reservation.cancelTicket(pnrNumber: pnr, of: name)
                        print("\nTicket with pnr number \(pnr) and name \(name) has been cancelled successfully")
                    }
                    
                case 3:
                    print("back to menu...")
                    
                default:
                    print("Invalid choice.")
                }
            }
            else {
                print("Invalid number input type")
            }
        }
    }
    //MARK: inputs for login
    
    func inputUsername() -> String {
        print(" Enter username : ", terminator: " ")
        let string = getStringInput()
        return string
        //return ""
    }
    
    func inputPassword() -> String {
        print(" Enter password : ", terminator: " ")
        let string = getStringInput()
        if (string.count < 6) {
            print("\n Invalid password.")
            return inputPassword()
        }
        else {
            return string
        }
    }
    
    func inputFirstNameOfUser() -> String {
        print(" First name : ",terminator: " ")
        let fname = getStringInput()
        if fname.isEmpty {
            print("first name cannot be empty")
            return inputFirstNameOfUser()
        }
        return fname
    }
    func inputPhoneNumOfUser() -> Int64 {
        print("\n Phone Number : ",terminator: " ")
        let string = getStringInput()
        if let num = Int64(string) {
            let string = String(num)
            if !(string.count == 10) {
                print("\n Invalid phone number.")
                return inputPhoneNumOfUser()
            }
            else {
                return num
            }
        }
        print("Invalid number input !")
        return -1
    }
    
    func inputEmailOfUser() -> String {
        print("\n Email : ",terminator: " ")
        let email = getStringInput()
        if !(email.contains("@")) && !(email.contains(".")) {
            print("\n Invalid email Id entered. ")
            return inputEmailOfUser()
        }
        else {
            return email
        }
    }
    //MARK: Create new User
    func createUser() -> String {
        print("\n Enter details : - \n")
        //first name
        let firstName = inputFirstNameOfUser()
        //last name
        print("\n Last name : ",terminator: " ")
        let lastName = getStringInput()
        //phone number
        let phoneNum = inputPhoneNumOfUser()
        //email
        let emailId = inputEmailOfUser()
        
        func retryAccountCreation() -> String {
            //username
            print("\n New username : ",terminator: " ")
            let username = inputUsername()
            //check duplicate account and get new password if not
            if !userInputValidator.checkIfUsernameExists(username: username) {
                print("\n New password : ",terminator: " ")
                let password = inputPassword()
                dbData.addNewUserToList(fname: firstName, lastName: lastName, phone: phoneNum, email: emailId, username: username, password: password)
                
                print("\n User account created successfully ! ")
                return username
            }
            // in case of duplication
            else {
                print("\n Account already exists. Try signing in.")
                return retryAccountCreation()
            }
        }
        return retryAccountCreation()
    }
    //MARK: Login
    func login() -> String {
        print("\n --- Login --- \n")
        
        let username = inputUsername()
        
        if userInputValidator.checkIfUsernameExists(username: username) {
            let password = inputPassword()
            
            if userInputValidator.isPasswordValid(for: username, passwordEntered: password) {
                print("\n Login successful ")
            }
            
            else {
                print("Invalid password. Try again")
                _ = login()
            }
        }
        
        else {
            print("Username does not exist.")
            _ = loginService()
        }
        
        return username
    }
    
    func loginService() -> (flag: Bool, user: String) {
        
        print("\n 1. Login \n 2.Create Account \n 3. exit")
        print("\n Please enter login option : ", terminator: " ")
        let str = getStringInput()
        
        if let choice = Int(str) {
            switch choice {
            
            case 1:
                let username = login()
                return (true, username)
                
            case 2 :
                let username = createUser()
                return (true, username)
                
            case 3 :
                exit(0)
                
            default:
                print("Enter correct choice !!")
            }
        }
        
        else {
            print("Enter only number as input \n")
            return loginService()
        }
        return (false, "")
    }
    //MARK: Booking service
    func beginBookingService() {
        var (successfulLoginFlag, currentUser) = loginService()

        while (successfulLoginFlag) {
            print(dbData.getPassengerList())
            print(dbData.getPnrticketDict())
            print(dbData.getTicketSeatDataRegister())
            
            print("\n 1. Book Ticket \n 2. Train Booking Status \n 3. Cancel Ticket \n 4. Display Chart \n 5. Back to login \n 6. Quit")
            print("\n Please enter an option to begin service : ", terminator: " ")
            
            let string = getStringInput()
            
            if let choice = Int(string) {
                switch(choice) {
                
                case 1 :
                    print("\nStarting Ticket booking...")
                    bookTicket(for: currentUser)
                    
                case 2:
                    print("\nFetching Train Booking Status...")
                    trainBookingStatus()
                    
                case 3:
                    print("\nProcessing Ticket Cancellation...")
                    cancelTicket(user: currentUser)
                    
                case 4:
                    print("\nFetching Chart Details...")
                    prepareChart()
                    
                case 5:
                    print("\nRedirecting you to main menu...\n")
                    (successfulLoginFlag, currentUser) = loginService()
                    
                case 6:
                    print("\nThank you for choosing our booking application !! Please visit again!")
                    exit(0)
                    
                default:
                    print("\nEnter correct choice !!")
                }
            }
            //non-numerical inputs
            else {
                print("Enter only number as input \n")
            }
        }
    }
    
}
