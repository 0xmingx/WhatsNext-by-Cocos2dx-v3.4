//
//  GameKitHelper.m
//  WhatsNext
//
//  Created by Wang43 on 8/30/15.
//
//

#import "GameKitHelper.h"


@implementation GameKitHelper
@synthesize gameCenterAvailable;

//static init
static GameKitHelper *sharedHelper = nil;
static UIViewController* currentModalViewController = nil;
+ (GameKitHelper *) sharedGameKitHelper {
    if (!sharedHelper) {
        sharedHelper = [[GameKitHelper alloc] init];
    }
    return sharedHelper;
}

- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer =@"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    return (gcClass && osVersionSupported);
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc =
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}


- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated &&!userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
    
}

- (void)authenticateLocalUser {
    
    if (!gameCenterAvailable) return;
    
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    } else {
        NSLog(@"Already authenticated!");
    }
}

- (void) showLeaderboard{
    if (!gameCenterAvailable) return;
    
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != nil) {
        leaderboardController.leaderboardDelegate = self;
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        currentModalViewController = [[UIViewController alloc] init];
        [window addSubview:currentModalViewController.view];
        [currentModalViewController presentModalViewController:leaderboardController animated:YES];
    }
    
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category{
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
    
    scoreReporter.value = score;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if(error != nil){
            NSData *saveSocreData = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
            
            //save if failed
            [self storeScoreForLater:saveSocreData];
        }else{
            NSLog(@"提交成功");
        }
    }];
}

- (void)storeScoreForLater:(NSData *)scoreData{
    NSMutableArray *savedScoresArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedScores"]];
    
    [savedScoresArray addObject:scoreData];
    [[NSUserDefaults standardUserDefaults] setObject:savedScoresArray forKey:@"savedScores"];
}

- (void)submitAllSavedScores{
    NSMutableArray *savedScoreArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedScores"]];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedScores"];
    
    for(NSData *scoreData in savedScoreArray){
        GKScore *scoreReporter = [NSKeyedUnarchiver unarchiveObjectWithData:scoreData];
        
        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
            if(error != nil){
                NSData *saveSocreData = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
                
                [self storeScoreForLater:saveSocreData];
            }else{
                NSLog(@"提交成功");
            }
        }];
    }
}

- (void) unlockAchievement:(GKAchievement *)achievement percent:(float)percent
{
    if ( achievement != nil )
    {
        achievement.percentComplete = percent;
        achievement.showsCompletionBanner = YES;
        [achievement reportAchievementWithCompletionHandler:^(NSError* error){
            if ( error != nil)
            {
                NSLog(@"上传成就错误，错误提示为\n%@", error);
            }
            else
            {
                NSLog(@"上传成就成功\n");
                //[self displayAchievement:achievement];
            }
        }];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController{
    if(currentModalViewController !=nil){
        [currentModalViewController dismissModalViewControllerAnimated:NO];
        [currentModalViewController release];
        [currentModalViewController.view removeFromSuperview];
        currentModalViewController = nil;
    }
}

@end

