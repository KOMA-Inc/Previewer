import Combine
import Foundation
import SwiftUI

class MainViewModel: ObservableObject {

    @Published var path = NavigationPath()

    func processFolder(at url: URL) {
        let fileManager = FileManager.default
        var queue: [URL] = [url]

        var directories: [Directory] = []

        while !queue.isEmpty {
            let currentURL = queue.removeFirst()
            var directory = Directory(path: currentURL)
            do {
                let contents = try fileManager.contentsOfDirectory(at: currentURL, includingPropertiesForKeys: nil)
                for item in contents {
                    var isDirectory: ObjCBool = false
                    if fileManager.fileExists(atPath: item.path, isDirectory: &isDirectory) {
                        if isDirectory.boolValue {
                            // It's a folder, add to queue to process later
                            queue.append(item)
                        } else if item.pathExtension.lowercased() == "jpg" ||
                                    item.pathExtension.lowercased() == "png" ||
                                    item.pathExtension.lowercased() == "jpeg" {
                            // It's an image, add to list
                            let picture = Picture(path: item.absoluteURL)
                            directory.add(picture)
                        }
                    }
                }
                if !directory.contents.isEmpty {
                    directories.append(directory)
                }
            } catch {
                print("Error reading contents of directory: \(error.localizedDescription)")
            }
        }

        process(directories)
    }

    private func process(_ directories: [Directory]) {
        if directories.count > 1 {
            path.append(directories)
        } else if let directory = directories.first {
            path.append(directory)
        }
    }
}
