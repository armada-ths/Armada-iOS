import UIKit

extension String {
    func containsWordWithPrefix(_ prefix: String) -> Bool {
        let words = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).map { $0.lowercased() }
        let searchWords = prefix.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter({ !$0.isEmpty}).map { $0.lowercased() }
        for searchPrefix in searchWords {
            if words.filter({ $0.hasPrefix(searchPrefix) }).isEmpty {
                return false
            }
        }
        return true
    }
}


extension UserDefaults {
    subscript(key: String) -> AnyObject? {
        get {
            return object(forKey: key) as AnyObject?
        }
        set {
            set(newValue, forKey: key)
        }
    }
}


extension UIView {
    
    func startActivityIndicator(hasNavigationBar: Bool = true) {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.frame = frame
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        activityIndicator.didMoveToSuperview()
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: hasNavigationBar ? -64 : 0).isActive = true
    }
    
    func stopActivityIndicator() {
        for subview in subviews {
            if let activityIndicator = subview as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
}



extension URL {
    func getData(_ callback: @escaping (Response<Data>) -> Void) {
        let url = self
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let data = data {
                callback(.success(data))
            } else if let error = error {
                callback(.error(error))
            } else {
                callback(.error(NSError(domain: "getData", code: 1337, userInfo: nil)))
            }
        }) 
        dataTask.resume()
    }
    
    func getJson(_ callback: @escaping (Response<AnyObject>) -> Void) {
        getData() {
            callback($0 >>= { data in
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                    return .success(json)
                } catch {
                    return .error(error)
                }
                })
        }
    }
    
    func getImage(_ callback: @escaping (Response<UIImage>) -> Void) {
        getData() {
            callback($0 >>= { data in
                if let image = UIImage(data: data) {
                    return .success(image)
                }
                return .error(NSError(domain: "getImage", code: 123456, userInfo: [NSLocalizedDescriptionKey: "Invalid image"]))
                })
        }
    }
    
}


private let UIViewShowEmptyMessageTag = 93734214

extension UIView {
    func showEmptyMessage(_ message: String, fontSize: CGFloat = 30) {
        hideEmptyMessage()
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        label.tag = UIViewShowEmptyMessageTag
        label.textColor = UIColor.lightGray
        label.didMoveToSuperview()
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor, constant: -40).isActive = true
    }
    
    func hideEmptyMessage() {
        for view in subviews {
            if view.tag == UIViewShowEmptyMessageTag {
                view.removeFromSuperview()
            }
        }
    }
}


extension UITableViewController {
    
    func showEmptyMessage(_ show: Bool, message: String) {
        if show {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            label.font = UIFont.systemFont(ofSize: 30)
            label.text = message
            label.numberOfLines = 2
            label.textAlignment = .center
            label.sizeToFit()
            label.textColor = UIColor.lightGray
            tableView.backgroundView = label
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        }
    }
    
