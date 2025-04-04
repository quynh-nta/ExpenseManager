//
//  Category+View.swift
//  ExpenseManager
//
//  Created by Nguyen Thi Anh Quynh on 2025-04-04.
//

import SwiftUI

struct CategoryView: View {
    let category: Category
    var body: some View {
        VStack(spacing: 8){
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(systemName: category.iconName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.blue)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(Circle())
            })
            Text(category.name)
                            .font(.subheadline)
                            .foregroundColor(.primary)
        }
        .frame(minWidth: 50)
    }
}

#Preview {
    CategoryView(category: Category(name: "Mua sắm", iconName: "bag"))
}
