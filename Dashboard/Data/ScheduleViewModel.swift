//
//  ScheduleViewModel.swift
//  Dashboard
//
//  Created by Spencer Hartland on 11/10/22.
//

import Foundation
import SwiftUI

enum Zone: String, Codable {
    case runner = "Runner"
    case op = "Operator"
    case invOps = "Inventory Operations"
    case other = "Other"
    case mealBreak = "Meal Break"
    case restBreak = "Rest Break"
}

struct Employee: Codable {
    let name: String
    let role: String
    let imageNameInBundle: String
    let schedule: [ScheduleChunk]
    
    struct ScheduleChunk: Codable {
        let zone: String
        let startTime: Date
        let endTime: Date
    }
}

class ScheduleViewModel {
    private let mockTime = try! Date("2022-11-11T10:00:00-0800", strategy: .iso8601)
    private static let jsonFileName = "Schedule"
    private static let jsonExtension = "json"
    let employees: [Employee]
    var runner = [Employee]()
    var invOps = [Employee]()
    var op = [Employee]()
    var other = [Employee]()
    var mealBreak = [Employee]()
    var restBreak = [Employee]()
    
    init() {
        self.employees = ScheduleViewModel.decodeSchedule()
        sortEmployees()
    }
    
    private static func decodeSchedule() -> [Employee] {
        var employees = [Employee]()
        
        if let fileURL = Bundle.main.url(forResource: jsonFileName, withExtension: jsonExtension) {
            do {
                let scheduleData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let employeeList = try decoder.decode([Employee].self, from: scheduleData)
                employees = employeeList
            } catch {
                print(error)
            }
        }
        
        return employees
    }
    
    private func sortEmployees() {
        let currentTime = mockTime
        for employee in employees {
            for chunk in employee.schedule {
                if currentTime >= chunk.startTime && currentTime <= chunk.endTime {
                    // This is the active chunk
                    if chunk.zone.contains(Zone.runner.rawValue) {
                        self.runner.append(employee)
                        continue
                    } else if chunk.zone.contains(Zone.invOps.rawValue) {
                        self.invOps.append(employee)
                        continue
                    } else if chunk.zone.contains(Zone.op.rawValue) {
                        self.op.append(employee)
                        continue
                    } else if chunk.zone.contains(Zone.mealBreak.rawValue) {
                        self.mealBreak.append(employee)
                        continue
                    } else if chunk.zone.contains(Zone.restBreak.rawValue) {
                        self.restBreak.append(employee)
                        continue
                    } else {
                        self.other.append(employee)
                        continue
                    }
                }
            }
        }
    }
}
