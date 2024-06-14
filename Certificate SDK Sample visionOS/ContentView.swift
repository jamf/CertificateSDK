//
//  SPDX-License-Identifier: MIT
//  https://github.com/jamf/CertificateSDK
//
//  Copyright 2024, Jamf
//
import SwiftUI

struct ContentView: View {
    @ObservedObject var model = RequestTypeModel()
    var body: some View {
        NavigationSplitView {
            RequestTypeView(model: model)
                .navigationTitle("Select Test Type")
        } detail: {
            RightArea(model: model)
                .navigationTitle("Action Log")
        }
        .onAppear {
            LocalNotificationService.shared.registerForNotifications()
        }
    }
}

struct RightArea: View {
    @ObservedObject var model: RequestTypeModel

    var body: some View {
        ProgressView(value: model.progress, total: 1.0)
        ScrollView {
            Text(model.completeOutput)
                .lineLimit(nil)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .padding(.leading)
        .defaultScrollAnchor(.bottom)
        HStack {
            Button("Reset") {
                model.reset()
            }
            Button("Rerun Test") {
                model.runTest(resetOutput: false)
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
