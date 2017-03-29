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
    let imageUrl: URL

    init(unboxer: Unboxer) throws {
        self.title = try unboxer.unbox(key: "title")
        self.overview = try unboxer.unbox(key: "overview")
        let baseUrl = "http://image.tmdb.org/t/p/w500/"
        self.posterpath = try unboxer.unbox(key: "poster_path")
        self.imageUrl = URL(string: baseUrl +  posterpath)!
    }
}
