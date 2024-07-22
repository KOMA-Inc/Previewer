struct Feature {

    let key: String
    var values: [Value]

    init(key: String, values: Set<String>) {
        self.key = key
        self.values = values
            .sorted()
            .map { name in
                Value(name: name)
            }
    }
}

extension Feature {

    struct Value: Hashable {
        let name: String
        var isActive = true

        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }
    }
}
