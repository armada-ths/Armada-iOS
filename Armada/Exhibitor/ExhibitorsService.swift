class ExhibitorsService {
    static let sharedInstance = ExhibitorsService()

    private init() {}

    fileprivate var exhbitors: [Exhibitor]?
    fileprivate var employments: [Employment] = []
    fileprivate var sectors: [Industry] = []
    fileprivate var locations: [Location] = []

    func fetchExhibitors(success: @escaping (([Exhibitor]) -> Void)) {
        if let exhbitors = exhbitors {
            success(exhbitors)
        }

        guard let url = URL(string: "https://ais.armada.nu/api/exhibitors") else {
            print("ExhibitorService - Error: Can not create URL")
            return
        }

        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                var exhibitors = try decoder.decode([Exhibitor].self, from: data)
                // Saves the exhibitors
                self.exhbitors = exhibitors

                // Sort exhibitors
                exhibitors.sort(by: { a, b -> Bool in
                    a.name < b.name
                })
                success(exhibitors)
            } catch DecodingError.typeMismatch(let type, let context) {
                print("\(type) was expected, \(context.debugDescription)")
            } catch let error {
                print("ExhibitorsService::fetchExhibitors - \(error)")
            }
        }).resume()
    }

    func fetchEmployments(success: @escaping (([Employment]) -> Void)) {
        if !employments.isEmpty { success(employments) }

        if exhbitors == nil { fetchExhibitors(success: { _ in }) }

        guard let exhibitors = exhbitors else { return }
        for exhbitor in exhibitors {
            for employment in exhbitor.employments {
                employments.append(employment)
            }
        }

        // Remove duplicates
        employments = Array(Set(employments))

        employments.sort(by: { a, b -> Bool in
            a.name < b.name
        })

        success(employments)

    }

    func fetchSectors(success: @escaping (([Industry]) -> Void)) {
        if !sectors.isEmpty { success(sectors) }

        if exhbitors == nil { fetchExhibitors(success: { _ in }) }

        guard let exhibitors = exhbitors else { return }
        for exhbitor in exhibitors {
            for industry in exhbitor.industries {
                sectors.append(industry)
            }
        }

        // Remove duplicates
        sectors = Array(Set(sectors))

        sectors.sort(by: { a, b -> Bool in
            a.name < b.name
        })

        success(sectors)
    }

    func fetchLocations(success: @escaping (([Location]) -> Void)) {
        if !locations.isEmpty { success(locations) }

        if exhbitors == nil { fetchExhibitors(success: { _ in }) }

        guard let exhibitors = exhbitors else { return }
        for exhbitor in exhibitors {
            for location in exhbitor.locations {
                locations.append(location)
            }
        }

        // Remove duplicates
        locations = Array(Set(locations))

        locations.sort(by: { a, b -> Bool in
            a.id < b.id
        })

        success(locations)
    }
}
