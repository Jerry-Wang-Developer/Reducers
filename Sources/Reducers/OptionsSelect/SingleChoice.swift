// SingleChoice.swift
// Copyright (c) 2025 Nostudio Office
// Created by Jerry X T Wang on 2025/9/29.

import ComposableArchitecture
import Foundation

@Reducer
public struct SingleChoice<Option: Hashable & Sendable> {
    @ObservableState
    public struct State: Equatable {
        public var selectedOption: Option?

        public init(selectedOption: Option? = nil) {
            self.selectedOption = selectedOption
        }
    }

    @CasePathable
    public enum Action: BindableAction, Sendable {
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
