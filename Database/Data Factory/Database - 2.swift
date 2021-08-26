//
//  db.swift
//  Ticket Reservation System
//
//  Created by Gayathri V on 09/08/21.
//

import Foundation

class Database {
    var dataHandler = DataFactory()
    
    init() {
        loadUserData()
        loadStationList()
        loadTrainData()
        loadTicketDataOfUsers()
        mapTicketBookingListData()
        dataHandler.loadTicketSeatData()
        dataHandler.loadAvailableSeatData()
        dataHandler.loadBookedSeatData()
        dataHandler.loadWaitingListData()
        dataHandler.loadTicketData()
    }
    
    private var userList = [User]()
    
    private var pnrNumberList : [Int:String] = [:] // Pnr : username
    
    private var stationList : [Station] = []
    
    private var trainList : [Train] = []
    
    var seatCapacity = 8
    
    var waitlistCapacity = 3
    
    //MARK: load & write login user data
    
    func loadUserData() {
        let fileContent = dataHandler.readFile(file: dataHandler.userDataSourcePath)
        
        var rows = fileContent.components(separatedBy: "\n")
        rows.removeFirst()
        
        for row in rows {
            let columns = row.components(separatedBy: ",")
            if columns.count == 7 {
                let id = Int(columns[0]) ?? 0
                let firstName = columns[1]
                let lastName = columns[2]
                let phoneNumber = Int64(columns[3]) ?? 0
                let email = columns[4]
                let username = columns[5]
                let password = columns[6]
                
                let user = User(id: id, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, username: username, password: password)
                userList.append(user)
            }
        }
    }
    
    func writeNewUserData(id : Int, fname : String, lastName: String, phone: Int64, email: String, username: String, password: String) {
        let filepath = URL(fileURLWithPath: dataHandler.userDataSourcePath)
        
        let existingFileData = dataHandler.readFile(file: dataHandler.userDataSourcePath)
        
        let string = "\n\(String(id)),\(fname),\(lastName),\(String(phone)),\(email),\(username),\(password)"
        let stringToWrite = existingFileData + string
        
        do {
            try stringToWrite.write(to: filepath, atomically: true, encoding: .utf8)
            print("User Data added successfully")
        }
        catch {
            print("Failed to add to file")
            print("\(error)")
        }
    }
    
    //MARK: load & write pnr : username dict list
    
    func loadTicketDataOfUsers() {
        let fileContent = dataHandler.readFile(file: dataHandler.userTicketbookingsDataPath)
        
        var rows = fileContent.components(separatedBy: "\n")
        rows.removeFirst()
        
        for row in rows {
            let columns = row.components(separatedBy: ",")
            if columns.count == 2 {
                let pnr = Int(columns[0]) ?? 0
                let username = columns[1]
                addPnrToList(pnr: pnr, user: username)
            }
        }
    }
    
    func writeNewUserTicketData(pnr : Int, username: String) {
        let filepath = URL(fileURLWithPath: dataHandler.userTicketbookingsDataPath)
        
        let existingFileData = dataHandler.readFile(file: dataHandler.userTicketbookingsDataPath)
        
        let string = "\(String(pnr)),\(username)\n"
        let stringToWrite = existingFileData + string
        
        do {
            try stringToWrite.write(to: filepath, atomically: true, encoding: .utf8)
            print("Username-pnr Data added successfully")
        }
        catch {
            print("Failed to add to file")
            print("\(error)")
        }
    }
    
    //MARK: [pnr : ticket] dict -> ticketbookinglist -> ticketseatdata
    
    func mapTicketBookingListData() {
        dataHandler.loadTicketData()
        
        for ticket in dataHandler.tickets {
            for pnr in pnrNumberList.keys {
                if ticket.getPnrNumber() == pnr {
                    dataHandler.pnrTicketDict[pnr] = ticket
                    break
                }
            }
        }
    }
    
    //MARK: load station list
    
    func loadStationList() {
        let fileContent = dataHandler.readFile(file: dataHandler.stationDataPath)
        var rows = fileContent.components(separatedBy: "\n")
        rows.removeFirst()
        
        for row in rows {
            let columns = row.components(separatedBy: ",")
            if columns.count == 2 {
                let code = Int(columns[0]) ?? 0
                let name = columns[1]
                
                let station = Station(stationName: name, stationCode: code)
                stationList.append(station)
            }
        }
    }
    
    //MARK: train list data
    
