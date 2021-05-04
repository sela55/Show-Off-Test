//
//  MovieManager.swift
//  Show-off test
//
//  Created by Sela Shabtai on 28/12/2020.
//

import UIKit
import CoreData

class MovieManager : ObservableObject {
    let moviesURL = "https://api.androidhive.info/json/movies.json";
    var moviesArray = [Entity]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    var movieImage : UIImageView?;
    var moviesData = [MoviesData]()
    
    func fetchMovies() {
        performRequest(urlString: moviesURL)
    }
    func performRequest(urlString : String) {
        if let safeURL = URL(string: urlString) {
            let session = URLSession(configuration: .default);
            let task = session.dataTask(with: safeURL) { (data, response, error ) in
                if let theresAnError = error {
                    print(theresAnError)
                    return
                }
                if let safeData = data {
                    self.parseJson(movieCatalogData: safeData)
                    self.saveItems();
                }
            }
            task.resume();
        }
    }
    
    func parseJson(movieCatalogData : Data){
        let decoder = JSONDecoder();
        do{
            let decodedData = try decoder.decode([MoviesData].self, from: movieCatalogData);
            decodedData.forEach { movie in
                let movie = MoviesData(title: movie.title, releaseYear: movie.releaseYear, rating: movie.rating, genre: movie.genre , image: movie.image);
                let movieToCoreData = Entity(context: self.context);
                movieToCoreData.title = movie.title;
                movieToCoreData.releaseYear = Int16(movie.releaseYear);
                movieToCoreData.rating = movie.rating;
                movieToCoreData.genre = movie.genre;
                movieToCoreData.image = movie.image;
                movieToCoreData.section = "Movies"
                self.moviesArray.append(movieToCoreData);
                self.saveItems();
                self.moviesData.append(movie);
            }
        }
        catch {
            print(error);
        }
        
    }
    

    func saveItems() {
        do {
             try context.save()
        } catch {
            print("Error decoding item array, \(error)")
        }
    }
    
    func deleteData() {
        DispatchQueue.main.async {
            let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
            let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(fetchRequest)
                for managedObject in results {
                    if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                        context.delete(managedObjectData)
                    }
                }
            } catch let error as NSError {
                print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
            }

        }
    }
    
   
}
