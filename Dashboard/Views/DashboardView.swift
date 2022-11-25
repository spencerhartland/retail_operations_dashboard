//
//  DashboardView.swift
//  Dashboard
//
//  Created by Spencer Hartland on 11/10/22.
//

import SwiftUI

struct DashboardView: View {
    private let storeNumber = "R082"
    private let storeName = "UTC"
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(storeNumber) \(storeName)")
                .font(.system(size: 96, weight: .bold))
                .padding(.bottom, 32)
            
            HStack(alignment: .top, spacing: 48) {
                ScheduleView()
                    .padding()
                StatusView()
                    .padding()
                RunnerView()
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
