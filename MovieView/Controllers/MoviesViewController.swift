//
//  MoviesViewController.swift
//  MovieView
//
//  Created by Mohammed on 3/28/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications
import UserNotificationsUI
import Unbox
import AFNetworking
import KRProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITabBarDelegate {
    let requestIdentifier = "NetworkError"

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
            if results.count > 0 {
                self.movies = results
                self.filteredMovies = results
                self.tableView.reloadData()
            }
        }, onError: { error -> Void in

            KRProgressHUD.dismiss()
            let content = UNMutableNotificationContent()
            content.title = "Network Error!"
            content.body = "Please pull down to refresh."
            content.sound = UNNotificationSound.default()

            if let path = Bundle.main.path(forResource: "Error", ofType: "png") {
                let url = URL(fileURLWithPath: path)
                do {
                    let attachment = try UNNotificationAttachment(identifier: "errorIcon", url: url, options: nil)
                    content.attachments = [attachment]
                } catch {
                    print("attachment not found.")
                }
            }

            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false)
            let request = UNNotificationRequest(identifier:self.requestIdentifier, content: content, trigger: trigger)

            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().add(request){(error) in
                if (error != nil){
                    //Do Something
                }
            }

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

extension MoviesViewController: UNUserNotificationCenterDelegate{

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification triggered")
        if notification.request.identifier == requestIdentifier{
            completionHandler( [.alert,.sound,.badge])
        }
    }
}
