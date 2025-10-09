// Members.swift
// Copyright (c) 2025 Nostudio Office
// Created by Jerry X T Wang on 2025/9/29.

import Collections

public protocol MembersState<T> {
    associatedtype T: Collection<Member.State>
    var members: T { get }
}

public extension MembersState {
    var isMember: Bool {
        owned != nil
    }

    var owned: Member.State? {
        let owned = members.first { $0.isAvaliable }
        return owned
    }

    var isSyncing: Bool {
        members.reduce(false) { $0 || $1.isSyncing }
    }

    var isPurchasing: Bool {
        members.reduce(false) { $0 || $1.isPurchasing }
    }
}
