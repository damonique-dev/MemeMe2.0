//
//  MemeDetailViewController.swift
//  MemeMe2
//
//  Created by Damonique Thomas on 6/26/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme?
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let meme = meme {
            imageView.image = meme.memedImage
        }
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(MemeDetailViewController.editMeme(_:)))
        self.navigationItem.rightBarButtonItem = editButton
        self.tabBarController?.tabBar.hidden = true
    }

    func editMeme(sender: AnyObject) {
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("createMemeVC")
        let controller = object as! CreateMemeViewController
        controller.meme = meme
        navigationController!.pushViewController(controller, animated: true)
    }
}
