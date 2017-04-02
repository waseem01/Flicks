//
//  MovieDetailsViewController.swift
//  MovieView
//
//  Created by Waseem Mohd on 3/29/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailsViewController: UIViewController {

    var movie: MoviesModel!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var movieInfo: UILabel!
    
    convenience init(movie: MoviesModel) {
        self.init()
        self.movie = movie
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    //MARK Private methods
    private func setupViews() {
        setBackgroundView()
        customizeNavBar()
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.contentSize = CGSize(width: containerView.frame.width, height: containerView.frame.height+5)
        scrollView.contentOffset = CGPoint(x: 0, y: -100)
        movieTitle.text = movie.title
        releaseDate.text = "Released: " + movie.releaseDate
        rating.text = "Rating: " + movie.rating
        movieInfo.text = movie.overview
        movieTitle.sizeToFit()
        releaseDate.sizeToFit()
        rating.sizeToFit()
        containerView.autoresizingMask = .flexibleHeight
    }

    private func customizeNavBar() {
        navigationItem.title = movie.title
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.topItem?.title = ""
            navigationBar.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)

            let shadow = NSShadow()
            shadow.shadowColor = UIColor.gray.withAlphaComponent(0.5)
            shadow.shadowOffset = CGSize(width: 2, height: 2)
            shadow.shadowBlurRadius = 4;
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22),
                NSForegroundColorAttributeName : UIColor.black,
                NSShadowAttributeName : shadow
            ]
        }
    }

    private func setBackgroundView() {
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = movie.backgroundImage
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
}
