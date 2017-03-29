//
//  MoviesViewController.swift
//  MovieView
//
//  Created by Mohammed on 3/28/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit
import Unbox
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var movies: [MoviesModel]?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        activityIndicator.startAnimating()
        MoviesDbService().fetchMovies(onSuccess: { results -> Void in
            self.movies = results
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            self.tableView.reloadData()
        }, onError: { error -> Void in
            let alertViewController = UIAlertController(title: "Error!",
                                                        message: "Something bad happened.\nPlease try again later",
                                                        preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
        })
    }

//    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void)
//    {
//        completionHandler([UNNotificationPresentationOptions.Alert,UNNotificationPresentationOptions.Sound,UNNotificationPresentationOptions.Badge])
//    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies?[indexPath.row]
        cell.titleLabel.text = movie?.title
        cell.overviewLabel.text = movie?.overview
        cell.posterView.setImageWith((movie?.posterUrl)!)
        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(MovieDetailsViewController(movie: (movies?[indexPath.row])!), animated: true)
    }

    //MARK: Properties
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        return indicator
    }()
}