    func loadTrainData() {
        let trainData = dataHandler.readFile(file: dataHandler.trainDataSourcePath)
        //var newDataLine = "\(trainList.count+1)"
        
        var rows = trainData.components(separatedBy: "\n")
        rows.removeFirst()
        
        var columns = [String]()
        var schedule = [Station]()
        var trainNum = 0
        for row in rows {
            columns = row.components(separatedBy: ",")
            trainNum = Int(columns[0]) ?? 0
            columns.removeFirst()
        }
        for col in columns {
            for station in stationList {
                if station.stationName == col {
                    schedule.append(station)
                }
            }
        }
        let newTrain = Train(trainNumber: trainNum, trainSchedule: schedule)
        trainList.append(newTrain)
    }
    
    //MARK: Ticket data
    func writeToTicketData(pnr: Int, travelDate: Date, source: String, dest : String, trainno : Int) {
        let filepath = URL(fileURLWithPath: dataHandler.ticketDataPath)
        
        let existingTicketData = dataHandler.readFile(file: dataHandler.ticketDataPath)
        
        //date to str
        let dateStr = Utility.dateToString(date: travelDate)
        let string = "\(String(pnr)),\(dateStr),\(source),\(dest),\(String(trainno))\n"
        let stringToWrite = existingTicketData + string
        
        do {
            try stringToWrite.write(to: filepath, atomically: true, encoding: .utf8)
            print("new Ticket Data added successfully")
        }
        catch {
            print("Failed to add to file")
            print("\(error)")
        }
    }
    
    func writeToBookedPnrList(pnr: Int) {
        let filepath = URL(fileURLWithPath: dataHandler.bookedPnrDataPath)
        let fileContent = dataHandler.readFile(file: dataHandler.bookedPnrDataPath)
        //date to str
        let string = "\(String(pnr))\n"
        let stringToWrite = fileContent + string
        
        do {
            try stringToWrite.write(to: filepath, atomically: true, encoding: .utf8)
            print("Booked pnr Data added successfully")
        }
        catch {
            print("Failed to add to file")
            print("\(error)")
        }
    }
    
    func writeToTicketSeatData(date: Date, availableWaitlist: Int, cancelledSeatCount: Int) {
        let filepath = URL(fileURLWithPath: dataHandler.ticketSeatdataPath)
        let fileContent = dataHandler.readFile(file: dataHandler.ticketSeatdataPath)
        //date to str
        let dateString = Utility.dateToString(date: date)
        let string = "\(dateString),\(availableWaitlist),\(cancelledSeatCount)\n"
        let stringToWrite = fileContent + string
        
        do {
            try stringToWrite.write(to: filepath, atomically: true, encoding: .utf8)
            print("Ticket seat Data added successfully")
        }
        catch {
            print("Failed to add to file")
            print("\(error)")
        }
    }
    
    
    //MARK: getters setters
    
    func getUserList() -> [User] {
        return userList
    }
    
    func getPnrNumberList() -> [Int:String] {
        return pnrNumberList
    }
    
    func addPnrToList(pnr: Int, user: String) {
        pnrNumberList[pnr] = user
        writeNewUserTicketData(pnr: pnr, username: user)
    }
    
    func addTicketToList(pnr: Int, newTicket: Ticket) {
        dataHandler.pnrTicketDict[pnr] = newTicket
        writeToTicketData(pnr: pnr, travelDate: newTicket.getDateOfJourney(), source: newTicket.getStartingPointOfJourney(), dest: newTicket.getDestinationPointOfJourney(), trainno: newTicket.getBookedTrainNumber())
    }
    
    func addNewUserToList(fname : String, lastName: String, phone: Int64, email: String, username: String, password: String) {
        let currId = userList.count+1
        let newUser = User(id: currId, firstName: fname, lastName: lastName, phoneNumber: phone, email: email, username: username, password: password)
        
        writeNewUserData(id: currId, fname: fname, lastName: lastName, phone: phone, email: email, username: username, password: password)
        userList.append(newUser)
    }
    
    func getStationList() -> [Station] {
        return stationList
    }
    
    func getTrainList() -> [Train] {
        return trainList
    }
    
    func getScheduleForTrain(trainNumber: Int) -> [Station] {
        for train in trainList {
            if train.getTrainNumber() == trainNumber {
                return train.getTrainSchedule()
            }
        }
        return []
    }
    
