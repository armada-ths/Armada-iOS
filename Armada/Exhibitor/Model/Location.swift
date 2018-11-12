struct Location: Codable {
    let id: Int
    let name: String
}

extension Location: Hashable {
    var hashValue: Int {
        return self.id + self.name.hashValue
    }

    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