    func deselectSelectedCell() {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension UIColor {
    convenience init(hex: Int) {
        let red = CGFloat((hex >> 16) & 0xff) / 255.0
        let green = CGFloat((hex >> 8) & 0xff) / 255.0
        let blue = CGFloat(hex & 0xff) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIImageView {
    func loadImageFromUrl(_ url: String, callback:((Response<UIImage>) -> Void)? = nil) {
        hideEmptyMessage()
        startActivityIndicator(hasNavigationBar: false)
        URL(string: url)?.getData() {
            OperationQueue.main.addOperation {
                self.stopActivityIndicator()
            }
            switch $0 {
            case .success(let data):
                if let image = UIImage(data: data) {
                    let operation = BlockOperation() {
                        UIView.transition(with: self, duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                            self.image = image
                            }, completion: nil)
                        callback?(.success(image))
                    }
                    operation.queuePriority = .veryLow
                    OperationQueue.main.addOperation(operation)
                } else {
                    OperationQueue.main.addOperation {
                        callback?(.error(NSError(domain: "loadImageFromUrl", code: 12345, userInfo: [NSLocalizedDescriptionKey: "Broken image"])))
                        self.showEmptyMessage("Broken image", fontSize: 15)
                    }
                }
            case .error(let error):
                OperationQueue.main.addOperation {
                    callback?(.error(error))
                    print(error)
                    self.image = nil
                    self.showEmptyMessage("Failed to load image: \((error as NSError).localizedDescription)", fontSize: 15)
                }
            }
            
        }
    }
}

extension Int {
    var thousandsSeparatedString: String {
        let x = self
        let thousands = x / 1000
        let nonThousands = x % 1000
        let paddedNonThousands = Array(0..<(3-"\(nonThousands)".characters.count)).reduce("") {a,b in a + "0"}
        return thousands > 0 ? "\(thousands) \(paddedNonThousands)\(nonThousands)" : "\(nonThousands)"
    }
}

class StopWatch {
    var start = Date()
    
    init() {}
    
    func print(_ description: String) {
        Swift.print("\(description) \(Int(Date().timeIntervalSince(start)*1000))ms")
        start = Date()
    }
}
extension String{
    var attributedHtmlString: NSAttributedString? {
        let html = "<div>" + self + "</div>" + "<style> div { font-family: \"helvetica neue\"; font-weight: 300; font-size: 18px; padding: 0; margin: 0; color: #4c4c4c; line-height: 25px;  }</style>"
        if let data = html.data(using: String.Encoding.unicode, allowLossyConversion: false) {
            return try? NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        }
        return nil
    }
    
    var strippedFromHtmlString: String {
        if let data = self.data(using: String.Encoding.unicode, allowLossyConversion: false) {
            return (try? NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil).string) ?? ""
        }
        return ""
    }
    
    var httpUrl: URL? {
        let httpPrefix = "http"
        return URL(string: (hasPrefix(httpPrefix) ? "" : httpPrefix + "://") + trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
    }
}


extension Date {
    
    func isSameDayAsDate(_ date: Date) -> Bool {
        let dateCalendarComponents = (Calendar.current as NSCalendar).components([.era, .year, .month, .day, .hour, .minute], from: date)
        let calendarComponents = (Calendar.current as NSCalendar).components([.era, .year, .month, .day, .hour, .minute], from: self)
        return dateCalendarComponents.year == calendarComponents.year
            && dateCalendarComponents.month == calendarComponents.month
            && dateCalendarComponents.day == calendarComponents.day
    }
    
    var isToday: Bool {
        return isSameDayAsDate(Date())
    }
    
    var isTomorrow: Bool {
        return isSameDayAsDate(Date().addingTimeInterval(60*60*24))
    }
    
    var isYesterDay: Bool {
        return isSameDayAsDate(Date().addingTimeInterval(-60*60*24))
    }
    
    func format(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func formatWithStyle(_ dataStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateStyle = dataStyle
        return dateFormatter.string(from: self)
    }
    
    var readableString: String {
        let time = self.format("HH:mm")
        
        if self.isToday {
            return "Today \(time)"
        } else if self.isTomorrow {
            return "Tomorrow \(time)"
        } else if self.isYesterDay {
            return "Yesterday \(time)"
        }
        
        let day = Int(self.format("dd"))!
        let month = self.format("MMMM")
        let year = self.format("yyyy")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        if year == Date().format("yyyy") {
            return "\(day) \(month) \(time)"
        } else {
            return "\(day) \(month) \(time), \(year)"
        }
    }
}

class Json{
    let value:AnyObject?
    var string:String?  { return value as? String}
    var num:Int?  { return value as? Int}
    public init(object:Any?){
        print(object)
        value = object as AnyObject?
    }
    public subscript(_ index: Int) -> Json {
        if let data = value,
            let result = data[index]{
            return Json(object: result)
        }
        return Json(object: nil)
    }
    public subscript(_ index: String) -> Json {
        if let data = value,
            let result = data[index]{
            return Json(object: result)
        }
        return Json(object: nil)
    }
}
