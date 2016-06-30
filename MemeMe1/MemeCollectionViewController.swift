//
//  MemeCollectionViewController.swift
//  MemeMe2
//
//  Created by Damonique Thomas on 6/26/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        self.collectionView!.registerClass(CustomMemeCell.self,forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,withReuseIdentifier: "CustomMemeCell")
        self.tabBarController?.tabBar.hidden = false
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! CustomMemeCell
        let meme = memes[indexPath.item]
        cell.setText(meme.topText, bottomString: meme.bottomText)
        cell.setCellImage(meme.originalImage)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
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
