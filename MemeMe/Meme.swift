//
//  Meme.swift
//  MemeMe
//
//  Created by Taylor Smith on 9/22/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String!
    var bottomText: String!
    var image: UIImage!
    var memedImage: UIImage!
    
    init(top: String, bottom: String, image: UIImage, memedImage: UIImage) {
        self.topText = top
        self.bottomText = bottom
        self.image = image
        self.memedImage = memedImage
    }
}