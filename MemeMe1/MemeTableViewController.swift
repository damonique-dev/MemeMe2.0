//
//  MemeTableViewController.swift
//  MemeMe2
//
//  Created by Damonique Thomas on 6/26/16.
//  Copyright Â© 2016 Damonique Thomas. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = false
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")! as UITableViewCell
        let meme = memes[indexPath.row]
        cell.textLabel!.text = meme.topText + " " + meme.bottomText
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        performSegueWithIdentifier("memeDetail", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "memeDetail"{
            let controller = segue.destinationViewController as! MemeDetailViewController
            let index = sender as! NSIndexPath
            controller.meme = memes[index.row]
        }
    }
}