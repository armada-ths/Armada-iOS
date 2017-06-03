//
//  ScrollTextViewController.swift
//  Armada
//
//  Created by Ola Roos on 02/06/17.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class ScrollTestViewController: UIViewController, UIScrollViewDelegate {
    
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
    var disableScroll: Bool!
    
    var news: News!

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scale = 4
        disableScroll = false
        previousOffset = 0
        newsImageView.loadImageFromUrl(news.imageUrl)
        titleLabel.text = news.title
        dateLabel.text = news.publishedDate.formatWithStyle(.long)
        contentTextView.attributedText = news.content.attributedHtmlString ?? NSAttributedString(string: news.content)
    }

    override func viewDidAppear(_ animated: Bool) {
        // Variables take different values if set in viewDidLoad()        
        defaultTopHeight = topView.frame.height
        defaultScrollHeight = scrollView.frame.height
        maxScrollOffset = defaultTopHeight + defaultScrollHeight
        maxScale = (scrollSubView.frame.height - (defaultTopHeight + defaultScrollHeight)) / defaultTopHeight
        print(maxScale)
        if (maxScale < 1){
            disableScroll = true
        } else if (scale > maxScale){
            scale = maxScale
        }
    }
    func updateFrames(_ newOffset: CGFloat){
        let diff: CGFloat = (newOffset - previousOffset) / scale
        if (newOffset / scale <= defaultTopHeight){
            newTopFrame = CGRect(x: topView.frame.origin.x, y: topView.frame.origin.y, width: topView.frame.width, height: topView.frame.height - diff)
            newScrollFrame = CGRect(x: scrollView.frame.origin.x, y: scrollView.frame.origin.y - diff, width: scrollView.frame.width, height: scrollView.frame.height + diff)
            previousOffset = newOffset
        } else {
            newTopFrame = CGRect(x: topView.frame.origin.x, y: topView.frame.origin.y, width: topView.frame.width, height: 0)
            newScrollFrame = CGRect(x: scrollView.frame.origin.x, y: 0, width: scrollView.frame.width, height: maxScrollOffset)
            previousOffset = defaultTopHeight * scale
        }
        topView.frame = newTopFrame
        scrollView.frame = newScrollFrame
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (disableScroll == false){
                updateFrames(scrollView.contentOffset.y)
        }
        
    }
}

