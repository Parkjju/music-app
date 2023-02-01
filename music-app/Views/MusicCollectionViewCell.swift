//
//  MusicCollectionViewCell.swift
//  music-app
//
//  Created by Jun on 2023/01/31.
//

import UIKit

class MusicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    var imageUrl: String?{
        didSet{
            loadImage()
        }
    }
    
    func loadImage(){
        guard let urlString = self.imageUrl, let url = URL(string: urlString) else {return}
        
        DispatchQueue.global().async {
            // URL을 가지고 데이터를 만드는 메서드 (오래걸리는데 동기적인 실행)
            // (일반적으로 이미지를 가져올때 많이 사용)
            guard let data = try? Data(contentsOf: url) else { return }
            // 오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거 ⭐️⭐️⭐️
            guard self.imageUrl! == url.absoluteString else { return }
            
            // 작업의 결과물을 이미로 표시 (메인큐)
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 일반적으로 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해서 실행 ⭐️
        self.mainImageView.image = nil
    }
}
