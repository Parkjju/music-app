//
//  ViewController.swift
//  music-app
//
//  Created by 박경준 on 2023/01/27.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var musicTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setupTableView(){
        musicTableView.delegate = self
        musicTableView.dataSource = self
    }


}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
