//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Taylor Smith on 9/28/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    var applicationDelegate: AppDelegate!
    var memes: [Meme]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    }

    override func viewWillAppear(animated: Bool) {
        memes = applicationDelegate.memes
        tableView.reloadData()
        super.viewWillAppear(true)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applicationDelegate.memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeTableCell", forIndexPath: indexPath) as! MemeTableViewCell
        
        let meme = applicationDelegate.memes[indexPath.row]
        cell.label.text = meme.topText
        cell.memeImage.image = meme.memedImage

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("tableDetailsSegue", sender: self)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tableDetailsSegue" {
            if let vc = segue.destinationViewController as? MemeDetailsViewController {
                if let index = tableView.indexPathForSelectedRow?.row {
                    vc.image = memes[index].memedImage
                }
            }
        }
    }
}
