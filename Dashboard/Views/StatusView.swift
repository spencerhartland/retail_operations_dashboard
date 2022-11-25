//
//  StatusView.swift
//  Dashboard
//
//  Created by Spencer Hartland on 11/15/22.
//

import SwiftUI

struct StatusView: View {
    private let statusViewTitle = "Status"
    private let orderFulfillmentTitle = "Order Fulfillment"
    private let performanceTitle = "Performance"
    private let idlTitle = "Immediate Delivery"
    private let idlSymbol = "figure.wave.circle.fill"
    private let pickupTitle = "Pickup"
    private let pickupSymbol = "bag.circle.fill"
    
    @State var orders: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // View title
            Text(statusViewTitle)
                .font(.system(size: 64, weight: .semibold))
                .padding(.bottom, 8)
            
            // Order fulfillment section
            Text(orderFulfillmentTitle)
                .font(.system(size: 32, weight: .semibold))
            // Pickups
            VStack {
                // TODO: Change input for `orders` to state var above
                OrderFulfillmentStatusView(symbol: pickupSymbol, title: pickupTitle, orders: .constant(2))
                OrderFulfillmentStatusView(symbol: idlSymbol, title: idlTitle, orders: .constant(0))
            }
            .padding(.bottom, 16)
            
            // Performance section
            Text(performanceTitle)
                .font(.system(size: 32, weight: .semibold))
            StatisticsView()        }
        .frame(minWidth: 550, maxWidth: 625)
    }
}

private struct OrderFulfillmentStatusView: View {
    private let alertSymbol = "exclamationmark.circle.fill"
    let symbol: String
    let title: String
    @Binding var orders: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: symbol)
                    Text(title)
                }
                .font(.system(size: 32, weight: .medium))
                HStack(alignment: .firstTextBaseline) {
                    Text("\(orders)")
                        .font(.system(size: 72, weight: .semibold, design: .monospaced))
                    Text("\(orders == 1 ? "order" : "orders") to fulfill")
                        .font(.system(size: 32, weight: .medium))
                }
            }
            .padding()
            Spacer()
            if orders > 0 {
                Image(systemName: alertSymbol)
                    .font(.system(size: 72))
                    .padding(.trailing, 16)
                    .foregroundColor(orders > 1 ? (orders > 2 ? .red : .orange) : .primary)
            }
        }
        .background {
            Rectangle()
                .foregroundColor(.secondary.opacity(0.15))
                .cornerRadius(16)
        }
    }
}

private struct StatisticsView: View {
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                StatisticView(type: .avgRunTime)
                StatisticView(type: .idlConfirmTime)
            }
            Spacer()
            VStack(alignment: .leading) {
                StatisticView(type: .apuConfirmTime)
                StatisticView(type: .accuracy)
            }
        }
        .padding()
        .background {
            Rectangle()
                .foregroundColor(.secondary.opacity(0.15))
                .cornerRadius(16)
        }
    }
}

private struct StatisticView: View {
    private let upwardTrendSymbol = "chevron.up.circle.fill"
    private let downwardTrendSymbol = "chevron.down.circle.fill"
    private let timeLimit = 120
    private let accuracyGoal = 99.0
    private let formatter = DateComponentsFormatter()
    
    let type: StatisticType
    
    @AppStorage(StatisticType.avgRunTime.rawValue) var prevAvgRunTimeValue: Int = 0
    @AppStorage(StatisticType.apuConfirmTime.rawValue) var prevApuConfirmTimeValue: Int = 0
    @AppStorage(StatisticType.idlConfirmTime.rawValue) var prevIdlConfirmTimeValue: Int = 0
    @AppStorage(StatisticType.accuracy.rawValue) var prevAccuracyValue: Double = 0.0
    @State var viewModel = StatisticsViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            // Stat title
            Text(type.rawValue)
                .font(.system(size: 24, weight: .semibold))
            // Stat
            HStack {
                switch type {
                case.avgRunTime:
                    // m:ss
                    Text(durationString(TimeInterval(viewModel.avgRunTimeInSeconds)))
                        .foregroundColor(viewModel.avgRunTimeInSeconds > timeLimit ? .red : .primary)
                    if viewModel.avgRunTimeInSeconds > prevAvgRunTimeValue {
                        Image(systemName: upwardTrendSymbol)
                            .font(.system(size: 32))
                            .foregroundColor(.red)
                    } else if viewModel.avgRunTimeInSeconds < prevAvgRunTimeValue {
                        Image(systemName: downwardTrendSymbol)
                            .font(.system(size: 32))
                            .foregroundColor(.green)
                    }
                case .apuConfirmTime:
                    Text(durationString(TimeInterval(viewModel.apuConfirmTimeInSeconds)))
                        .foregroundColor(viewModel.apuConfirmTimeInSeconds > timeLimit ? .red : .primary)
                    if viewModel.apuConfirmTimeInSeconds > prevApuConfirmTimeValue {
                        Image(systemName: upwardTrendSymbol)
                            .font(.system(size: 32))
                            .foregroundColor(.red)
                    } else if viewModel.apuConfirmTimeInSeconds < prevApuConfirmTimeValue {
                        Image(systemName: downwardTrendSymbol)
                            .font(.system(size: 32))
                            .foregroundColor(.green)
                    }
                case .idlConfirmTime:
                    Text(durationString(TimeInterval(viewModel.idlConfirmTimeInSeconds)))
                        .foregroundColor(viewModel.idlConfirmTimeInSeconds > timeLimit ? .red : .primary)
                    if viewModel.idlConfirmTimeInSeconds > prevIdlConfirmTimeValue {
                        Image(systemName: upwardTrendSymbol)
                            .font(.system(size: 32))
                            .foregroundColor(.red)
                    } else if viewModel.idlConfirmTimeInSeconds < prevIdlConfirmTimeValue {
                        Image(systemName: downwardTrendSymbol)
                            .font(.system(size: 32))
                            .foregroundColor(.green)
                    }
                case .accuracy:
                    Text("\(String(format: "%.2f", viewModel.accuracy))%")
                        .foregroundColor(viewModel.accuracy < accuracyGoal ? .red : .primary)
                    if viewModel.accuracy > prevAccuracyValue {
                        Image(systemName: upwardTrendSymbol)
                            .font(.system(size: 32))
                            .foregroundColor(.green)
                    } else if viewModel.accuracy < prevAccuracyValue {
                        Image(systemName: downwardTrendSymbol)
                            .font(.system(size: 32))
                            .foregroundColor(.red)
                    }
                }
            }
            .font(.system(size: 72, weight: .semibold))
        }
        .padding()
        .onAppear {
            formatter.allowedUnits = [.minute, .second]
        }
        .onDisappear {
            // Update "previous" values
            prevAvgRunTimeValue = viewModel.avgRunTimeInSeconds
            prevApuConfirmTimeValue = viewModel.apuConfirmTimeInSeconds
            prevIdlConfirmTimeValue = viewModel.idlConfirmTimeInSeconds
            prevAccuracyValue = viewModel.accuracy
        }
    }
    
    enum StatisticType: String {
        case avgRunTime = "AVG RUN TIME"
        case idlConfirmTime = "IDL CONFIRMATION"
        case apuConfirmTime = "APU CONFIRMATION"
        case accuracy = "ACCURACY"
    }
    
    private func durationString(_ duration: TimeInterval) -> String {
            let minute = Int(duration) / 60 % 60
            let second = Int(duration) % 60

            // return formated string
            return String(format: "%01i:%02i", minute, second)
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}
