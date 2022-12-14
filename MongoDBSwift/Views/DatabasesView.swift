//
//  DatabasesView.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 23/11/2022.
//

import SwiftUI
import MongoSwift

struct DatabasesView: View {
    let client: MongoClient
    @Binding var dbName: String
    @Binding var collectionName: String
    
    @State private var inProgress = false
    @State private var errorMessage = ""
    @State private var dbs: [DatabaseSpecification]?
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        Task {
                            await listDBs()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise.circle")
                    }
                    .disabled(inProgress)
                    .offset(y: -28)
                }
                if let dbs = dbs {
                    List(dbs) { db in
                        DatabaseView(
                            client: client,
                            dbName: db.name,
                            selectedDbName: $dbName,
                            selectedCollectioName: $collectionName
                        )
                    }
                    .listStyle(.sidebar)
                }
                Spacer()
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .padding(.leading, 8)
            .padding(.trailing, 8)
            if inProgress {
                ProgressView()
            }
        }
        .task() {
            await listDBs()
        }
    }
    
    private func listDBs() async {
        inProgress = true
        if !errorMessage.isEmpty {
            errorMessage = ""
        }
        do {
            dbs = try await client.listDatabases()
        } catch {
            errorMessage = "Failed to list databases: \(error.localizedDescription)"
        }
        inProgress = false
    }
}

struct DatabasesView_Previews: PreviewProvider {
    static var previews: some View {
        if !PreviewValues.uri.isEmpty {
            let client = try! MongoClientExt(name: PreviewValues.name, uri: PreviewValues.uri).client
            DatabasesView(client: client!, dbName: .constant("Database"), collectionName: .constant("Collection"))
        } else {
            Text("Need to set PreviewValues.uri to enable preview")
        }
    }
}
