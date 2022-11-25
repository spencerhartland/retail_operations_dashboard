//
//  StatisticsViewModel.swift
//  Dashboard
//
//  Created by Spencer Hartland on 11/17/22.
//

import Foundation

private enum JSONFileNames: String {
    case avgRunTime = "AVGRunTime"
    case apuConfirmTime = "APUConfirmTime"
    case idlConfirmTime = "IDLConfirmTime"
    case accuracy = "Accuracy"
}

struct DurationOfTime: Codable {
    let durationInSeconds: Int
}

struct PercentValue: Codable {
    let percentValue: Double
}

class StatisticsViewModel {
    private let jsonFileNames = [JSONFileNames.avgRunTime, JSONFileNames.apuConfirmTime, JSONFileNames.idlConfirmTime, JSONFileNames.accuracy]
    private let jsonExtension = "json"
    
    public var avgRunTimeInSeconds: Int = 0
    public var idlConfirmTimeInSeconds: Int = 0
    public var apuConfirmTimeInSeconds: Int = 0
    public var accuracy: Double = 0.0
    
    init() {
        decodeStatistics()
    }
    
    func decodeStatistics() {
        for filename in jsonFileNames {
            if let fileURL = Bundle.main.url(forResource: filename.rawValue, withExtension: jsonExtension) {
                do {
                    let data = try Data(contentsOf: fileURL)
                    let value = try JSONDecoder().decode(DurationOfTime.self, from: data)
                    switch filename {
                    case .avgRunTime:
                        avgRunTimeInSeconds = value.durationInSeconds
                    case .apuConfirmTime:
                        apuConfirmTimeInSeconds = value.durationInSeconds
                    case .idlConfirmTime:
                        idlConfirmTimeInSeconds = value.durationInSeconds
                    default:
                        continue
                    }
                } catch {
                    do {
                        let data = try Data(contentsOf: fileURL)
                        let value = try JSONDecoder().decode(PercentValue.self, from: data)
                        accuracy = value.percentValue
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
