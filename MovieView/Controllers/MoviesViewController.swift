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

        MoviesDbService().movieListing(onSuccess: { results -> Void in
            self.movies = results
            self.tableView.reloadData()
        }, onFailure: { error -> Void in
            let alertViewController = UIAlertController(title: "Error!",
                                                        message: "Something bad happened.\nPlease try again later",
                                                        preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
        })
    }

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
        cell.posterView.setImageWith((movie?.imageUrl)!)
        return cell;
    }
}
