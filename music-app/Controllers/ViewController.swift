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
    
    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSearchBar()
        setupTableView()
        setupData()
    }
    
    func setupSearchBar(){
        self.title = "Music Search"
        navigationItem.searchController = searchController
        
//        searchController.searchBar.delegate = self
        
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.autocapitalizationType = .none
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
        cell.songNameLabel.text = musicArrays[indexPath.row].trackName!.count > 15 ? "\(musicArrays[indexPath.row].trackName)..." : musicArrays[indexPath.row].trackName
        cell.artistNameLabel.text = musicArrays[indexPath.row].artistName
        cell.albumNameLabel.text = musicArrays[indexPath.row].collectionName
        cell.releaseDateLabel.text = musicArrays[indexPath.row].releaseDate
        
        cell.selectionStyle = .none
        
        
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

//extension ViewController: UISearchBarDelegate{
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        self.musicArrays = []
//
//        networkManager.fetchMusic(searchTerm: searchText) { result in
//            switch result {
//            case .success(let musicData):
//                self.musicArrays = musicData
//                DispatchQueue.main.async {
//                    self.musicTableView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let text = searchController.searchBar.text else {
//            return
//        }
//        print(text)
//
//        self.musicArrays = []
//
//        networkManager.fetchMusic(searchTerm: text) { result in
//            switch result{
//            case .success(let musicData):
//                self.musicArrays = musicData
//                DispatchQueue.main.async {
//                    self.musicTableView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//        self.view.endEditing(true)
//    }
//}

extension ViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        print("서치바 입력 단어", searchController.searchBar.text)
        
        let vc = searchController.searchResultsController as! SearchResultViewController
        
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
}
