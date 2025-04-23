//
//  SmallWidgetText.swift
//  ALLEX
//
//  Created by youngkyun park on 4/23/25.
//

import SwiftUI

private struct SmallWidgetText: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12))
            .padding(.leading, 4)
            .frame(maxWidth: .infinity, alignment: .leading)

    }
    
    
}

extension View {
    
    func asSmallWidgetText() -> some View {
        modifier(SmallWidgetText())
    }
}
