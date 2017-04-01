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
        movieInfo.sizeToFit()

    }

    private func setBackgroundView() {
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = movie.backgroundImage
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
}
