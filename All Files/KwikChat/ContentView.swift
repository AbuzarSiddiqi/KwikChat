//
//  ContentView.swift
//  KwikChat
//
//  Created by Abuzar Siddiqi on 2/22/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        // Mark: Redirecting User Based on Log Status
        if logStatus{
            MainView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
