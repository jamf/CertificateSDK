//
//  SPDX-License-Identifier: MIT
//  https://github.com/jamf/CertificateSDK
//
//  Copyright 2024, Jamf
//
import SwiftUI

struct RequestTypeView: View {
    @ObservedObject var model: RequestTypeModel

    var body: some View {
        List {
            Picker("Simulated/Actual", selection: $model.isActual) {
                Text("Simulated")
                    .tag(false)
                Text("Actual")
                    .tag(true)
            }
            .pickerStyle(.segmented)
            if model.isActual {
                Text("Makes network calls to the Jamf Pro server to request a certificate")
                    .font(.footnote)
            } else {
                Text("Uses the embedded example .p12 for local testing")
                    .font(.footnote)
                SidebarSwitch(title: "Slow speed",
                              descriptiveText: "Simulates a slow server",
                              switchIsOn: $model.slowSpeed)
                SidebarSwitch(title: "Error simulation",
                              descriptiveText: "Results in an error",
                              switchIsOn: $model.simulateError)
            }
            Button("Run Text", systemImage: "play") {
                model.runTest(resetOutput: true)
            }
            Text("Schedule a local notification to renew the certificate in five seconds")
                .font(.footnote)
            Button(model.notificationScheduled ? "Scheduled" : "Schedule Notification",
                   systemImage: "play") {
                model.scheduleNotification()
            }
            .disabled(model.notificationScheduled)
        }
        .listStyle(.sidebar)
    }
}

/// This view has a Toggle with a title and descriptive text.
struct SidebarSwitch: View {
    let title: String
    let descriptiveText: String
    @Binding var switchIsOn: Bool

    var body: some View {
        Toggle(isOn: $switchIsOn) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                Text(descriptiveText)
                    .font(.footnote)
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    let model = RequestTypeModel()
    NavigationSplitView {
        RequestTypeView(model: model)
    } detail: {
    }
}
