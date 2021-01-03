//
//  MoviesData.swift
//  Show-off test
//
//  Created by Sela Shabtai on 29/12/2020.
//

import UIKit

struct MoviesData : Codable {
    
    let title : String;
    let releaseYear : Int;
    let rating : Double;
    let genre : [String];
    let image : String;
    
}

struct Results: Decodable {
    let movies: [MoviesData]
}
