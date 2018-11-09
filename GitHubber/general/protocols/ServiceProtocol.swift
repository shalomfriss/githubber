//
//  ServiceProtocol.swift
//  GitHubber
//
//  Created by user on 11/5/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation

protocol Service {
    func execute(onSuccess: @escaping ([String:Any]?)  -> (), onError: @escaping (Error?) -> ())
}

