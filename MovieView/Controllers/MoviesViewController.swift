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
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var errorIcon: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var movies:[MoviesModel] = []
    var filteredMovies:[MoviesModel] = []
    let pullToRefreshControl = UIRefreshControl()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bannerView.isHidden = true
        self.errorIcon.isHidden = true
        self.errorLabel.isHidden = true
        var frame = self.bannerView.frame
        frame.size = CGSize(width: self.bannerView.frame.width, height: 0)
        self.bannerView.frame = frame
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        KRProgressHUD.show(progressHUDStyle: .black, message: "Loading...")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?.first
        pullToRefreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
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
            delay: 0.5,
            options: .curveEaseOut,
            animations: {
                self.bannerView.frame.origin.y = -30
        },
            completion: { _ in
                self.bannerView.isHidden = true
                self.errorIcon.isHidden = true
                self.errorLabel.isHidden = true
                var frame = self.bannerView.frame
                frame.size = CGSize(width: self.bannerView.frame.width, height: 0)
                self.bannerView.frame = frame
        })
    }

    func showBannerMessage() {
        bannerView.isHidden = false
        errorIcon.isHidden = false
        errorLabel.isHidden = false
        self.bannerView.frame.origin.y = -30
        var frame = bannerView.frame
        frame.size = CGSize(width: bannerView.frame.width, height: 30)
        bannerView.frame = frame
        UIView.animate(
            withDuration: 0.7,
            delay: 0.5,
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

}
