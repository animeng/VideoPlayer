//
//  BasicModel.m
//  SaleHouse
//
//  Created by wang animeng on 13-4-3.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#import "BasicModel.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation BasicModel

+ (BOOL) object : (id) object
	hasProperty : (NSString *) propertyName
{
	BOOL foundProperty = NO;
	if (object != nil) {
		foundProperty = class_getProperty([object class], [propertyName UTF8String]) != NULL;
	}
	return foundProperty;
}

+ (id)createObjectWithInfo:(NSDictionary*)info
{
    Class objectClass = [self class];
    id objectInstance = [[objectClass alloc] init];
    NSArray *keys = [info allKeys];
    id key;
    id value;
    int i;
    for (i = 0; i < [keys count]; i++)
    {
        key = [keys objectAtIndex: i];
        value = [info objectForKey: key];
        if ([BasicModel object:objectInstance hasProperty:key] && ![value isKindOfClass:[NSNull class]]) {
            [objectInstance setValue: value
                              forKey: key];
        }
    }
    return objectInstance;
}

- (NSString*)description
{
    unsigned int outCount, i;
    NSString * allPropertyValue = [NSString stringWithFormat:@"%@:",NSStringFromClass([self class])];
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName)
        {
            allPropertyValue = [NSString stringWithFormat:@"%@\n%s:%@",allPropertyValue,propName,[self valueForKey:[NSString stringWithFormat:@"%s",propName]]];
        }
    }
    return allPropertyValue;
}

#pragma mark - NSCoding and NSCopy

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName)
        {
            NSString *key = [NSString stringWithFormat:@"%s",propName];
            id properyObj = [self valueForKey:key];
            [aCoder encodeObject:properyObj forKey:key];
        }
    }
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self) {
        
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        for(i = 0; i < outCount; i++)
        {
            objc_property_t property = properties[i];
            const char *propName = property_getName(property);
            if(propName)
            {
                NSString *key = [NSString stringWithFormat:@"%s",propName];
                id decodeObj =[aDecoder decodeObjectForKey:key];
                [self setValue:decodeObj forKey:key];
            }
        }
        
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone{
    
    BasicModel *basicData=[[[self class] allocWithZone:zone] init];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName)
        {
            NSString *key = [NSString stringWithFormat:@"%s",propName];
            id properyObj = [self valueForKey:key];
            [basicData setValue:[properyObj copyWithZone:zone] forKey:key];
        }
    }
    return basicData;
}

#pragma mark - persistence

+ (id)loadFromFile:(NSString*)path{

    BasicModel *basicData=nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data=[[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unArchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        basicData=[unArchiver decodeObject];
        [unArchiver finishDecoding];
    }
    if (!basicData)
        basicData=[[BasicModel alloc] init];
    return basicData;
}

- (void)saveToFile:(NSString*)path{
    NSMutableData *data=[[NSMutableData alloc] init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeRootObject:self];
    [archiver finishEncoding];
    [data writeToFile:path atomically:YES];
}


@end
