import Foundation

struct Directory: Hashable, Identifiable {

    let path: URL
    var contents: [Picture] = []

    var features: [String: Set<String>] = [:]

    mutating func add(_ picture: Picture) {
        contents.append(picture)
        if features.isEmpty {
            for feature in picture.features {
                addValue(feature.value, to: feature.key)
            }
        } else {
            for feature in picture.features where features.keys.contains(feature.key) {
                addValue(feature.value, to: feature.key)
            }
        }
    }

    mutating func addValue(_ value: String, to key: String) {
        if var set = features[key] {
            set.insert(value)
            features[key] = set
        } else {
            features[key] = [value]
        }
    }

    var id: URL { path }
}
