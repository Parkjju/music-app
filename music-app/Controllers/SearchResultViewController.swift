//
//  SearchResultViewController.swift
//  music-app
//
//  Created by Jun on 2023/01/31.
//

import UIKit

class SearchResultViewController: UIViewController {
    
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    let flowLayout = UICollectionViewFlowLayout()
    
    let networkManager = NetworkManager.shared
    
    var musicArrays: [MusicResult] = []
    
    var searchTerm: String?{
        didSet{
            setupData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        
        
        flowLayout.scrollDirection = .vertical
        
        let collectionCellWidth = (UIScreen.main.bounds.width - CVCell.spacingWidth * (CVCell.cellColumns - 1) ) /  CVCell.cellColumns
        
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        flowLayout.minimumInteritemSpacing = CVCell.spacingWidth
        flowLayout.minimumLineSpacing = CVCell.spacingWidth
        
        collectionView.collectionViewLayout = flowLayout
    }
    
    func setupData(){
        guard let term = searchTerm else {return}
        print("검색중.. \(term)")
        
        self.musicArrays = []
        
        networkManager.fetchMusic(searchTerm: term) { result in
            switch result{
            case .success(let musicData):
                self.musicArrays = musicData
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchResultViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicArrays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.musicCollectionViewCellIdentifier, for: indexPath) as! MusicCollectionViewCell
        
        cell.imageUrl = musicArrays[indexPath.row].previewUrl
        
        return cell
    }
}
