struct Industry: Codable {
    let id: Int
    let name: String
}

extension Industry: Hashable {
    var hashValue: Int {
        return self.id + self.name.hashValue
    }

    static func == (lhs: Industry, rhs: Industry) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
