//
//  File.swift
//  
//
//  Created by 王小涛 on 2024/6/8.
//

import Foundation
import ComposableArchitecture
import Collections

@Reducer
public struct MultipleChoices<Option: Hashable & Sendable> {
    @ObservableState
    public struct State: Equatable {
        public let allowZeroSelected: Bool = false
        public var selectedOptions: OrderedSet<Option>
        
        public init(selectedOptions: OrderedSet<Option> = []) {
            self.selectedOptions = selectedOptions
        }
    }
    
    @CasePathable
    public enum Action {
        case toggleOptionSelection(Option)
        case confirmButtonTapped
        case cancelButtonTapped
    }
    
    public init() {}
    
    @Dependency(\.dismiss) var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .toggleOptionSelection(option):
                if state.selectedOptions.contains(option) {
                    if state.selectedOptions.count == 1 && state.allowZeroSelected {
                        state.selectedOptions.remove(option)
                    } else {
                        state.selectedOptions.remove(option)
                    }
                } else {
                    state.selectedOptions.append(option)
                }
                return .none
            
            case .confirmButtonTapped:
                return .none
                
            case .cancelButtonTapped:
                return .run { [dismiss] _ in
                    await dismiss()
                }
            }
        }
    }
}
