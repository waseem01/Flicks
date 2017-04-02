//
//  MoviesViewController.swift
//  MovieView
//
//  Created by Mohammed on 3/28/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit
import Foundation
import Unbox
import AFNetworking
import KRProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITabBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var tabBar: UITabBar!

    var movies:[MoviesModel] = []
    var filteredMovies:[MoviesModel] = []
    let pullToRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        KRProgressHUD.show(progressHUDStyle: .black, message: "Loading...")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?.first
        pullToRefreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        pullToRefreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        tableView.insertSubview(pullToRefreshControl, at: 0)
        fetchMovies()
    }

    //MARK: Private methods
    @objc private func pullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
        pullToRefreshControl.endRefreshing()
    }

    private func fetchMovies() {
        MoviesDbService().fetchMovies(onSuccess: { results -> Void in
            KRProgressHUD.dismiss()
            self.hideBannerMessage()
            if results.count > 0 {
                self.movies = results
                self.filteredMovies = results
                self.tableView.reloadData()
            }
        }, onError: { error -> Void in
            KRProgressHUD.dismiss()
            self.showBannerMessage()
        })
    }

    private func hideBannerMessage() {
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.bannerView.frame.origin.y = -30
        },
            completion: { _ in
        })
    }

    func showBannerMessage() {
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.bannerView.frame.origin.y = 0
        },
            completion: { _ in
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movieDetailsController = segue.destination as! MovieDetailsViewController
        let cell = sender as! MovieCell
        let indexPath = tableView.indexPath(for: cell)
        var movie = filteredMovies[(indexPath?.row)!]
        movie.posterImage = cell.posterView.image!
        movieDetailsController.movie = movie
    }

    //MARK: UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter { movie in movie.title.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = filteredMovies[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.overviewLabel.text = movie.overview
        cell.posterView.setImageWith((movie.posterUrl))
        return cell;
    }

    //MARK: UITabBarDelegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (tabBar.items?.first?.isEqual(item))! {
            KRProgressHUD.show(progressHUDStyle: .black, message: "Loading...")
            filteredMovies = movies
            tableView.reloadData()
            KRProgressHUD.dismiss()
        } else {
            KRProgressHUD.show(progressHUDStyle: .black, message: "Loading...")
            filteredMovies = movies.filter { movie in ((movie.rating as NSString).floatValue > 7) }
            tableView.reloadData()
            KRProgressHUD.dismiss()
        }
    }

    //MARK: Lazyvars
    private lazy var bannerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: -30, width: self.tableView.frame.width, height: 30))
        view.backgroundColor = UIColor.black
        view.alpha = 0.9
        view.addSubview(self.errorImageView)
        view.addSubview(self.bannerLabel)
        self.tableView.addSubview(view)
        return view
    }()

    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: self.tableView.frame.width/3-20, y: 5, width: 20, height: 20))
        imageView.image = UIImage(named: "Error")
        return imageView
    }()

    private lazy var bannerLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: self.tableView.frame.width/3+10, y: 5, width: self.tableView.frame.width, height: 20))
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.text = "Network Error"
        return label
    }()
    
}
