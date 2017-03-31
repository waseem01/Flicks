//
//  MoviesModel.swift
//  MovieView
//
//  Created by Mohammed on 3/29/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import Unbox

struct MoviesModel: Unboxable {

    let title: String
    let overview: String
    let posterpath: String
    let backdroppath: String
    let posterUrl: URL
    let backdropUrl: URL
    let releaseDate: String
    var rating: String
    var backgroundImage: UIImage?

    init(unboxer: Unboxer) throws {
        self.title = try unboxer.unbox(key: "title")
        self.overview = try unboxer.unbox(key: "overview")
        let baseUrl = "http://image.tmdb.org/t/p/"
        self.posterpath = try unboxer.unbox(key: "poster_path")
        self.backdroppath = try unboxer.unbox(key: "backdrop_path")
        self.posterUrl = URL(string: baseUrl + "w500/" + posterpath)!
        self.backdropUrl = URL(string: baseUrl + "w320/" +  backdroppath)!
        self.releaseDate = try unboxer.unbox(key: "release_date")
        self.rating = try unboxer.unbox(key: "vote_average")
    }

    var posterImage: UIImage? {

        get {
            return backgroundImage
        }

        set(newImage) {
            backgroundImage = newImage
        }
    }
}
