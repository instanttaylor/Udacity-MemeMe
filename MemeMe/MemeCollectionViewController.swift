//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Taylor Smith on 9/28/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes = [Meme]()
    var applicationDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFlowLayout()
        applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        refreshMemes()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshMemes()
        collectionView?.reloadData()
        super.viewWillAppear(true)
    }
    
    func setFlowLayout() {
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }

    func refreshMemes() {
        memes = applicationDelegate.memes
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "collectionDetailsSegue" {
            if let indexPaths = collectionView?.indexPathsForSelectedItems() {
                let indexPath = indexPaths[0]
                let vc = segue.destinationViewController as? MemeDetailsViewController
                vc!.image = memes[indexPath.item].memedImage
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.imageView.image = meme.memedImage
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("collectionDetailsSegue", sender: self)
    }
}
