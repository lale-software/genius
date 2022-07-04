//
//  Utils.h
//  Genius
//
//  Created by Metehan Karabiber on 6/24/14.
//
//

@interface Utils : NSObject

+ (void) saveObj:(NSObject *)obj forKey:(NSString *)key;
+ (void) saveBool:(BOOL)boolean  forKey:(NSString *)key;
+ (void) saveInt:(int)integer forKey:(NSString *)key;

+ (NSObject *) objectForKey:(NSString *)key;
+ (NSString *) strForKey:(NSString *)key;
+ (BOOL) boolForKey:(NSString *)key;
+ (NSInteger) intForKey:(NSString *)key;

+ (NSString *) getUUID;

@end
