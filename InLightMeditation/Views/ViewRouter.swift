//
//  ViewRouter.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 9/6/21.
//

import SwiftUI

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .timer
    
}

enum Page {
    case timer
    case profile
}
