//
//  SecondViewController.swift
//  moviedb
//
//  Created by Matic on 01/09/2018.
//  Copyright © 2018 Matic. All rights reserved.
//

import UIKit
import SDWebImage

class SecondViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {


    @IBOutlet weak var collectionViewOutlet: UICollectionView!


    var imgUrls = [String]()
    var tvIds = [Int]()
    var tvTitles = [String]()
    var releaseDateArray = [String]()
    var plotArray = [String]()
    var selectedIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchData(numberOfPages: 10)
    }

    func fetchData(numberOfPages: Int) -> Void {
        for pageNumber in 1...numberOfPages {
            let url = URL(string: "https://api.themoviedb.org/3/tv/popular?api_key=9d2bff12ed955c7f1f74b83187f188ae&language=en-US&page=\(pageNumber)")!
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                guard let data = data else {
                    print("Error")
                    return
                }
                guard let tvData = try? JSONDecoder().decode(TVDataStruct.self, from: data) else {
                    print("Cannot decode data.")
                    return
                }
                // Fill in the arrays (goes from 0 to 19, because there are 20 elements on each page)
                for i in 0...19 {
                    self.imgUrls.append("http://image.tmdb.org/t/p/w500/\(tvData.results[i].poster_path)")
                    self.tvIds.append(tvData.results[i].id)
                    self.tvTitles.append(tvData.results[i].original_name)
                    self.releaseDateArray.append(String(tvData.results[i].first_air_date.prefix(4)))
                    self.plotArray.append(tvData.results[i].overview)
                }
                DispatchQueue.main.async {
                    self.collectionViewOutlet.reloadData()
                }
            }.resume()
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvIds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TVCell

        cell.layer.borderWidth = 0.7
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 13

        let url = URL(string: self.imgUrls[indexPath.item])
        cell.TVPoster.sd_setImage(with: url)

        return cell
    }

    // UICollectionView Did SelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        performSegue(withIdentifier: "toTvDetailsSegue", sender: self)
        print(self.tvIds[indexPath.item])
    }

    // Section Header Config
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let reusableCollectionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TVReusableView", for: indexPath) as! TVReusableView
        reusableCollectionView.categoryLabel.text = "Popular TV"
        return reusableCollectionView
    }

    // Prepare for segue / pass data to the another view controller - TVDetailsViewController.swift
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsScreen = segue.destination as! TVDetailsViewController
        detailsScreen.tvShowTitle = tvTitles[selectedIndex]
        detailsScreen.releaseDate = releaseDateArray[selectedIndex]
        detailsScreen.plot = plotArray[selectedIndex]
        detailsScreen.tvID = tvIds[selectedIndex]
    }

}

