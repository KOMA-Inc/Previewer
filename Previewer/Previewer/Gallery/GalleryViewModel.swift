import Combine
import Foundation

class GalleryViewModel: ObservableObject {

    private let _contents_: [Picture]

    @Published var searchInput = ""

    var contents: [Picture] {
        _contents_
            .filter { picture in
                // Filter based on search input
                searchInput.isEmpty || picture.path.lastPathComponent.lowercased().contains(searchInput.lowercased())
            }
            .filter { picture in
                // Filter based on features
                picture.features.allSatisfy { key, value in
                    features.first { $0.key == key }?
                        .values
                        .filter(\.isActive)
                        .map(\.name)
                        .contains(value) ?? false
                }
            }
    }

    @Published var features: [Feature]

    init(directory: Directory) {

        let sorted = directory.contents.sorted { lhs, rhs in
            lhs.path.lastPathComponent < rhs.path.lastPathComponent
        }

        self._contents_ = sorted
        self.features = directory.features
            .sorted { $0.key < $1.key }
            .map { key, values in
                Feature(key: key, values: values)
            }
    }
}
