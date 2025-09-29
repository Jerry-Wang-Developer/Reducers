//
//  File.swift
//  
//
//  Created by 王小涛 on 2024/6/8.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct SingleChoice<Option: Hashable> {
    @ObservableState
    public struct State: Equatable {
        public var selectedOption: Option?
        
        public init(selectedOption: Option? = nil) {
            self.selectedOption = selectedOption
        }
    }
    
    @CasePathable
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case selectOption(Option)
        case confirmButtonTapped
    }
    
    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case let .selectOption(option):
                state.selectedOption = option
                return .none
                
            case .confirmButtonTapped:
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
