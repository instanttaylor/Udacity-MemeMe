//
//  MemeDetailsViewController.swift
//  MemeMe
//
//  Created by Taylor Smith on 9/29/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {

    var image: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memeImage = image {
            imageView.image = memeImage
        }
    }

}
