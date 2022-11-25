//
//  ScheduleView.swift
//  Dashboard
//
//  Created by Spencer Hartland on 11/10/22.
//

import SwiftUI

struct ScheduleView: View {
    private let mockTime = try! Date("2022-11-11T10:00:00-0800", strategy: .iso8601)
    // SFSymbol names
    private let noDataSymbolName = "x.circle.fill"
    private let runnerSymbolName = "figure.run.circle.fill"
    private let operatorSymbolName = "phone.circle.fill"
    private let invOpsSymbolName = "shippingbox.circle.fill"
    private let otherSymbolName = "ellipsis.circle.fill"
    // Text values
    private let scheduleViewTitle = "Schedule"
    private let noDataText = "No schedule data available"
    private let noDataFooter = "Unable to get schedule data. Check the internet connection and try again."
    // View model
    @State var viewModel = ScheduleViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            // View title
            Text(scheduleViewTitle)
                .font(.system(size: 64, weight: .semibold))
                .padding(.bottom, 8)
            
            if viewModel.employees.isEmpty {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: noDataSymbolName)
                        Text(noDataText)
                    }
                    .font(.system(size: 48, weight: .semibold))
                    Text(noDataFooter)
                        .font(.system(size: 24))
                }
            } else {
                VStack(alignment: .leading, spacing: 16) {
                    // Runner section
                    ZoneListView(symbol: runnerSymbolName, title: Zone.runner.rawValue) {
                        if !viewModel.runner.isEmpty {
                            ForEach(viewModel.runner, id: \.name) { employee in
                                ForEach(employee.schedule, id: \.startTime) { chunk in
                                    if mockTime >= chunk.startTime && mockTime <= chunk.endTime {
                                        EmployeeView(employeeImage: Image(employee.imageNameInBundle), employeeZone: Zone.runner.rawValue, employeeName: employee.name, employeeRole: employee.role, inCurrentZoneUntil: chunk.endTime)
                                    }
                                }
                            }
                        } else {
                            
                        }
                    }
                    // Inv ops section
                    ZoneListView(symbol: invOpsSymbolName, title: Zone.invOps.rawValue) {
                        if !viewModel.invOps.isEmpty {
                            ForEach(viewModel.invOps, id: \.name) { employee in
                                ForEach(employee.schedule, id: \.startTime) { chunk in
                                    if mockTime >= chunk.startTime && mockTime <= chunk.endTime {
                                        EmployeeView(employeeImage: Image(employee.imageNameInBundle), employeeZone: Zone.invOps.rawValue, employeeName: employee.name, employeeRole: employee.role, inCurrentZoneUntil: chunk.endTime)
                                    }
                                }
                            }
                        } else {
                            
                        }
                    }
                    // Operator section
                    ZoneListView(symbol: operatorSymbolName, title: Zone.op.rawValue) {
                        if !viewModel.op.isEmpty {
                            ForEach(viewModel.op, id: \.name) { employee in
                                ForEach(employee.schedule, id: \.startTime) { chunk in
                                    if mockTime >= chunk.startTime && mockTime <= chunk.endTime {
                                        EmployeeView(employeeImage: Image(employee.imageNameInBundle), employeeZone: Zone.op.rawValue, employeeName: employee.name, employeeRole: employee.role, inCurrentZoneUntil: chunk.endTime)
                                    }
                                }
                            }
                        } else {
                            
                        }
                    }
                    // Other section
                    ZoneListView(symbol: otherSymbolName, title: Zone.other.rawValue) {
                        if !viewModel.other.isEmpty {
                            ForEach(viewModel.other, id: \.name) { employee in
                                ForEach(employee.schedule, id: \.startTime) { chunk in
                                    if mockTime >= chunk.startTime && mockTime <= chunk.endTime {
                                        EmployeeView(employeeImage: Image(employee.imageNameInBundle), employeeZone: chunk.zone, employeeName: employee.name, employeeRole: employee.role, inCurrentZoneUntil: chunk.endTime)
                                    }
                                }
                            }
                        } else {
                            
                        }
                    }
                    // Rest Break
                    HStack(spacing: 32) {
                        ZonedBreakView(employeesZonedForBreak: viewModel.restBreak, isMealBreak: false)
                        ZonedBreakView(employeesZonedForBreak: viewModel.mealBreak, isMealBreak: true)
                    }
                }
            }
        }
    }
}

struct ZoneListView<Content: View>: View {
    var symbol: String
    var title: String
    var content: () -> Content
    
    init(symbol: String, title: String, @ViewBuilder content: @escaping () -> Content) {
        self.symbol = symbol
        self.title = title
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: self.symbol)
                Text(self.title)
            }
            .font(.system(size: 32, weight: .semibold))
            content()
        }
    }
}

struct ZonedBreakView: View {
    let employees: [Employee]
    let symbol: String
    let title: String
    
    init(employeesZonedForBreak: [Employee], isMealBreak: Bool) {
        self.employees = employeesZonedForBreak
        if isMealBreak {
            symbol = "fork.knife.circle.fill"
            title = "Meal Break"
        } else {
            symbol = "timer.circle.fill"
            title = "Rest Break"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: symbol)
                Text(title)
            }
            .font(.system(size: 32, weight: .semibold))
            HStack(spacing: -8) {
                ForEach(employees, id: \.name) { employee in
                    Image(employee.imageNameInBundle)
                        .resizable()
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        }
                        .shadow(radius: 0.4)
                }
            }
        }
    }
}

struct EmployeeView: View {
    // Text constants
    private let untilText = "until"
    // Employee data
    var employeeImage: Image
    var employeeZone: String
    var employeeName: String
    var employeeRole: String
    var inCurrentZoneUntil: Date
    
    var body: some View {
        HStack {
            employeeImage
                .resizable()
                .frame(width: 72, height: 72)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                }
                .shadow(radius: 0.4)
            VStack(alignment: .leading) {
                ZStack {
                    HStack(spacing: 0) {
                        Text("\(employeeZone) \(untilText) ")
                        Text(inCurrentZoneUntil, style: .time)
                    }
                    .font(.system(size: 14))
                    .textCase(.uppercase)
                }
                Text(employeeName)
                    .font(.system(size: 32, weight: .semibold))
                Text(employeeRole)
                    .font(.system(size: 18, weight: .medium))
                    .opacity(0.65)
            }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
