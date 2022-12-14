//
//  ConnectView.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 23/11/2022.
//

import SwiftUI

struct ConnectView: View {
    @Binding var client: MongoClientExt?
    
    @AppStorage("name") var name = ""
    @AppStorage("uri") var uri = ""
    
    @State private var errorMessage = ""
    @State private var inProgress = false
    @State private var isEditing = false
    @State private var maskedURI = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Spacer()
                TextField("Nickname", text: $name)
                    .textFieldStyle(.roundedBorder)
                HStack {
                    TextField("URI", text: isEditing ? $uri : $maskedURI)
                        .textFieldStyle(.roundedBorder)
                        .disabled(!isEditing)
                    Button {
                        isEditing = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .disabled(isEditing)
                }
                Button(action: connect) {
                    Text("Connect")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(name.isEmpty || uri.isEmpty || inProgress)
                Spacer()
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            if inProgress {
                ProgressView()
            }
        }
        .onAppear(perform: maskPassword)
        .padding()
    }
    
    private func connect() {
        isEditing = false
        inProgress = true
        if !errorMessage.isEmpty {
            errorMessage = ""
        }
        do {
            let inProgressClient = try MongoClientExt(name: name, uri: uri)
            client = inProgressClient
            inProgress = false
        } catch {
            client = nil
            inProgress = false
            errorMessage = "Failed to connect to \(name): \(error.localizedDescription)"
        }
    }
    
    private func maskPassword() {
        maskedURI = uri.maskPassword()
    }
    
}

struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectView(client: .constant(nil))
    }
}
