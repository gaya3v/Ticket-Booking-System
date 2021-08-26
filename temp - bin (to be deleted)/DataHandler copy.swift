////
////  swift
////  csv data handler
////
////  Created by Gayathri V on 17/08/21.
////
//
//import Foundation
//
//
//class BookedPassenger {
//    var pnr : Int
//    var name : String
//    var seat : Int
//    var status : SeatStatus
//    
//    init(pnr : Int, name : String, seat : Int, status : SeatStatus) {
//        self.pnr = pnr
//        self.name = name
//        self.seat = seat
//        self.status = status
//    }
//}
//
//class WaitListRegister {
//    var pnr : Int
//    var date : Date
//    var start : String
//    var end : String
//    
//    init(date : Date, pnr : Int, start : String, end : String) {
//        self.date = date
//        self.pnr = pnr
//        self.start = start
//        self.end = end
//    }
//}
//
//class TicketData {
//    let date: Date
//    var waitlistAvailable: Int
//    var cancellistCount: Int
//    init(date: Date, waitlistAvailable: Int, cancellistCount: Int) {
//        self.date = date
//        self.waitlistAvailable = waitlistAvailable
//        self.cancellistCount = cancellistCount
//    }
//}
//
//class DataFactory {
//    var userDataSourcePath = "/Users/gayathri-pt3774/iOS - Swift/Ticket Reservation System/Database/userdata.csv"
//    var stationDataPath = "/Users/gayathri-pt3774/iOS - Swift/Ticket Reservation System/Database/stationData.csv"
//    var userTicketbookingsDataPath = "/Users/gayathri-pt3774/iOS - Swift/Ticket Reservation System/Database/userticketbookings.csv"
//    var trainDataSourcePath = "/Users/gayathri-pt3774/iOS - Swift/Ticket Reservation System/Database/trainSchedule.csv"
//    
//    var ticketDataPath = "/Users/gayathri-pt3774/iOS - Swift/Ticket Reservation System/Database/ticketData.csv"
//    var passengerDataPath = "/Users/gayathri-pt3774/iOS - Swift/Ticket Reservation System/Database/passengers.csv"
//    var bookedPnrDataPath = "/Users/gayathri-pt3774/iOS - Swift/Ticket Reservation System/Database/pnr-bookedticket.csv"
//    
//    var waitinglistDataPath = "/Users/gayathri-pt3774/iOS - Swift/Ticket Reservation System/Database/waitinglist.csv"
//    var bookedTicketsDataPath = "/Users/gayathri-pt3774/iOS - Swift/Ticket Reservation System/Database/bookedticketList.csv"
//    var ticketSeatdataPath = "/Users/gayathri-pt3774/iOS - Swift/Ticket Reservation System/Database/ticketSeatData.csv"
//    var availableSeatdataPath = "/Users/gayathri-pt3774/iOS - Swift/Ticket Reservation System/Database/availableSeatList.csv"
//    
//    var passengers : [BookedPassenger] = []
//    var tickets : [Ticket] = []
//    var pnrTicketDict : [Int: Ticket] = [:]
//    
//    var ticketSeatDataRegister: [TicketData] = []
//    var waitlistRegister : [WaitListRegister] = [] //date: Array of dict [Pnr: (start,end)]
//    var bookedlistRegister = [Date: [Int]]() //date: array of booked seat nos
//    var availableSeatRegister = [Date: [Int]]() //date: array of booked seat nos
//   
//    
//    init() {
//        loadTicketSeatData()
//        loadBookedSeatData()
//    }
//    
//    func readFile(file : String) -> String {
//      
//        var data = ""
//        do {
//            data = try String(contentsOfFile: file)
//            return data
//        }
//        catch {
//            return error.localizedDescription
//        }
//    }
//    
//    func loadPassengerData() {
//        let passengerData = readFile(file: passengerDataPath)
//        var rows = passengerData.components(separatedBy: "\n")
//        rows.removeFirst()
//        
//        for row in rows {
//            let columns = row.components(separatedBy: ",")
//            if columns.count == 4 {
//                let pnr = Int(columns[0]) ?? 0
//                let name = columns[1]
//                let seat = Int(columns[2]) ?? 0
//                let status = columns[3]
//                
//                let newMember = BookedPassenger(pnr: pnr, name: name, seat: seat, status: SeatStatus(rawValue: status)!)
//                passengers.append(newMember)
//            }
//        }
//    }
//    
//    func addPassenger(pnr : Int, name: String, seat: Int, status: SeatStatus) {
//        let newPassenger = BookedPassenger(pnr: pnr, name: name, seat: seat, status: status)
//        passengers.append(newPassenger)
//        writeToPassengerData()
//    }
//    //MARK: passenger list in Ticket - update
//    func writeToPassengerData() {
//        let filepath = URL(fileURLWithPath: passengerDataPath)
//        
//        var string = "pnr,name,seat,status\n"
//        
//        for passenger in passengers {
//            string += "\(String(passenger.pnr)),\(passenger.name),\(passenger.seat),\(passenger.status.rawValue)\n"
//        }
//        
//        do {
//            try string.write(to: filepath, atomically: true, encoding: .utf8)
//            print("Passenger Data added successfully")
//        }
//        catch {
//            print("Failed to add to file")
//            print("\(error)")
//        }
//    }
//    
//    func editPassengerInfo(pnr: Int, name: String) {
//        for passenger in passengers {
//            if passenger.pnr == pnr && passenger.name == name {
//                passenger.status = .cancelled
//                break
//            }
//        }
//        writeToPassengerData()
//    }
//    //MARK: load ticket data
//    
//    func loadTicketData() {
//        loadPassengerData()
//        
//        let ticketData = readFile(file: ticketDataPath)
//        
//        var rows = ticketData.components(separatedBy: "\n")
//        rows.removeFirst()
//        
//        for row in rows {
//            let columns = row.components(separatedBy: ",")
//            if columns.count == 7 {
//                let pnr = Int(columns[0]) ?? 0
//                let dateStr = columns[1]
//                let start = columns[2]
//                let dest = columns[3]
//                let membersCount = Int(columns[4]) ?? 0
//                let memberList : [String] = columns[5].components(separatedBy: " ")
//                let train = Int(columns[6]) ?? 0
//                
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy/MM/dd"
//                let journeyDate = dateFormatter.date(from: dateStr)
//                
//                var passengerArray = [Passenger]()
//                
//                for person in memberList {
//                    for passenger in passengers {
//                        if passenger.name == person && passenger.pnr == pnr {
//                            passengerArray.append(Passenger(name: person, seatStatus: passenger.status, seatNumber: passenger.seat))
//                        }
//                    }
//                }
//                
//                let newTicket = Ticket(pnrNumber: pnr, journeyDate: journeyDate!, startPoint: start, destinationPoint: dest, numberOfPassengers: membersCount, passengers: passengerArray, trainNumber: train)
//                tickets.append(newTicket)
//            }
//        }
//    }
//    
//    //pnr for key values
//    
//    //    func loadBookedPnrList() {
//    //        let fileContent = readFile(file: bookedPnrDataPath)
//    //        var rows = fileContent.components(separatedBy: "\n")
//    //        rows.removeFirst()
//    //
//    //        for row in rows {
//    //            bookedPnrNumbers.append(Int(row) ?? 0)
//    //        }
//    //    }
//    
//    
//    //MARK: [pnr : (start,end)] dict -> waitinglist -> ticketseatdata
//    
//    func loadWaitingListData() {
//        let fileContent = readFile(file: waitinglistDataPath)
//        var rows = fileContent.components(separatedBy: "\n")
//        rows.removeFirst()
//        
//        for row in rows {
//            let columns = row.components(separatedBy: ",")
//            if columns.count == 3 {
//                let date = columns[0]
//                let pnr = Int(columns[1]) ?? 0
//                let startPoint = columns[2]
//                let endPoint = columns[3]
//                
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy/MM/dd"
//                let entryDate = Utility.stringToDate(string: date)
//                
//                let waitlistEntry = WaitListRegister(date: entryDate, pnr: pnr, start: startPoint, end: endPoint)
//                waitlistRegister.append(waitlistEntry)
//            }
//        }
//    }
//    
//    func modifyWaitingListData(date: Date, pnr: Int, start: String, end: String) {
//        let waitlistEntry = WaitListRegister(date: date, pnr: pnr, start: start, end: end)
//        waitlistRegister.append(waitlistEntry)
//        writeToWaitingListData()
//    }
//    
//    func writeToWaitingListData() {
//        let filepath = URL(fileURLWithPath: waitinglistDataPath)
//        
//        var string = "date,pnr,start,end\n"
//        
//        for data in waitlistRegister {
//            let entryDate = Utility.dateToString(date: data.date)
//            string += "\(entryDate),\(String(data.pnr)),\(data.start),\(data.end)\n"
//        }
//        
//        do {
//            try string.write(to: filepath, atomically: true, encoding: .utf8)
//            print("wait list Data added successfully")
//        }
//        catch {
//            print("Failed to add to file")
//            print("\(error)")
//        }
//    }
//    
//    func removeSeatFromWaitingListData(date: Date, pnr: Int) {
//        for i in 0..<waitlistRegister.count {
//            if waitlistRegister[i].date == date && waitlistRegister[i].pnr == pnr {
//                waitlistRegister.remove(at: i)
//                break
//            }
//        }
//        writeToBookedSeatData()
//        print("Removed row ",pnr)
//    }
//    
//    //MARK: booked seat list -> bookedlist -> ticketseatdata
//    
//    func loadBookedSeatData() {
//        let fileContent = readFile(file: bookedTicketsDataPath)
//        let rows = fileContent.components(separatedBy: "\n")
//        //rows.removeFirst()
//        
//        for row in rows {
//            let columns = row.components(separatedBy: ",")
//            if columns.count == 2 {
//                let date = columns[0]
//                let entryDate = Utility.stringToDate(string: date)
//                
//                let seatArr = columns[1].components(separatedBy: " ")
//                let bookedSeatsArray = seatArr.map { Int($0) ?? 0 }
//                
//                if bookedlistRegister[entryDate] == nil {
//                    bookedlistRegister[entryDate] = []
//                }
//                bookedlistRegister[entryDate] = bookedSeatsArray
//            }
//        }
//    }
//    
//    func modifyBookedSeatData(date: Date, newSeat: Int) {
//        if bookedlistRegister[date] != nil {
//            bookedlistRegister[date]!.append(newSeat)
//        }
//        else {
//            bookedlistRegister[date] = []
//            bookedlistRegister[date]?.append(newSeat)
//        }
//        writeToBookedSeatData()
//    }
//    
//    func writeToBookedSeatData() {
//        let filepath = URL(fileURLWithPath: bookedTicketsDataPath)
//        //let fileContent = readFile(file: bookedTicketsDataPath)
//        //date to str
//        var string = ""
//        for key in bookedlistRegister.keys {
//            let strDate = Utility.dateToString(date: key)
//            let seatValues = Utility.arrayToSpacedString(array: bookedlistRegister[key]!)
//            if bookedlistRegister[key] != nil {
//                string += "\(strDate),\(seatValues)\n"
//            }
//            else {
//                string+="\n"
//            }
//        }
//        do {
//            try string.write(to: filepath, atomically: false, encoding: .utf8)
//            print("Booked seat Data added successfully")
//        }
//        catch {
//            print("Failed to add data to file")
//            print("\(error)")
//        }
//    }
//    
//    func removeSeatFromBookedData(date: Date, seatNum: Int) {
//        if let bookingList = bookedlistRegister[date], let index = bookingList.firstIndex(of: seatNum) {
//            bookedlistRegister[date]!.remove(at: index)
//        }
//        writeToBookedSeatData()
//        print("Removed seat ",seatNum)
//    }
//    
//    func removeEntireSeatFromBookingData(date: Date) {
//        if bookedlistRegister[date] != nil {
//            bookedlistRegister[date] = nil
//        }
//        writeToBookedSeatData()
//        print("Removed seats ")
//    }
//    
//    //MARK: available seat list -> availableseats -> ticketseatdata
//    
//    func initEntrySeats(for date: Date) {
//        if availableSeatRegister[date] == nil {
//            availableSeatRegister[date] = Array(stride(from: 8, through: 1, by: -1))
//        }
//        updateAvailableSeatData()
//    }
//    
//    func loadAvailableSeatData() {
//        let fileContent = readFile(file: availableSeatdataPath)
//        let rows = fileContent.components(separatedBy: "\n")
//        //rows.removeFirst()
//        
//        for row in rows {
//            let columns = row.components(separatedBy: ",")
//            if columns.count == 2 {
//                let date = columns[0]
//                let entryDate = Utility.stringToDate(string: date)
//                
//                let seatArr = columns[1].components(separatedBy: " ")
//                let availableSeats = seatArr.map { Int($0)! }
//                
//                if availableSeatRegister[entryDate] == nil {
//                    availableSeatRegister[entryDate] = []
//                }
//                availableSeatRegister[entryDate] = availableSeats
//            }
//        }
//    }
//    
//    func updateAvailableSeatData() {
//            let filepath = URL(fileURLWithPath: availableSeatdataPath)
//            //let fileContent = readFile(file: bookedTicketsDataPath)
//            //date to str
//            var string = ""
//            for key in availableSeatRegister.keys {
//                let strDate = Utility.dateToString(date: key)
//                let seatValues = Utility.arrayToSpacedString(array: availableSeatRegister[key]!)
//                if availableSeatRegister[key] != nil {
//                    string += "\(strDate),\(seatValues)\n"
//                }
//                else {
//                    string+="\n"
//                }
//            }
//            do {
//                try string.write(to: filepath, atomically: false, encoding: .utf8)
//                print("Available seat Data updated successfully")
//            }
//            catch {
//                print("Failed to add available data to file")
//                print("\(error)")
//            }
//        }
//    
//    func removeAvailableSeatFromData(on date: Date) {
//        availableSeatRegister[date]?.removeLast()
//        updateAvailableSeatData()
//    }
//    
//    func addSeatToAvailableData(on date: Date, seat: Int) {
//        availableSeatRegister[date]?.append(seat)
//        updateAvailableSeatData()
//    }
//    //MARK: ticket seat data
//    
//    func loadTicketSeatData() {
//        let fileContent = readFile(file: ticketSeatdataPath)
//        var rows = fileContent.components(separatedBy: "\n")
//        rows.removeFirst()
//        
//        for row in rows {
//            let columns = row.components(separatedBy: ",")
//            if columns.count == 3 {
//                let date = Utility.stringToDate(string: columns[0])
//                let wlAvailable = Int(columns[1]) ?? 0
//                let cancelCount = Int(columns[2]) ?? 0
//                let newData = TicketData(date: date, waitlistAvailable: wlAvailable, cancellistCount: cancelCount)
//                ticketSeatDataRegister.append(newData)
//            }
//        }
//    }
//    func initTicketData(for date: Date) {
//        let newEntry = TicketData(date: date, waitlistAvailable: 3, cancellistCount: 0)
//        ticketSeatDataRegister.append(newEntry)
//    }
//    func addCancelCount(for date: Date) {
//        for entry in ticketSeatDataRegister {
//            if entry.date == date {
//                entry.cancellistCount += 1
//                break
//            }
//        }
//        writeToTicketData()
//    }
//    func decrementWaitlistAvailableCount(for date: Date) {
//        for entry in ticketSeatDataRegister {
//            if entry.date == date {
//                entry.waitlistAvailable -= 1
//                break
//            }
//        }
//        writeToTicketData()
//    }
//    func incrementWaitlistAvailableCount(for date: Date) {
//        for entry in ticketSeatDataRegister {
//            if entry.date == date {
//                entry.waitlistAvailable += 1
//                break
//            }
//        }
//        writeToTicketData()
//    }
//    func writeToTicketData() {
//        let filepath = URL(fileURLWithPath: ticketSeatdataPath)
//        
//        var string = "date,waitingSeatsAvailable,cancelledSeatListCount\n"
//        
//        for data in ticketSeatDataRegister {
//            let entryDate = Utility.dateToString(date: data.date)
//            string += "\(entryDate),\(String(data.waitlistAvailable)),\(String(data.cancellistCount))\n"
//        }
//        
//        do {
//            try string.write(to: filepath, atomically: true, encoding: .utf8)
//            print("ticket seat Data added successfully")
//        }
//        catch {
//            print("Failed to add to file")
//            print("\(error)")
//        }
//    }
//}
