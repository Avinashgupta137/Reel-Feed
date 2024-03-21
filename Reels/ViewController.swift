//
//  ViewController.swift
//  Reels
//
//  Created by avinash on 19/03/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    var videos: [Video] = []
    let itemsPerPage = 10
    var currentPage = 1
    var totalPageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchingJson(page: currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }
   
    func fetchingJson(page: Int) {
        guard let filelocation = Bundle.main.url(forResource: "myData", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: filelocation)
            let decoder = JSONDecoder()
            let allVideos = try decoder.decode([Video].self, from: data)
            totalPageCount = (allVideos.count + itemsPerPage - 1) / itemsPerPage
            
            let startIndex = (page - 1) * itemsPerPage
            var endIndex = page * itemsPerPage
            if endIndex > allVideos.count {
                endIndex = allVideos.count
            }
            let newVideos = Array(allVideos[startIndex..<endIndex])
            videos.append(contentsOf: newVideos)
            myCollectionView.reloadData()
        } catch {
            print(error)
        }
    }
    
    func setupLayout(){
        let flowLayout = UICollectionViewFlowLayout()
        let cellWidth =  UIScreen.main.bounds.width
        let cellHeight =   UIScreen.main.bounds.height
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        myCollectionView.collectionViewLayout = flowLayout
        myCollectionView.isPagingEnabled = true
    }
  
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let videodata = videos[indexPath.row].videoUrl
        cell.videos = videodata
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? CollectionViewCell {
            cell.play()
        }
        
        // Check if we are reaching the end of the current data
        if  currentPage < totalPageCount {
            currentPage += 1
            fetchingJson(page: currentPage)
        }else{
            currentPage = 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? CollectionViewCell {
            cell.pause()
        }
    }
}
