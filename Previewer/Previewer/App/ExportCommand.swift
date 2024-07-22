import AppKit
import SwiftUI

struct ExportCommand: Commands {

    @ObservedObject var appStorage: AppStorage

    var body: some Commands {
        CommandGroup(after: .newItem) {
            Button("Export Report") {
                let content = generateFileContent(using: appStorage.invalidPictures)
                saveToFile(content)
            }
            .keyboardShortcut(KeyEquivalent("P"), modifiers: .command)
        }
    }

    private func generateFileContent(using pictures: Set<Picture>) -> String {
        pictures.map { picture in
            "| " +
            picture.features.sorted { $0.key < $1.key }.map { key, value in
                "\(key) = \(value)"
            }.joined(separator: " | ") +
            " |"
        }.joined(separator: "\n\n-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n\n")
    }

    func saveToFile(_ content: String) {
        let savePanel = NSSavePanel()
        savePanel.prompt = "Save"
        savePanel.nameFieldStringValue = "report.txt"
        savePanel.allowedContentTypes = [.text]

        if savePanel.runModal() == .OK, let url = savePanel.url {
            do {
                try content.write(to: url, atomically: true, encoding: .utf8)
                print("File saved successfully at \(url.path)")
            } catch {
                print("Failed to save file: \(error.localizedDescription)")
            }
        } else {
            print("Save operation was canceled.")
        }
    }
}
