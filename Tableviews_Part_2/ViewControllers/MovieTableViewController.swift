//
//  MovieTableViewController.swift
//  Tableviews_Part_2//
//  Created by Jason Gresh on 9/22/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

let movieViewTypes = ["MovieTableViewCell", "MovieTableViewCell2", "MovieTableViewCell3"]

class MovieTableViewController: UITableViewController {
    enum Century: Int { case twentieth, twentyFirst }
    enum Genre: Int {
        case animation
        case action
        case drama
    }
    
    internal var movieData: [Movie]?
    internal let rawMovieData: [[String : Any]] = movies
    
    var cellToDisplay = 0
    var cellIdentifier: String {
        get {
            return movieViewTypes[cellToDisplay]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movies"
        // 1. need to update our table for self-sizing cells
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200.0
        
        // converting from array of dictionaries
        // to an array of Movie structs
        var movieContainer: [Movie] = []
        for rawMovie in rawMovieData {
            movieContainer.append(Movie(from: rawMovie))
        }
        movieData = movieContainer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.navigationController!
        
        // 1. update our nav controller's tints and font
        if let navigationController: UINavigationController = self.navigationController {
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.barTintColor = UIColor.reelGoodGreen
            navigationController.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.white,
                NSFontAttributeName: UIFont.systemFont(ofSize: 24.0)
            ]
        }
        
        // 2. add a new bar button
        let menuBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "reel"),
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(menuBarButtonPressed))
        self.navigationItem.setLeftBarButton(menuBarButton, animated: false)
    }
    
    func menuBarButtonPressed() {
        switch self.cellToDisplay {
        case 2:
            self.cellToDisplay = 0
        default:
            self.cellToDisplay += 1
        }
        self.tableView.reloadData()
    }
    
    func handleBar() {
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let genre = Genre.init(rawValue: section),
            let data = byGenre(genre) else  {
                return 0
        }
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let genre = Genre.init(rawValue: indexPath.section),
            let data = byGenre(genre) else {
                return cell
        }
        
        if let movieCell: MovieTableViewCell = cell as? MovieTableViewCell {
            movieCell.movieTitleLabel.text = data[indexPath.row].title
            movieCell.movieSummaryLabel.text = data[indexPath.row].summary
            movieCell.moviePosterImageView.image = UIImage(named: data[indexPath.row].poster)
            
            if cellIdentifier == "MovieTableViewCell2" {
                movieCell.movieYearLabel.text = String(data[indexPath.row].year)
                movieCell.greenBar.backgroundColor = UIColor.reelGoodGreen
            }
            
            if cellIdentifier == "MovieTableViewCell3" {
                movieCell.movieCastLabel.text = ""
                for actor in data[indexPath.row].cast {
                    movieCell.movieCastLabel.text!.append("\(actor.firstName) \(actor.lastName)\n\n")
                }
                movieCell.greenContainer.backgroundColor = UIColor.reelGoodGreen
                
            }
            return movieCell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let genre = Genre.init(rawValue: section) else {
            return ""
        }
        switch genre {
        case .action:
            return "Action"
        case .animation:
            return "Animation"
        case .drama:
            return "Drama"
        }
    }
    
    // MARK: - Utility
    func by(_ c: Century) -> [Movie]? {
        let filter: (Movie) -> Bool
        switch c {
        case .twentieth:
            filter = { (a) -> Bool in
                a.year < 2001
            }
        case .twentyFirst:
            filter = { (a) -> Bool in
                a.year >= 2001
            }
        }
        // after filtering, sort
        let filtered = movieData?.filter(filter).sorted { $0.year < $1.year }
        return filtered
    }
    
    func byGenre(_ genre: Genre) -> [Movie]? {
        let filter: (Movie) -> Bool
        switch genre {
        case .action:
            filter = { (a) -> Bool in
                a.genre == "action"
            }
        case .animation:
            filter = { (a) -> Bool in
                a.genre == "animation"
            }
        case .drama:
            filter = { (a) -> Bool in
                a.genre == "drama"
            }
        }
        // after filtering, sort
        let filtered = movieData?.filter(filter).sorted { $0.year < $1.year }
        return filtered
    }
}
