struct Employment: Codable {
    let id: Int
    let name: String
}

extension Employment: Hashable {
    var hashValue: Int {
        return self.id + self.name.hashValue
    }

    static func == (lhs: Employment, rhs: Employment) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
