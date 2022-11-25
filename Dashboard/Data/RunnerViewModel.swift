//
//  RunnerViewModel.swift
//  Dashboard
//
//  Created by Spencer Hartland on 11/25/22.
//

import Foundation

enum RunRequestType: String, Codable {
    // TODO: Add all of the request types
    case shopping = "shopping"
}

struct RequestItem: Codable {
    let partNumber: String
    let description: String
}

struct RunRequest: Codable {
    let submittedAt: Date
    let type: RunRequestType
    let claimed: Bool
    let claimedBy: String
    let requestedBy: String
    let location: String
    let itemCount: Int
    let items: [RequestItem]
}

class RunnerViewModel {
    private static let jsonFileName = "RunRequests"
    private static let jsonExtension = "json"
    
    private var requests = [RunRequest]()
    public var submitted = [RunRequest]()
    public var inProgress = [RunRequest]()
    
    init() {
        self.requests = RunnerViewModel.decodeRunRequests()
        sortRequests()
    }
    
    private static func decodeRunRequests() -> [RunRequest] {
        if let fileURL = Bundle.main.url(forResource: jsonFileName, withExtension: jsonExtension) {
            do {
                let runRequestsData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode([RunRequest].self, from: runRequestsData)
            } catch {
                print(error)
            }
        }
        
        return [RunRequest]()
    }
    
    private func sortRequests() {
        for request in requests {
            if request.claimed {
                inProgress.append(request)
            } else {
                submitted.append(request)
            }
        }
    }
}
