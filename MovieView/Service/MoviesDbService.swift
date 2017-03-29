//
//  MoviesDbService.swift
//  MovieView
//
//  Created by Mohammed on 3/29/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//
import Foundation
import UIKit
import Unbox

typealias response = (_ result: [MoviesModel]) -> Void
typealias failure = (_ error: NSError) -> Void

class MoviesDbService {

    var movies: [MoviesModel] = []

    func movieListing(onSuccess: @escaping response, onFailure: failure) {

        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed";
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?page=1&language=en-US&api_key=\(apiKey)")

        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in

            if error != nil {
                print("error=\(error)")
                return
            }

            do {
                if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    self.movies = self.processResponse(response: responseDictionary)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            onSuccess(self.movies)
        }
        task.resume()
    }


    func processResponse(response: NSDictionary) -> [MoviesModel] {

        var movies = [MoviesModel]()

        let data = response["results"] as! [NSDictionary]

        for item in data {
            do {
                let movie: MoviesModel = try unbox(dictionary: item as! UnboxableDictionary)
                movies.append(movie)
            } catch {
                print("Unable to Initialize Movies Data")
            }
        }
        return movies
    }
}
