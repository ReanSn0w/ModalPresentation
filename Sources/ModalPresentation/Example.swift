//
//  SwiftUIView.swift
//  
//
//  Created by Дмитрий Папков on 16.03.2021.
//

import SwiftUI

struct MainView: View {
    @State var presented: Bool = false
    
    var body: some View {
        Button("Открыть") { self.presented.toggle() }
            .sheet(isPresented: $presented, content: {
                ExampleSheet().modalPresentation()
            })
    }
}

struct ExampleSheet: View {
    @Environment(\.modalPreferences) var modalPreferences
    
    var body: some View {
        VStack {
            Text("Данный View невозможно закрыть без клика по кнопке")
            
            Button("Закрыть") {
                self.modalPreferences?.dismissNow()
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
