//
//  FetchImageAccessible.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 02.03.24.
//

import UIKit.UIImage

protocol FetchImageAccessible {
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, Error>) ->Void)
}

extension FetchImageAccessible {
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, Error>) ->Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data,_,_ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)?.withRenderingMode(.alwaysOriginal) ?? UIImage()
                completion(.success(image))
            }
        }
        task.resume()
        session.invalidateAndCancel()
    }
}
