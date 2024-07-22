import Foundation

struct Picture: Equatable, Hashable {

    let path: URL

    var features: [String: String] {
        let name = path.lastPathComponent
            .replacingOccurrences(of: ".\(path.pathExtension)", with: "")

        let features = name.split(separator: ";")
            .compactMap { feature in
                let components = feature.split(separator: "=")
                if components.count == 2,
                   let key = components.first,
                   let value = components.last {
                    return (String(key), String(value))
                }

                return nil
            }

        return Dictionary(features) { _, last in last }
    }
}
