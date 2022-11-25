//
//  RunnerView.swift
//  Dashboard
//
//  Created by Spencer Hartland on 11/17/22.
//

import SwiftUI

struct RunnerView: View {
    private let runnerViewTitle = "Runner"
    private let submittedSectionTitle = "Submitted"
    private let inProgressSectionTitle = "In Progress"
    
    @State var viewModel = RunnerViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // View title
            Text(runnerViewTitle)
                .font(.system(size: 64, weight: .semibold))
                .padding(.bottom, 8)
            
            // Submitted runs section
            if !viewModel.submitted.isEmpty {
                Text(submittedSectionTitle)
                    .font(.system(size: 32, weight: .semibold))
                ForEach(viewModel.submitted, id: \.submittedAt) { request in
                    RunView(request: request)
                }
            }
            
            // In Progress runs section
            if !viewModel.inProgress.isEmpty {
                Text(inProgressSectionTitle)
                    .font(.system(size: 32, weight: .semibold))
                ForEach(viewModel.inProgress, id: \.submittedAt) { request in
                    RunView(request: request)
                }
            }
        }
        .frame(minWidth: 550, maxWidth: 625)
    }
}

struct RunView: View {
    private let shoppingRequestImageName = "shopping.icon"
    private let inProgressText = "In Progress"
    
    let request: RunRequest
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image(shoppingRequestImageName)
                    .resizable()
                    .frame(width: 44, height: 44)
                    .cornerRadius(8)
                    .padding([.top, .trailing], 8)
                VStack(alignment: .leading) {
                    Text(request.requestedBy)
                        .font(.system(size: 24, weight: .medium))
                    Text(request.location)
                    if request.claimed {
                        Text("\(inProgressText): \(request.claimedBy)")
                    }
                }
                Spacer()
                // TODO: Make the timer count as time goes on
                Text(durationString(Date().timeIntervalSince(request.submittedAt)))
            }
            .padding()
            .font(.system(size: 18))
            .background {
                Rectangle()
                    .foregroundColor(.black.opacity(0.08))
            }
            VStack(alignment: .leading) {
                HStack {
                    // TODO: Fix appearance of request with multiple items
                    ForEach(request.items, id: \.partNumber) { item in
                        Text(item.partNumber)
                            .font(.system(size: 24, weight: .medium))
                    }
                    Spacer()
                }
                Text("\(request.itemCount) \(request.itemCount > 1 ? "items" : "item")")
                    .font(.system(size: 18))
                    .opacity(0.6)
            }
            .padding()
        }
        .background {
            Rectangle()
                .foregroundColor(.secondary.opacity(0.15))
        }
        .cornerRadius(16)
    }
}

private func durationString(_ duration: TimeInterval) -> String {
        let minute = Int(duration) / 60 % 60
        let second = Int(duration) % 60

        // return formated string
    return String(format: minute > 0 ? "%01i:%02i" : "%02i:%02i", minute, second)
}

struct RunnerView_Previews: PreviewProvider {
    static var previews: some View {
        RunnerView()
    }
}
