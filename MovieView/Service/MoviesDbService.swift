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
typealias failure = (_ error: Error) -> Void

class MoviesDbService {

    func fetchMovies(onSuccess: @escaping response, onError: @escaping failure) {

        var APIBaseURL: String = ""
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let plistDict = NSDictionary(contentsOfFile: path)
            APIBaseURL = plistDict!["APIBaseURL"] as! String
        }
        let url = URL(string: APIBaseURL)!

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                onError(error)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                onSuccess(self.processResponse(response: dataDictionary))
            }
        }
        task.resume()
    }


    private func processResponse(response: NSDictionary) -> [MoviesModel] {

        var movies = [MoviesModel]()

        if response.count > 0 {
            let data = response["results"] as! [NSDictionary]

            for item in data {
                do {
                    let movie: MoviesModel = try unbox(dictionary: item as! UnboxableDictionary)
                    movies.append(movie)
                } catch {
                    print("Unable to Initialize Movies Data")
                }
            }
        }
        return movies
    }
    
}
