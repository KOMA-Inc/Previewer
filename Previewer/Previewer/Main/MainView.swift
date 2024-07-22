import AppKit
import SwiftUI
import UniformTypeIdentifiers

struct MainView: View {

    @StateObject private var viewModel = MainViewModel()
    @State private var isTargeted = false
    @State private var animateGradient = false

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            Text("Select a folder or\ndrag & drop it here")
                .font(.title.bold().monospaced())
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(.labelColor).opacity(0.2))
                .clipShape(.rect(cornerRadius: 12))
                .onTapGesture {
                    selectFolder()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(24)
                .gradient()
                .overlay {
                    if isTargeted {
                        Color.black.opacity(0.3)
                    }
                }
                .onDrop(of: [.folder], isTargeted: $isTargeted) { providers in
                    guard let provider = providers.first else { return false }
                    _ = provider.loadInPlaceFileRepresentation(forTypeIdentifier: UTType.folder.identifier) { url, success, error in
                        if let url = url, success {
                            viewModel.processFolder(at: url)
                        }
                    }
                    return true
                }
                .navigationDestination(for: [Directory].self) { directories in
                    DirectoriesList(directories: directories)
                }
                .navigationDestination(for: Directory.self) { directory in
                    Gallery(directory: directory)
                }
        }
    }

    private func selectFolder() {
        let dialog = NSOpenPanel()
        dialog.title = "Choose a folder"
        dialog.canChooseDirectories = true
        dialog.canChooseFiles = false
        dialog.allowsMultipleSelection = false

        if dialog.runModal() == .OK {
            if let url = dialog.url {
                viewModel.processFolder(at: url)
            }
        }
    }
}
