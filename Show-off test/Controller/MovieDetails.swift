//
//  MovieDetails.swift
//  Show-off test
//
//  Created by Sela Shabtai on 30/12/2020.
//

import UIKit

class MovieDetails : UIViewController {
    
    var movieTitle: String?
    var movieContent: UIImageView?
    var movieYearRelease: String?
    var movieGenres :  String?
    var movieRating : String?
    var pic: UIImage?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var yearReleased: UILabel!
    @IBOutlet var genre: UILabel!
    @IBOutlet var rating: UILabel!
    
    override func viewDidLoad() {
        DispatchQueue.main.async {
            self.titleLabel.text = self.movieTitle;
            self.yearReleased.text = self.self.movieYearRelease;
            self.genre.text = self.movieGenres;
            self.rating.text = self.movieRating;
            self.movieImage.image = self.pic;
        }
        
    }
    
}
