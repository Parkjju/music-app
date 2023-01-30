//
//  ViewController.swift
//  music-app
//
//  Created by 박경준 on 2023/01/27.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var musicTableView: UITableView!
    
    var networkManager = NetworkManager.shared
    
    var musicArrays: [MusicResult] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSearchBar()
        setupTableView()
        setupData()
    }
    
    func setupSearchBar(){
         
    }
    
    func setupTableView(){
        musicTableView.delegate = self
        musicTableView.dataSource = self
        
        musicTableView.register(
            UINib(nibName: Cell.musicCellIdentifier, bundle: nil), forCellReuseIdentifier: Cell.musicCellIdentifier)
    }
    
    func setupData(){
        networkManager.fetchMusic(searchTerm: "jazz") { result in
            switch result{
            case .success(let musicData):
                dump(musicData)
                self.musicArrays = musicData
                
                DispatchQueue.main.async {
                    self.musicTableView.reloadData()
                }
                
            case .failure(let error):
                dump(error)
            }
        }
    }


}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = musicTableView.dequeueReusableCell(withIdentifier: Cell.musicCellIdentifier, for: indexPath) as! MusicCell
        
        cell.imageUrl = musicArrays[indexPath.row].previewUrl
        cell.songNameLabel.text = musicArrays[indexPath.row].trackName
        cell.artistNameLabel.text = musicArrays[indexPath.row].artistName
        cell.albumNameLabel.text = musicArrays[indexPath.row].collectionName
        cell.releaseDateLabel.text = musicArrays[indexPath.row].releaseDate
        
        cell.selectionStyle = .none
        
        
        return UITableViewCell()
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
