#import <Foundation/Foundation.h>

#import "BSNullabilityCompat.h"
#import "BSArgumentCollection.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BSInjector

/**
 * Asks the injector to retrieve an object for the given key. This is a convenience
 * method for @see -getInstance:withArguments: when no arguments are needed.
 */
- (id)getInstance:(id)key;

/**
 * Asks the injector to retrieve an object for the given key. This is a varargs
 * version of @see -getInstance:withArgArray: and mostly exists for backwards
 * compatibility with older versions of Blindside.
 */
- (id)getInstance:(id)key withArgs:(nullable id)arg1, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Asks the injector to retrieve an object for the given key. This is a variant of
 * @see -getInstance:withArguments: and mostly exists for backwards compatibility
 * with older versions of Blindside.
 */
- (id)getInstance:(id)key withArgArray:(NSArray *)args;

/**
 * Asks the injector to retrieve an object for the given key. The args are made available
 * to the @see BSProvider associated with the key. If it is unable to create the object,
 * an exception will be thrown.
 *
 * @param key The injector key that identifies the requested object. This is commonly
 *            an instance of `Class` or `Protocol`, or a string.
 * @param arguments A collection of argument objects to be given to the key's provider.
 *                  This is commonly used with objects that have a @see +bsInitializer
 *                  implementation with one or more BS_DYNAMIC (positional arguments)
 *                  or BS_DYNAMIC_KEY (keyed arguments) argument keys. Positional
 *                  arguments are provided by an NSArray instance, while keyed arguments
 *                  are provided by an NSDictionary instance. Note also that keyed
 *                  arguments are also made available to transitive dependencies
 *                  of the object being retrieved, which facilitates the use of
 *                  dynamic arguments in more complex object graphs.
 * @return An instantiated object with its dependencies already provided.
 */
- (id)getInstance:(id)key withArguments:(id<BSArgumentCollection>)arguments;

/**
 * Provide property-based dependencies to an object created without an injector.
 * This is a convenience method for @see -injectProperties:withArguments: when
 * no arguments are needed.
 */
- (void)injectProperties:(id)instance;

/**
 * Provide property-based dependencies to an object created without an injector.
 * This is useful when working with a framework that instantiates your objects for 
 * you. (e.g. nibs or NSKeyedUnarchiver)
 *
 * @param instance The object which will receive dependencies. Its class should
 *                 have overridden @see +bsProperties to declare the properties
 *                 to be injected, and their injector keys.
 * @param arguments A collection of argument objects that will be made available
 *                  to providers when retrieving dependencies. Note that only
 *                  keyed arguments (e.g. provided by an NSDictionary instance)
 *                  can be used when injecting properties.
 */
- (void)injectProperties:(id)instance withArguments:(id<BSArgumentCollection>)arguments;

@end

NS_ASSUME_NONNULL_END
