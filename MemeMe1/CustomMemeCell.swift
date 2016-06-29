//
//  CustomMemeCell.swift
//  MemeMe2
//
//  Created by Damonique Thomas on 6/26/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import UIKit

class CustomMemeCell: UICollectionViewCell, UITextFieldDelegate {
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    @IBOutlet var memeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLabelFormat(topLabel)
        setUpLabelFormat(bottomLabel)
    }
    
    func setUpLabelFormat(label:UILabel){
        label.textAlignment = .Center
        label.textColor = UIColor(white:1.0, alpha:1.0)
    }

    func setText(topString:String, bottomString: String){
        topLabel.text = topString
        bottomLabel.text = bottomString
    }

    func setCellImage(image:UIImage){
        memeImage.image = image
    }

}
