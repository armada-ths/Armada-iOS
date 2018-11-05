class ExhibitorsService {
    static let sharedInstance = ExhibitorsService()

    private init() {}

    func fetchExhibitors(success: @escaping (([Exhibitor]) -> Void)) {
        guard let url = URL(string: "https://ais.armada.nu/api/exhibitors") else {
            print("ExhibitorService - Error: Can not create URL")
            return
        }

        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let exhibitors = try decoder.decode([Exhibitor].self, from: data)
                success(exhibitors)
            } catch DecodingError.typeMismatch(let type, let context) {
                print("\(type) was expected, \(context.debugDescription)")
            } catch let error {
                print("ExhibitorsService::fetchExhibitors - \(error)")
            }
        }).resume()
    }
}
