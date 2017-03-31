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

    var movie: MoviesModel?

    convenience init(movie: MoviesModel) {
        self.init()
        self.movie = movie
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setBackgroundView()
        view.addSubview(scrollView)
    }

    //MARK Private methods
    private func setBackgroundView() {
//        DispatchQueue.global().async {
//            let data = try? Data(contentsOf: (self.movie?.posterUrl)!)
//            DispatchQueue.main.async {
//                let image = UIImage(data: data!)!
//                let imageView = UIImageView(frame: self.view.frame)
//                imageView.image = image
//                self.view.addSubview(imageView)
//                self.view.sendSubview(toBack: imageView)
//            }
//        }
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = movie?.backgroundImage
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }

    //MARK: Properties
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRect(x: 20, y: 300, width: 280, height: 200))
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.addSubview(self.containerView)
        view.contentSize = self.containerView.bounds.size
        return view
    }()

    private lazy var containerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 280, height: 200))
        view.backgroundColor = .darkGray
        view.alpha = 0.75
        view.addSubview(self.movieTitleLabel)
        view.addSubview(self.movieReleaseDate)
        view.addSubview(self.movieRating)
        view.addSubview(self.movieInfoLabel)
        return view
    }()

    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 260, height: 40))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.text = self.movie?.title
        return label
    }()

    private lazy var movieReleaseDate: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 30, width: 260, height: 40))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 10.0)
        label.text = "Date Released: " + (self.movie?.releaseDate)!
        return label
    }()

    private lazy var movieRating: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 50, width: 260, height: 40))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 10.0)
        label.text = "Rating: " + (self.movie?.rating)! + "/10"
        return label
    }()

    private lazy var movieInfoLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 25, width: 260, height: 180))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.text = self.movie?.overview
        return label
    }()
    
}
