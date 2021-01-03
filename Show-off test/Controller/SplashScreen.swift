//
//  ViewController.swift
//  Show-off test
//
//  Created by Sela Shabtai on 28/12/2020.
//

import UIKit

class SplashScreen: UIViewController {
    
    @IBOutlet var MoveToListScreenLabel: UIButton!
    
    var movieManager = MovieManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        MoveToListScreenLabel.isEnabled = false
        movieManager.deleteData();
        movieManager.saveItems();
    }
    
    @IBAction func FetchMovies(_ sender: UIButton)
    {
        DispatchQueue.main.async {
            self.MoveToListScreenLabel.isEnabled = false;
            self.movieManager.deleteData();
            self.movieManager.saveItems();
            self.movieManager.fetchMovies();
            self.MoveToListScreenLabel.isEnabled = true;
        }
        
    }
    
    
}

