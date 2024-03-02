//
//  TableViewDequeueable.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 03.03.24.
//

import UIKit

protocol TableViewDequeueable: UITableViewCell {
    func configure(viewModel: TableViewRowViewModelable)
}

protocol TableViewRowViewModelable {
    var dequeueID: String { get }
}
