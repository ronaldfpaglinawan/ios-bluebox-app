//
//  AboutViewController.swift
//  Blue Box
//
//  Created by Ronald F. Paglinawan on 25/08/2016.
//  Copyright © 2016 Harrison Grierson. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var qrButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()       
        Utility().setRoundedButton(qrButton, radius: 7.0, borderWidth: 3.0, borderColor: UIColor.black)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
}
