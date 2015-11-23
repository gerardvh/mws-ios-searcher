//
//  DetailViewController.swift
//  SLMobile
//
//  Created by Van Halsema, Gerard on 11/6/15.
//  Copyright © 2015 gerardvh. All rights reserved.
//

import UIKit

protocol DetailViewController {

    var detailItem: SLItem! { get set }

    func configureView()
}

