//
//  ViewRouter.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 9/6/21.
//

import SwiftUI

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .profile
}

enum Page {
    case timer
    case profile
    case editProfile
    case menu
}
