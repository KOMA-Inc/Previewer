import SwiftUI

@main
struct PreviewerApp: App {

    @StateObject private var appStorage = AppStorage()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appStorage)
        }.commands {
            ExportCommand(appStorage: appStorage)
        }
    }
}
