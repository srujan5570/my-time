#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Castar : NSObject

/**
 * Creates an instance of Castar with the provided developer key.
 * @param devKey The developer key obtained from the Castar developer portal.
 * @return An instance of Castar if successful, nil otherwise.
 */
+ (nullable instancetype)createInstanceWithDevKey:(NSString *)devKey error:(NSError **)error;

/**
 * Starts the Castar SDK.
 */
- (void)start;

/**
 * Stops the Castar SDK.
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END 