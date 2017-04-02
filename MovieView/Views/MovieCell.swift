//
//  MovieCell.swift
//  MovieView
//
//  Created by Mohammed on 3/29/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!

    override func layoutSubviews() {
        overviewLabel.sizeToFit()
    }
}
