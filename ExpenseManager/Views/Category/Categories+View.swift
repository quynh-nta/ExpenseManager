//
//  Categories+View.swift
//  ExpenseManager
//
//  Created by Nguyen Thi Anh Quynh on 2025-04-04.
//

import SwiftUI

struct CategoriesView: View {
    let categories : [Category] = [
        Category(name: "Ăn", iconName: "fork.knife"),
        Category(name: "Mua sắm", iconName: "bag"),
        Category(name: "Giải trí", iconName: "gamecontroller"),
        Category(name: "Du lịch", iconName: "airplane"),
        Category(name: "Hóa đơn", iconName: "house"),
        Category(name: "Sức khỏe", iconName: "heart"),
        Category(name: "Giáo dục", iconName: "book"),
        Category(name: "Khác", iconName: "questionmark")
    ]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 20) {
                ForEach(categories) { category in
                    CategoryView(category: category)
                }
            }
            .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
            .previewLayout(.sizeThatFits)
    }
}
