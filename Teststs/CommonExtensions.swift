import UIKit

extension NSUserDefaults {
    subscript(key: String) -> AnyObject? {
        get {
            return objectForKey(key)
        }
        set {
            setObject(newValue, forKey: key)
        }
    }
}


extension UITableViewController {
    
    func showEmptyMessage(show: Bool, message: String) {
        if show {
            let label = UILabel(frame: CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
            label.font = UIFont.systemFontOfSize(30)
            label.text = message
            label.numberOfLines = 2
            label.textAlignment = .Center
            label.sizeToFit()
            label.textColor = UIColor.lightGrayColor()
            tableView.backgroundView = label
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        }
    }
    
    func deselectSelectedCell() {
        if let indexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
    func loadImageFromUrl(url: String, callback:(UIImage? -> ())? = nil) {
        if let url = NSURL(string: url) {
            _ArmadaApi.getData(url) {
                switch $0 {
                case .Success(let data):
                    let image = UIImage(data: data)
                    let operation = NSBlockOperation() {
                        UIView.transitionWithView(self, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                            self.image = image
                        }, completion: nil)
                        callback?(image)
                    }
                    operation.queuePriority = .VeryLow
                    NSOperationQueue.mainQueue().addOperation(operation)
                case .Error(let error):
                    self.image = nil
                    callback?(nil)
                    print(error)
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
    var start = NSDate()
    
    init() {}
    
    func print(description: String) {
        Swift.print("\(description) \(Int(NSDate().timeIntervalSinceDate(start)*1000))ms")
        start = NSDate()
    }
}
extension String{
    var attributedHtmlString: NSAttributedString?{
        let html = "<p>" + self + "</p>" + "<style>p { font-family: \"helvetica neue\"; font-weight: 300; font-size: 18px; padding: 0; margin: 0; color: #4c4c4c; line-height: 25px;  }</style>"
        let data = (html).dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: false)
        if let data = data{
            return try? NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        }
        return nil
    }
    
    var httpUrl: NSURL? {
        let httpPrefix = "http"
        return NSURL(string: (hasPrefix(httpPrefix) ? "" : httpPrefix + "://") + stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
    }
}


extension NSDate {
    
    func isSameDayAsDate(date: NSDate) -> Bool {
        let dateCalendarComponents = NSCalendar.currentCalendar().components([.Era, .Year, .Month, .Day, .Hour, .Minute], fromDate: date)
        let calendarComponents = NSCalendar.currentCalendar().components([.Era, .Year, .Month, .Day, .Hour, .Minute], fromDate: self)
        return dateCalendarComponents.year == calendarComponents.year
            && dateCalendarComponents.month == calendarComponents.month
            && dateCalendarComponents.day == calendarComponents.day
    }
    
    var isToday: Bool {
        return isSameDayAsDate(NSDate())
    }
    
    
    var isTomorrow: Bool {
        return isSameDayAsDate(NSDate().dateByAddingTimeInterval(60*60*24))
    }
    
    var isYesterDay: Bool {
        return isSameDayAsDate(NSDate().dateByAddingTimeInterval(-60*60*24))
    }
    
    func format(format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.systemTimeZone()
        dateFormatter.locale = NSLocale(localeIdentifier: "en")
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
    
    func formatWithStyle(dataStyle: NSDateFormatterStyle) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.systemTimeZone()
        dateFormatter.locale = NSLocale(localeIdentifier: "en")
        dateFormatter.dateStyle = dataStyle
        return dateFormatter.stringFromDate(self)
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
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        if year == NSDate().format("yyyy") {
            return "\(day) \(month) \(time)"
        } else {
            return "\(day) \(month) \(time), \(year)"
        }
    }
}