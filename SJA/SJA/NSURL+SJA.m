#import "NSURL+SJA.h"

@implementation NSURL (SJA)

+ (NSURL *)sjaBulletin {
    return [NSURL URLWithString:@"http://luke.gs/sjabulletin"];
}

+ (NSURL *)sjaNetClassroom {
    return [NSURL URLWithString:@"http://luke.gs/sjanetclassroom"];
}

+ (NSURL *)sjaPersonalSite {
    return [NSURL URLWithString:@"http://luke.gs/sjapersonalsite"];
}

+ (NSURL *)sjaWebsite {
    return [NSURL URLWithString:@"http://luke.gs/sjahomepage"];
}

+ (NSURL *)sjaBlackboard {
    return [NSURL URLWithString:@"http://luke.gs/sjablackboard"];
}

+ (NSURL *)sjaFAWeb {
    return [NSURL URLWithString:@"http://luke.gs/sjafaweb"];
}

+ (NSURL *)sjaTwitter {
    return [NSURL URLWithString:@"http://luke.gs/sjatwitter"];
}

+ (NSURL *)sjaTickerItems {
    return [NSURL URLWithString:@"http://luke.gs/sjaticker"];
}

+ (NSURL *)sjaAlumnaeEvents {
    return [NSURL URLWithString:@"http://luke.gs/sjaalumnaeevents"];
}

+ (NSURL *)sjaEventRegistration {
    return [NSURL URLWithString:@"http://luke.gs/sjaeventreg"];
}

@end
