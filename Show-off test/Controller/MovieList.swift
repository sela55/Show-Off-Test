//
//  MovieList.swift
//  Show-off test
//
//  Created by Sela Shabtai on 29/12/2020.
//

import UIKit
import CoreData



class MovieList: UITableViewController
{
    var chosenIndexPath : Int?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    var enititiesArray = [Entity]();
    var QRArray = [QRCaption]()
    
    var dataFetchedResultsController : NSFetchedResultsController<Entity>!;
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        DispatchQueue.global(qos: .userInitiated).sync {
            self.loadMovies();
            self.tableView.reloadData()
        }
    }
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30;
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let frc = dataFetchedResultsController {
            return frc.sections!.count;
        }
        
        return 0;
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = dataFetchedResultsController.sections?[section];
        return sectionInfo?.name;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.dataFetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieItemCell", for: indexPath)
        let item = dataFetchedResultsController.object(at: indexPath);
        cell.textLabel?.text = item.title;
        return cell;
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataFetchedResultsController.object(at: indexPath);
        if item.section == "Movies" {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToDetails", sender: self);
                self.chosenIndexPath = indexPath.row
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            let destinationVC = segue.destination as! MovieDetails;
            var data : Data?
            var allGenres = ""
            if let safeIndexpath = tableView.indexPathForSelectedRow {
                DispatchQueue.global(qos: .userInitiated).async {
                    let imageURL:URL=URL(string: self.enititiesArray[safeIndexpath.row].image ?? "nothing no show")!
                    data = try? Data(contentsOf: imageURL)
                }
                DispatchQueue.main.async {
                    while data == nil {
                    }
                    destinationVC.pic = UIImage(data: data!);
                }
                if let safeGenres = self.enititiesArray[safeIndexpath.row].genre {
                    for genre in safeGenres {
                        allGenres.append(genre)
                        allGenres.append(",")
                    }
                }
                destinationVC.movieGenres = allGenres;
                destinationVC.movieRating = String(self.enititiesArray[safeIndexpath.row].rating)
                destinationVC.movieTitle = self.enititiesArray[safeIndexpath.row].title;
                destinationVC.movieYearRelease = String(self.enititiesArray[safeIndexpath.row].releaseYear);
            }
            
        }
    }
    
    //MARK: - Load and save movies and qr codes from core data
    
    func loadMovies() {
        let request : NSFetchRequest<Entity> = Entity.fetchRequest();
        let sort = NSSortDescriptor(key: "releaseYear", ascending: false);
        request.sortDescriptors = [sort];
        self.dataFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: #keyPath(Entity.section), cacheName: nil);
        
        do{
            self.enititiesArray = try self.context.fetch(request);
            try self.dataFetchedResultsController.performFetch()
            
        } catch {
            print("Error fetching data from context \(error)");
        }
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error decoding item array, \(error)")
        }
    }
    
    
    
    
    //MARK: - Go to QR Page
    
    @IBAction func addQRButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToScanQR", sender: self)
    }
    
    
}
