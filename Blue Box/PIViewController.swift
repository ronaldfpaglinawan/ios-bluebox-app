//
//  PIViewController.swift
//  Blue Box
//
//  Created by Ronald F. Paglinawan on 25/08/2016.
//  Copyright © 2016 Harrison Grierson. All rights reserved.
//

import UIKit

class PIViewController: UIViewController {

    @IBOutlet weak var pdfWebView: UIWebView!
    
    @IBAction func scan(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openWebsite(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string:"http://www.harrisongrierson.com/")!)
    }
    
    func loadPDF() {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            let url = Bundle.main.url(forResource: "P&ID and Hydraulic", withExtension:"pdf")
            
            DispatchQueue.main.async {
                self.pdfWebView.loadRequest(URLRequest(url: url!))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add the logo at the navigation bar
        let imageString = UIImage(named: "hg_logo_white")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageString
        navigationItem.titleView = imageView
        
        loadPDF()
    }
}
