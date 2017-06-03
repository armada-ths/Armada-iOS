//
//  DetailedNewsTableViewController.swift
//  Armada
//
//  Created by Ola Roos on 30/05/17.
//

import UIKit

class DetailedNewsTableViewController: UIViewController, UIScrollViewDelegate {
    
    //@IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var dateLabel: UILabel!
    //@IBOutlet weak var contentTextView: UITextView!
    //@IBOutlet weak var imageView: UIImageView!
    
    var news: News!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollSubView: UIView!
    
    var newTopFrame: CGRect!
    var newScrollFrame: CGRect!
    
    var scale: CGFloat!
    var previousOffset: CGFloat!
    var defaultTopHeight: CGFloat!
    
    var defaultScrollHeight: CGFloat!
    var maxScrollOffset: CGFloat!
    var maxScale: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        previousOffset = 0
        //set topview cover-speed
        scale = 4
        defaultTopHeight = topView.frame.height
        defaultScrollHeight = scrollView.frame.height
        maxScrollOffset = defaultTopHeight + defaultScrollHeight
        maxScale = (scrollSubView.frame.height - (defaultTopHeight + defaultScrollHeight)) / defaultTopHeight
        if (scale > maxScale){
            scale = maxScale
        }
        //titleLabel.text = news.title
        //dateLabel.text = news.publishedDate.formatWithStyle(.long)
        //contentTextView.attributedText = news.content.attributedHtmlString ?? NSAttributedString(string: news.content)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        defaultScrollHeight = scrollView.frame.height
        print("defaultScrollHeight")
        print(defaultScrollHeight)
        print("defaultTopHeight")
        print(defaultTopHeight)
        print("maxScrollOffset")
        print(maxScrollOffset)        
    }
    
    func updateFrames(_ newOffset: CGFloat){
        print(newOffset)
        print(previousOffset)
        print(scale)
        
        let diff: CGFloat = (newOffset - previousOffset) / scale
        if (newOffset / scale <= defaultTopHeight){
            newTopFrame = CGRect(x: topView.frame.origin.x, y: topView.frame.origin.y, width: topView.frame.width, height: topView.frame.height - diff)
            newScrollFrame = CGRect(x: scrollView.frame.origin.x, y: scrollView.frame.origin.y - diff, width: scrollView.frame.width, height: scrollView.frame.height + diff)
            previousOffset = newOffset
        } else {
            newTopFrame = CGRect(x: topView.frame.origin.x, y: topView.frame.origin.y, width: topView.frame.width, height: 0)
            // if there is space above container, it should be added to y here
            newScrollFrame = CGRect(x: scrollView.frame.origin.x, y: 20, width: scrollView.frame.width, height: maxScrollOffset)
            previousOffset = defaultTopHeight * scale
        }
        topView.frame = newTopFrame
        scrollView.frame = newScrollFrame
        print(defaultTopHeight)
        print(maxScrollOffset)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateFrames(scrollView.contentOffset.y)
    }

    

}