    //Data handler methods
    func initAvailableSeats(for date: Date) {
        if dataHandler.availableSeatRegister[date] == nil {
            dataHandler.availableSeatRegister[date] = Array(stride(from: 8, through: 1, by: -1))
        }
        dataHandler.updateAvailableSeatData()
    }
    
    func initBookedSeats(for date: Date) {
        if dataHandler.bookedlistRegister[date] == nil {
            dataHandler.bookedlistRegister[date] = []
        }
        dataHandler.writeToBookedSeatData()
    }
    
    func initCounters(for date: Date) {
        if dataHandler.ticketSeatDataRegister.isEmpty {
            dataHandler.ticketSeatDataRegister.append(TicketData(date: date, waitlistAvailable: 3, cancellistCount: 0))
        }
        dataHandler.writeToTicketData()
    }
    
    func removeAvailableSeat(on date: Date)
    {
        dataHandler.removeAvailableSeatFromData(on: date)
    }
    
    func addAvailableSeat(on date: Date, num: Int)
    {
        dataHandler.addSeatToAvailableData(on: date, seat: num)
        dataHandler.updateAvailableSeatData()
    }
    
    func addToBookedList(dated dateKey: Date, seatNum : Int)
    {
        dataHandler.modifyBookedSeatData(date: dateKey, newSeat: seatNum)
        dataHandler.writeToBookedSeatData()
    }
    
    func removeSeatFromBookedData(date: Date, seatNumber: Int) {
        dataHandler.removeSeatFromBookedData(date: date, seatNum: seatNumber)
        dataHandler.writeToBookedSeatData()
    }
    
    func removAllSeatFromBookedData(date: Date) {
        dataHandler.removeEntireSeatFromBookingData(date: date)
        dataHandler.writeToBookedSeatData()
    }
    
    func getCountDetails(for date : Date) -> (cc:Int,wla: Int) {
        var cancelCount = 0
        var openWaitListSeatCount = 0
        
        for data in getTicketSeatDataRegister() {
            if data.date == date {
                cancelCount = data.cancellistCount
                openWaitListSeatCount = data.waitlistAvailable
                break
            }
        }
        return (cancelCount,openWaitListSeatCount)
    }
    
    func setCancelCount(for date : Date, newCount: Int) {
        for data in getTicketSeatDataRegister() {
            if data.date == date {
                data.cancellistCount = newCount
                writeToTicketSeatData(date: date, availableWaitlist: data.waitlistAvailable, cancelledSeatCount: data.waitlistAvailable)
                break
            }
        }
        
    }
    
    func setWaitlistAvailableCount(for date : Date, newSeatCount: Int) {
        for data in getTicketSeatDataRegister() {
            if data.date == date {
                data.waitlistAvailable = newSeatCount
                break
            }
        }
    }
    
    func addPassengerInfo(pnr : Int, name: String, seat: Int, status: SeatStatus) {
        dataHandler.addPassenger(pnr: pnr, name: name, seat: seat, status: status)
    }
    
    func cancelPassenger(pnr: Int, name: String, seatStatus :SeatStatus = .cancelled) {
        dataHandler.editPassengerInfo(pnr: pnr, name: name, status: seatStatus)
    }
    func addToWaitList(date: Date, pnr: Int, start: String, end: String) {
        dataHandler.modifyWaitingListData(date: date, pnr: pnr, start: start, end: end)
    }
    func removeFromWaitList(date: Date, pnr: Int) {
        dataHandler.removeSeatFromWaitingListData(date: date, pnr: pnr)
    }
    
    //datahandler getters
    func getPassengerList() -> [BookedPassenger] {
        return dataHandler.passengers
    }
    func getPnrticketDict() ->  [Int: Ticket] {
        return dataHandler.pnrTicketDict
    }
    func getTicketSeatDataRegister() -> [TicketData] {
        return dataHandler.ticketSeatDataRegister
    }
    func getWaitlistRegister() -> [WaitListRegister] {
        return dataHandler.waitlistRegister
    }
    func getBookedListRegister() -> [Date: [Int]] {
        return dataHandler.bookedlistRegister
    }
    func getAvailableSeatRegister() -> [Date: [Int]] {
        return dataHandler.availableSeatRegister
    }
    func setSeatNumberAndStatus(newSeat: Int,status : SeatStatus, passenger: String, pnr: Int) {
        for person in dataHandler.passengers {
            if person.name==passenger && person.pnr==pnr {
                person.seat = newSeat
                person.status = status
            }
        }
    }
    
}
