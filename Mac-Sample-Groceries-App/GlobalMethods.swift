//
//  GlobalMethods.swift
//  Mac-Sample-Groceries-App
//
//  Created by KSMACMINI-016 on 22/07/24.
//

import Foundation
import SwiftUI

func clearAllFields(_ fields: [Binding<String>]) {
    for field in fields {
        field.wrappedValue = ""
    }
}
