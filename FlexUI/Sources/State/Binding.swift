//
//  Binding.swift
//  FlexUI
//
//  Created by Li ChangMing on 2020/8/31.
//


@propertyWrapper
public struct Binding<Value>: DynamicProperty {

  let set: (Value) -> Void
  let get: () -> Value

  public var wrappedValue: Value {
    get { get() }
    nonmutating set { set(newValue) }
  }

  public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
    self.get = get
    self.set = set
  }

  public var projectedValue: Binding<Value> {
    self
  }

}

extension Binding {

  /// Creates an instance by projecting the base value to an optional value.
  public init<V>(_ base: Binding<V>) where Value == V? {
    fatalError()
  }

  /// Creates an instance by projecting the base optional value to its
  /// unwrapped value, or returns `nil` if the base value is `nil`.
  public init?(_ base: Binding<Value?>) {
    fatalError()
  }

  /// Creates an instance by projecting the base `Hashable` value to an
  /// `AnyHashable` value.
  public init<V>(_ base: Binding<V>) where Value == AnyHashable, V : Hashable {
    fatalError()
  }
}

/*
 @available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
 @frozen @propertyWrapper @dynamicMemberLookup public struct Binding<Value> {

 /// The transaction used for any changes to the binding's value.
 public var transaction: Transaction

 /// Initializes from functions to read and write the value.
 public init(get: @escaping () -> Value, set: @escaping (Value) -> Void)

 /// Initializes from functions to read and write the value.
 public init(get: @escaping () -> Value, set: @escaping (Value, Transaction) -> Void)

 /// Creates a binding with an immutable `value`.
 public static func constant(_ value: Value) -> Binding<Value>

 /// The value referenced by the binding. Assignments to the value
 /// will be immediately visible on reading (assuming the binding
 /// represents a mutable location), but the view changes they cause
 /// may be processed asynchronously to the assignment.
 public var wrappedValue: Value { get nonmutating set }

 /// The binding value, as "unwrapped" by accessing `$foo` on a `@Binding` property.
 public var projectedValue: Binding<Value> { get }

 /// Creates a new `Binding` focused on `Subject` using a key path.
 public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Binding<Subject> { get }
 }

 @available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
 extension Binding {

 /// Creates an instance by projecting the base value to an optional value.
 public init<V>(_ base: Binding<V>) where Value == V?

 /// Creates an instance by projecting the base optional value to its
 /// unwrapped value, or returns `nil` if the base value is `nil`.
 public init?(_ base: Binding<Value?>)

 /// Creates an instance by projecting the base `Hashable` value to an
 /// `AnyHashable` value.
 public init<V>(_ base: Binding<V>) where Value == AnyHashable, V : Hashable
 }

 @available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
 extension Binding {

 /// Create a new Binding that will apply `transaction` to any changes.
 public func transaction(_ transaction: Transaction) -> Binding<Value>

 /// Create a new Binding that will apply `animation` to any changes.
 public func animation(_ animation: Animation? = .default) -> Binding<Value>
 }

 @available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
 extension Binding : DynamicProperty {
 }
 */
