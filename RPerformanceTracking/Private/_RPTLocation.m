#import "_RPTLocation.h"

static NSString *const KEY = @"com.rakuten.performancetracking.location";

/* RPT_EXPORT */ @implementation _RPTLocation

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
- (instancetype)initWithData:(NSData *)data
{
	do
	{
		if (![data isKindOfClass:NSData.class] || !data.length) break;
		
		NSDictionary *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:0];
		if (![values isKindOfClass:NSDictionary.class]) break;
		
		NSArray *responseList = values[@"list"];
		if (![responseList isKindOfClass:NSArray.class] || responseList.count == 0) break;
		
		NSDictionary *responseValues = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseList[0]];
		if (![responseValues isKindOfClass:NSDictionary.class]) break;
		
		NSArray *resultSubdivisionDetails = responseValues[@"subdivisions"];
		if (![resultSubdivisionDetails isKindOfClass:NSArray.class] || resultSubdivisionDetails.count == 0) break;
		
		NSDictionary *subdivisionValues = resultSubdivisionDetails[0];
		if (![subdivisionValues isKindOfClass:NSDictionary.class]) break;
		
		NSDictionary *countryDetails = responseValues[@"country"];
		if (![countryDetails isKindOfClass:NSDictionary.class]) break;
		
		NSString *location = subdivisionValues[@"names"][@"en"];
		
		NSString *country = countryDetails[@"iso_code"];
		if (![location isKindOfClass:NSString.class] || !location.length ||
			![country isKindOfClass:NSString.class] || !country.length) break;
		/*
		 * City is valid.
		 */
		if ((self = [super init]))
		{
			_location = location;
			_country = country;
		}
		return self;
	} while(0);
	
	return nil; // invalid object
}

#pragma clang diagnostic pop

+ (instancetype)loadLocation
{
	NSData *locationData = [NSUserDefaults.standardUserDefaults objectForKey:KEY];
	return locationData ? [self.alloc initWithData:locationData] : nil;
}

+ (void)persistWithData:(NSData *)data
{
	if (data.length) [NSUserDefaults.standardUserDefaults setObject:data forKey:KEY];
}
@end
