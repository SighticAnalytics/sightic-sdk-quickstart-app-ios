//
// Copyright © 2022-2024 Sightic Analytics AB. All rights reserved.
//

import SighticAnalytics
import SwiftUI

/// Initial view.
///
/// The start view implements logic to check if the current device is compatible
/// with Sightic SDK using the `SighticSupportedDevices.status` property.
struct StartView: View {
    @Binding var screen: Screen

    @AppStorage("showInstructions") private var showInstructions = true
    @AppStorage("allowToSave") private var allowToSave = true

    @State private var status: SighticSupportedDevices.Status?

    var body: some View {
        VStack {
            Header(
                title: "Sightic Quickstart",
                subtitle: "SDK version: \(SighticVersion.sdkVersion)"
            )

            Spacer()

            // Switch on value from SighticSupportedDevices.status
            switch status {
            case .none:
                ProgressView().controlSize(.extraLarge)

            case .supported:
                HugeButton("Start test") {
                    startTest()
                }

            case .networkError:
                Text("There seems to be a network error")

            case .unsupported:
                Text("Device not supported by Sightic SDK 😞")
                    .padding()
                Button("Start test anyway") {
                    startTest()
                }
                .buttonStyle(.borderedProminent)
            }

            Spacer()

            // Show warning if SighticQuickstart.apiKey is not set
            if SighticQuickstart.apiKey.isEmpty {
                TextFrame(
                    symbol: "exclamationmark.triangle",
                    title: "API key missing",
                    text: "Add your API key to SighticQuickstart.swift"
                )
            }

            Divider()

            VStack {
                Toggle("Show instructions", isOn: $showInstructions)
                Toggle("Allow to save", isOn: $allowToSave)
            }
            .padding()
        }
        .task {
            status = await SighticSupportedDevices.status
        }
    }

    private func startTest() {
        screen = .test(
            showInstructions: showInstructions,
            allowToSave: allowToSave
        )
    }
}

#Preview {
    StartView(screen: .constant(.start))
}
