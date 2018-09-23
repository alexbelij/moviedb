//
//  MovieDetailsViewController.swift
//  moviedb
//
//  Created by Matic on 04/09/2018.
//  Copyright © 2018 Matic. All rights reserved.
//

import UIKit
import SDWebImage

class MovieDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    var movieTitle = String()
    var releaseDate = String()
    var plot = String()
    var movieID = Int()
    var actorImages = [String]()
    var actorNames = [String]()
    var movieGenres = [String]()
    var joined = String()
    var hours = Int()
    var minutes = Int()
    var runtime = String()

    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        movieTitleLabel.text = movieTitle
        releaseDateLabel.text = releaseDate
        movieOverviewLabel.text = plot
        getMovieCast(for: movieID)
        getMovieDetails(for: movieID)
    }

    // API Call to get movie credits
    func getMovieCast(for id: Int) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=9d2bff12ed955c7f1f74b83187f188ae&language=en-US&page=1")
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            guard let data = data else {
                print("Error")
                return
            }
            guard let movieCast = try? JSONDecoder().decode(MovieCast.self, from: data) else {
                print("Error")
                return
            }
            for i in 0...movieCast.cast.count - 1 {
                self.actorImages.append("http://image.tmdb.org/t/p/w500/\(movieCast.cast[i].profile_path ?? "error")")
                self.actorNames.append(movieCast.cast[i].name)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.resume()
    }

    // API Call to get various movie details such as runtime, tagline, etc.
    func getMovieDetails(for id: Int) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=9d2bff12ed955c7f1f74b83187f188ae&language=en-US&page=1")
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            guard let data = data else {
                print ("Error")
                return
            }
            guard let movieDetails = try? JSONDecoder().decode(MovieDetails.self, from: data) else {
                print("Error")
                return
            }
            for i in 0...movieDetails.genres.count - 1 {
                self.movieGenres.append(movieDetails.genres[i].name)
            }
            self.joined = self.movieGenres.joined(separator: ", ")
            self.hours = movieDetails.runtime / 60
            self.minutes = movieDetails.runtime % 60
            self.runtime = "\(self.hours)h \(self.minutes)m"
            DispatchQueue.main.async {
                self.genresLabel.text = self.joined
                self.runtimeLabel.text = self.runtime
                self.taglineLabel.text = movieDetails.tagline
            }
        }.resume()
    }

    // Numbers of items in UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actorNames.count
    }

    // Cell For Item at IndexPath - here we set the images in UICollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let castCell = collectionView.dequeueReusableCell(withReuseIdentifier: "castCell", for: indexPath) as! CastCollectionViewCell
        castCell.layer.borderWidth = 0.7
        castCell.layer.borderColor = UIColor.white.cgColor

        if(self.actorImages[indexPath.item] == "http://image.tmdb.org/t/p/w500/error") {
            let url = URL(string: "https://www.csuohio.edu/sites/default/files/1024px-Placeholder_no_text_svg.png")
            castCell.profilePic.sd_setImage(with: url)
        } else {
            let url = URL(string: self.actorImages[indexPath.item])
            castCell.profilePic.sd_setImage(with: url)
        }
        castCell.actorName.text = actorNames[indexPath.item]

        return castCell
    }
}
