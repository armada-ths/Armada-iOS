import UIKit
import CoreData


public struct ArmadaEvent {
    public let title: String
    public let summary: String
    public let location: String
    public let startDate: NSDate
    public let endDate: NSDate
    public let signupLink: String
    public let signupStartDate: NSDate?
    public let signupEndDate: NSDate?
    public let imageUrl: NSURL?
    
    var image: UIImage? {
        return UIImage(named: title.stringByReplacingOccurrencesOfString("ä", withString: ""))
    }
}

public struct News {
    public let title: String
    public let content: String
    public let publishedDate: NSDate
}

enum Response<T> {
    case Success(T)
    case Error(ErrorType)
}

let DataDude = _DataDude()

public class _DataDude {
    
    var companies = [Company]()
    
    var numberOfCompaniesForPropertyValueMap = [CompanyProperty:[String: Int]]()
    
    private let applicationDocumentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        return NSManagedObjectModel(contentsOfURL: NSBundle(forClass: self.dynamicType).URLForResource("CompanyModel", withExtension: "momd")!)!
        }()
    
    let persistentStoreUrl = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("SingleViewCoreData.sqlite")
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        print("Persisten store: \(self.persistentStoreUrl)")
        do {
            try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.persistentStoreUrl, options: nil)
        } catch {
            print(error)
            abort()
        }
        return persistentStoreCoordinator
        }()
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
        }()
    
    func generateMap() {
        var numberOfCompaniesForPropertyValueMap = [CompanyProperty:[String: Int]]()
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.WorkFields] = [:]
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = NSEntityDescription.entityForName("WorkField", inManagedObjectContext: managedObjectContext)!
            let workFields =  try! managedObjectContext.executeFetchRequest(fetchRequest) as! [WorkField]
            for workField in workFields {
                numberOfCompaniesForPropertyValueMap[.WorkFields]![workField.workField] = workField.companies.count
            }
            }()
        
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.Programmes] = [:]
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = NSEntityDescription.entityForName("Programme", inManagedObjectContext: managedObjectContext)!
            let programmes =  try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Programme]
            for programme in programmes {
                numberOfCompaniesForPropertyValueMap[.Programmes]![programme.programme] = programme.companies.count
            }
            }()
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.CompanyValues] = [:]
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = NSEntityDescription.entityForName("CompanyValue", inManagedObjectContext: managedObjectContext)!
            let companyValues =  try! managedObjectContext.executeFetchRequest(fetchRequest) as! [CompanyValue]
            for companyValue in companyValues {
                numberOfCompaniesForPropertyValueMap[.CompanyValues]![companyValue.companyValue] = companyValue.companies.count
            }
            }()
        
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.Continents] = [:]
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = NSEntityDescription.entityForName("Continent", inManagedObjectContext: managedObjectContext)!
            let continents =  try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Continent]
            for continent in continents {
                numberOfCompaniesForPropertyValueMap[.Continents]![continent.continent] = continent.companies.count
            }
            }()
        
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.JobTypes] = [:]
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = NSEntityDescription.entityForName("JobType", inManagedObjectContext: managedObjectContext)!
            let jobTypes =  try! managedObjectContext.executeFetchRequest(fetchRequest) as! [JobType]
            for jobType in jobTypes {
                numberOfCompaniesForPropertyValueMap[.JobTypes]![jobType.jobType] = jobType.companies.count
            }
            }()
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.WorkWays] = [:]
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = NSEntityDescription.entityForName("WorkWay", inManagedObjectContext: managedObjectContext)!
            let workWays =  try! managedObjectContext.executeFetchRequest(fetchRequest) as! [WorkWay]
            for workWay in workWays {
                numberOfCompaniesForPropertyValueMap[.WorkWays]![workWay.workWay] = workWay.companies.count
            }
            }()
        
        
        self.numberOfCompaniesForPropertyValueMap = numberOfCompaniesForPropertyValueMap
    }
    
    func numberOfCompaniesContainingValue(value: String, forProperty property: CompanyProperty) -> Int? {
        return numberOfCompaniesForPropertyValueMap[property]![value]
    }
    
    
    
    
    private init() {
        let stopWatch = StopWatch()
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Company", inManagedObjectContext: managedObjectContext)!
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "caseInsensitiveCompare:")]
        companies = try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Company]
        
        print("Result: \(companies.count)")
        stopWatch.print("Fetching managed companies ")
        
        //        NSOperationQueue.mainQueue().addOperationWithBlock {
        //            let stopWatch = StopWatch()
        //            self.generateMap()
        //            stopWatch.print("Making map")
        //        }
    }
    
    
    func updateCompanies(callback: () -> ()) {
        let stopWatch = StopWatch()
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Company", inManagedObjectContext: managedObjectContext)!
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "caseInsensitiveCompare:")]
        companies = try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Company]
        
        
        _DataDude.getCompaniesRespectingEtag() {
            switch $0 {
            case .Success(let (_, usedCache)):
                if !usedCache {
                    NSOperationQueue().addOperationWithBlock {
                        let companiesJson = _DataDude.staticCompanies()
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            print("DESTROYING THE DATABASE!!!!!")
                            if companiesJson.count > 0 {
                                for company in self.companies {
                                    self.managedObjectContext.deleteObject(company)
                                }
                                try! self.managedObjectContext.save()
                                self.companies = []
                                
                                //        if companies.isEmpty {
                                for json in companiesJson {
                                    if let company = Company.companyFromJson(json, managedObjectContext: self.managedObjectContext) {
                                        self.companies.append(company)
                                    }
                                }
                                try! self.managedObjectContext.save()
                                //        }
                            }
                            callback()
                        }
                    }
                } else {
                    callback()
                }
                break
            case .Error(let error):
                print(error)
            }
        }
        
        
        print("Result: \(companies.count)")
        stopWatch.print("Fetching managed companies ")
    }
    
    
    
    
    class func staticCompanies() -> [AnyObject] {
        do {
            
            if let url = NSURL(string: "http://staging.armada.nu/api/companies"),
                let data = NSData(contentsOfURL: url) {
                    return try NSJSONSerialization.JSONObjectWithData(data, options: [])["companies"] as? [AnyObject] ?? []
            }
            return []
        } catch {
            print(error)
            return []
        }
        
        //        let companies = DataDude.companiesFromJson(json)
    }
    
    class func getCompaniesRespectingEtag(callback: Response<(NSData, Bool)> -> Void) {
        let url = NSURL(string: "http://staging.armada.nu/api/companies")!
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: url)
        var usedCache = false
        let dataTask = session.dataTaskWithRequest(request) {
            (data, response, error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                usedCache = httpResponse.etag == SettingsManager.companiesEtag
                SettingsManager.companiesEtag = httpResponse.etag
            }
            if let data = data {
                let zebra = (data, usedCache)
                print("Url: \(url.absoluteString), cached: \(usedCache)")
                callback(.Success(zebra))
            } else if let error = error {
                callback(.Error(error))
            } else {
                callback(.Error(NSError(domain: "getData", code: 1337, userInfo: nil)))
            }
        }
        dataTask.resume()
    }
    
    class func getData(url: NSURL, callback: Response<NSData> -> Void) {
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: url)
        let dataTask = session.dataTaskWithRequest(request) {
            (data, response, error) in
            if let data = data {
                callback(.Success(data))
            } else if let error = error {
                callback(.Error(error))
            } else {
                callback(.Error(NSError(domain: "getData", code: 1337, userInfo: nil)))
            }
        }
        dataTask.resume()
    }
    
    class func getJson(url: NSURL, callback: Response<AnyObject> -> Void) {
        getData(url) {
            switch $0 {
            case .Success(let data):
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                    callback(.Success(json))
                } catch {
                    callback(.Error(error))
                }
            case .Error(let error):
                callback(.Error(error))
            }
        }
    }
    
    
    var jobTypes: [String] {
        return Array(Set(companies.flatMap({ $0.jobTypes }).map { $0.jobType })).sort(<)
    }
    
    var companyValues: [String] {
        return Array(Set(companies.flatMap({ $0.companyValues }).map { $0.companyValue })).sort(<)
    }
    
    var workWays: [String] {
        return Array(Set(companies.flatMap({ $0.workWays }).map { $0.workWay })).sort(<)
    }
    
    var continents: [String] {
        return Array(Set(companies.flatMap({ $0.continents }).map { $0.continent })).sort(<)
    }
    
    var workFields: [String] {
        return Array(Set(companies.flatMap({ $0.workFields }).map { $0.workField })).sort(<)
    }
    
    var educationTypes: [String] {
        return Array(Set(companies.flatMap({ $0.programmes }).map { $0.programme })).sort(<)
    }
    
    func dateFromString(string: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        let b = string.componentsSeparatedByString(":")
        return dateFormatter.dateFromString(b[0..<b.count-1].joinWithSeparator(":") + b[b.count-1])!
    }
    
    
    var programmes: [String] {
        return educationTypes
    }
    
    public func eventsFromJson( jsonOriginal: AnyObject) -> [ArmadaEvent] {
        let json = jsonOriginal["events"]
        
        return Array.removeNils((json as? [[String: AnyObject]])?.map { json -> ArmadaEvent? in
            if let title = json["title"] as? String,
                let summary = json["description"] as? String,
                let location = json["location"] as? String,
                let startDateString = json["starts_at"] as? String,
                let endDateString = json["ends_at"] as? String,
                let signupLink = json["external_signup_link"] as? String {
                    let signupStartDateString = json["signup_starts_at"] as? String
                    let signupEndDateString = json["signup_ends_at"] as? String
                    let signupStartDate: NSDate? = signupStartDateString != nil ? self.dateFromString(signupStartDateString!) : nil
                    let signupEndDate: NSDate? = signupEndDateString != nil ? self.dateFromString(signupEndDateString!) : nil
                    let title = title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    
                    let imageUrlString = json["picture_url"] as? String
                    let imageUrl: NSURL? = imageUrlString != nil ? NSURL(string: imageUrlString!) : nil
                    let summary = summary.stringByReplacingOccurrencesOfString("\\s+", withString: " ", options: .RegularExpressionSearch, range: nil)
                    return ArmadaEvent(title: title, summary: summary, location: location.isEmpty ? "Valhallavägen" : location, startDate: self.dateFromString(startDateString), endDate: self.dateFromString(endDateString), signupLink: signupLink, signupStartDate: signupStartDate, signupEndDate: signupEndDate, imageUrl: imageUrl)
            }
            return nil
            } ?? []).filter({ $0.startDate.timeIntervalSince1970 >=  NSDate().timeIntervalSince1970 }).sort({ $0.startDate.timeIntervalSince1970 < $1.startDate.timeIntervalSince1970 })
    }
    
    public func newsFromJson(jsonOriginal: AnyObject) -> [News] {
        let json = jsonOriginal["news"]
        
        return Array.removeNils((json as? [[String: AnyObject]])?.map { json -> News? in
            if let title = json["title"] as? String,
                let content = json["content"] as? String,
                let date = json["date_published"] as? String{
                    return News(title: title, content: content, publishedDate: self.dateFromString(date))
            }
            return nil
            } ?? [])
    }
    
    public func sponsorsFromJson(jsonOriginal: AnyObject) -> [Sponsor] {
        let json = jsonOriginal["sponsors"]
        return Array.removeNils((json as? [[String: AnyObject]])?.map { json -> Sponsor? in
            if let name = json["name"] as? String ?? json["title"] as? String,
                let description = json["full_text"] as? String,
                let imageUrlString = json["logo_url"] as? String,
                let imageUrl = NSURL(string: imageUrlString),
                let websiteUrlString = json["website_url"] as? String,
                let websiteUrl = NSURL(string: websiteUrlString) {
                    return Sponsor(name: name, imageUrl: imageUrl, description: description, websiteUrl: websiteUrl)
                    
            }
            return nil
            
            } ?? [])
    }
    
    static let companiesFileName = "companies.json"
    
    static let dir = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as [String])[0]
    
    //    class func companiesFromFile() -> [Company]? {
    //        if let data = NSData(contentsOfFile: (dir as NSString).stringByAppendingPathComponent(companiesFileName)),
    //            let json: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data, options: []) {
    //                return companiesFromJson(json)
    //        }
    //        return nil
    //    }
    //
    //    class func companiesFromServer() throws -> [Company] {
    //        let json = try jsonFromUrl("http://armada.nu/api/companies.json?include=relations")
    //        return companiesFromJson(json)
    //    }
    //
    
    
    let apiUrl = "http://staging.armada.nu/api"
    
    
    
    
    func eventsFromServer() throws -> [ArmadaEvent] {
        let json = try jsonFromUrl((apiUrl as NSString).stringByAppendingPathComponent("events"))
        return eventsFromJson(json)
    }
    
    func sponsorsFromServer() throws -> [Sponsor] {
        let json = try jsonFromUrl((apiUrl as NSString).stringByAppendingPathComponent("sponsors"))
        return sponsorsFromJson(json)
    }
    
    func newsFromServer() throws -> [News] {
        let json = try jsonFromUrl((apiUrl as NSString).stringByAppendingPathComponent("news"))
        return newsFromJson(json)
    }
    
    func pagesFromServer() throws -> AnyObject {
        let json = try jsonFromUrl((apiUrl as NSString).stringByAppendingPathComponent("pages"))
        
        var armadaPages = [String: AnyObject]()
        if let pages = json["pages"] as? [AnyObject] {
            for page in pages {
                armadaPages[page["slug"] as? String ?? ""] = page
            }
        }
        return armadaPages
    }
    
    struct ArmadaField {
        let image: UIImage
        let name: String
        let description: String
        
        
        let type: ArmadaFieldType
        
    }
    
    enum ArmadaFieldType: String {
        case Startup = "icon_startup"
        case ClimateCompensation = "icon_climate_compensation"
        case Diversity = "icon_diversity"
        case Sustainability = "icon_sustainability"
    }
    
    
    var armadaFields: [ArmadaField] {
        let slugs: [(imageName: String, slug: String)] = [
            ("Leaf", "icon_climate_compensation"),
            ("Rocket", "icon_startup"),
            ("Tree", "icon_sustainability"),
            ("diversity", "icon_diversity"),
        ]
        
        func armadaFieldFromSlug(slug: (imageName: String, slug: String)) -> ArmadaField {
            let name = (armadaPages[slug.slug]??["title"] as? String) ?? ""
            let description = (armadaPages[slug.slug]??["app_text"] as? String) ?? ""
            let armadaType = ArmadaFieldType(rawValue: slug.slug)!
            return ArmadaField(image: UIImage(named: slug.imageName)!, name: name, description: description, type: armadaType)
        }
        
        return slugs.map(armadaFieldFromSlug)
    }
}

let armadaPages = ((try? DataDude.pagesFromServer()) ?? "wtf")!

func jsonFromUrl(url: String) throws -> AnyObject {
    if let url = NSURL(string: url) {
        let data = try NSData(contentsOfURL: url, options: [])
        return try NSJSONSerialization.JSONObjectWithData(data, options: [])
    }
    
    throw NSError(domain: "banan", code: 1337, userInfo: [:])
}

extension Array {
    static func removeNils(array: [Element?]) -> [Element] {
        return array.filter { $0 != nil }.map { $0! }
    }
}

extension NSHTTPURLResponse {
    var etag: String? {
        return allHeaderFields["Etag"] as? String
    }
}