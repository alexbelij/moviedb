//
//  FirstViewController.swift
//  moviedb
//
//  Created by Matic on 01/09/2018.
//  Copyright © 2018 Matic. All rights reserved.
//

import UIKit
import SDWebImage

class FirstViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // Outlets
    @IBOutlet weak var collectionViewOutlet: UICollectionView!

    // Variables
    var imgUrls = [String]()
    var movieIds = [Int]()
    var movieTitles = [String]()
    var releaseDateArray = [String]()
    var plotArray = [String]()
    var selectedIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchData(numberOfPages: 10)
    }

    //Fetch the data from TMDB
    func fetchData(numberOfPages: Int) -> Void {
        for pageNumber in 1...numberOfPages {
            let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=9d2bff12ed955c7f1f74b83187f188ae&language=en-US&page=\(pageNumber)")!
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                guard let data = data else {
                    print("Error")
                    return
                }
                guard let movieData = try? JSONDecoder().decode(MovieDataStruct.self, from: data) else {
                    print("Cannot decode data.")
                    return
                }
                // Fill in the arrays (because there are 20 elements on each page)
                for i in 0...19 {
                    self.imgUrls.append("http://image.tmdb.org/t/p/w500/\(movieData.results[i].poster_path)")
                    self.movieIds.append(movieData.results[i].id)
                    self.movieTitles.append(movieData.results[i].title)
                    self.releaseDateArray.append(String(movieData.results[i].release_date.prefix(4)))
                    self.plotArray.append(movieData.results[i].overview)
                }
                DispatchQueue.main.async {
                    self.collectionViewOutlet.reloadData()
                }
            }.resume()
        }
    }

    // Number of items in UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieIds.count
    }

    // Cell properties and content in UICollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.layer.borderWidth = 0.7
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 13

        let url = URL(string: self.imgUrls[indexPath.item])
        cell.moviePoster.sd_setImage(with: url)

        return cell
    }

    // UICollectionView Did SelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        performSegue(withIdentifier: "toDetailsSegue", sender: self)
    }

    // Section Header Config
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let reusableCollectionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionReusableView", for: indexPath) as! CollectionReusableView
        reusableCollectionView.categoryTitleLabel.text = "Popular movies"
        return reusableCollectionView
    }

    // Prepare for segue / pass data to the another view controller - MovieDetailsViewController.swift
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsScreen = segue.destination as! MovieDetailsViewController
        detailsScreen.movieTitle = movieTitles[selectedIndex]
        detailsScreen.releaseDate = releaseDateArray[selectedIndex]
        detailsScreen.plot = plotArray[selectedIndex]
        detailsScreen.movieID = movieIds[selectedIndex]
    }
}
