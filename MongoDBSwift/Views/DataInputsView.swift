//
//  DataInputsView.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 24/11/2022.
//

import SwiftUI

struct DataInputsView: View {
    @Binding var sortField: String
    @Binding var sortAscending: Bool
    @Binding var filterKey: String
    @Binding var filterType: String
    @Binding var filterStringValue: String
    @Binding var filterIntValue: Int
    @Binding var filterDoubleValue: Double
    @Binding var docCount: Int
    @Binding var enabledChangeStreams: Bool
    let refreshData: () -> Void
    
    let inputTypeOptions = ["String", "Int", "Float"]
    
    @State private var inProgress = false
    @State private var inputType = ""
    
    var body: some View {
        Form {
            TextField("Filter key", text: $filterKey)
                .textFieldStyle(.roundedBorder)
                .padding(4)
            Picker("Filter value type", selection: $filterType) {
                ForEach(inputTypeOptions, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(4)
            switch filterType {
            case "String":
                TextField("Field value", text: $filterStringValue)
                    .textFieldStyle(.roundedBorder)
                    .padding(4)
            case "Int":
                TextField("Field value", value: $filterIntValue, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .padding(4)
            case "Float":
                TextField("Field value", value: $filterDoubleValue, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .padding(4)
            default:
                TextField("Field value", text: $filterStringValue)
                    .textFieldStyle(.roundedBorder)
                    .padding(4)
            }
            HStack {
                TextField("Sort string", text: $sortField)
                    .textFieldStyle(.roundedBorder)
                    .padding(4)
                Toggle(isOn: $sortAscending) {
                    Text("Sort ascending?")
                }
                .padding(4)
            }
            HStack {
                TextField("Number of documents", value: $docCount, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .padding(4)
                Spacer()
                Toggle("Enable change streams?", isOn: $enabledChangeStreams)
            }
            Button() {
                inProgress = true
                refreshData()
                inProgress = false
            } label: {
                Label("Load documents", systemImage: "arrow.clockwise.circle")
            }
            .disabled(inProgress)
            .buttonStyle(.borderedProminent)
            .padding(4)
        }
    }
}

struct DataInputsView_Previews: PreviewProvider {
    static var previews: some View {
        DataInputsView(
            sortField: .constant("_id"),
            sortAscending: .constant(false),
            filterKey: .constant(""),
            filterType: .constant("String"),
            filterStringValue: .constant(""),
            filterIntValue: .constant(0),
            filterDoubleValue: .constant(0.0),
            docCount: .constant(10),
            enabledChangeStreams: .constant(true),
            refreshData: {})
    }
}
