//
//  TVDetailsViewController.swift
//  moviedb
//
//  Created by Matic on 15/09/2018.
//  Copyright © 2018 Matic. All rights reserved.
//

import UIKit
import SDWebImage

class TVDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    // TODO - make outlet for collectionview

    // Variables that get values from segue (SecondViewController)
    var tvShowTitle = String()
    var releaseDate = String()
    var plot = String()
    var tvID = Int()
    var creatorNames = [String]()
    var creatorImages = [String]()
    var howMany = Int()


    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = tvShowTitle
        releaseDateLabel.text = releaseDate
        overviewLabel.text = plot
        getTvCredits(for: tvID)
    }

    func getTvCredits(for id: Int) {
        let url = URL(string: "https://api.themoviedb.org/3/tv/\(id)?api_key=9d2bff12ed955c7f1f74b83187f188ae&language=en-US&page=1")
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            guard let data = data else {
                print("Error")
                return
            }
            guard let tvCredits = try? JSONDecoder().decode(TVDetailsStruct.self, from: data) else {
                print("Error")
                return
            }
            self.howMany = tvCredits.created_by.count
            for i in 0...self.howMany - 1 {
                self.creatorImages.append("http://image.tmdb.org/t/p/w500/\(tvCredits.created_by[i].profile_path ?? "error")")
                self.creatorNames.append(tvCredits.created_by[i].name)
            }
            print(self.creatorImages)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.creatorNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let creatorsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "creatorsCell", for: indexPath) as! CreatorsCollectionViewCell
        creatorsCell.layer.borderWidth = 0.7
        creatorsCell.layer.borderColor = UIColor.white.cgColor
        
        if(self.creatorImages[indexPath.item] == "http://image.tmdb.org/t/p/w500/error") {
            let url = URL(string: "https://www.csuohio.edu/sites/default/files/1024px-Placeholder_no_text_svg.png")
            creatorsCell.profilePic.sd_setImage(with: url)
        } else {
            let url = URL(string: self.creatorImages[indexPath.item])
            creatorsCell.profilePic.sd_setImage(with: url)
        }
        creatorsCell.creatorName.text = creatorNames[indexPath.item]

        return creatorsCell
    }

}
