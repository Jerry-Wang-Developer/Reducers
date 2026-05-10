import ComposableArchitecture

// 這裡使用 SharedReaderKey
extension SharedReaderKey where Self == AppStorageKey<Member?> {
    public static var member: AppStorageKey<Member?> {
        .appStorage("member")
    }
}
