//
//  GameKitHelper.h
//  WhatsNext
//
//  Created by Wang43 on 8/30/15.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameKitHelper :  NSObject <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GKMatchmakerViewControllerDelegate, GKMatchDelegate>{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
}

@property (assign, readonly) BOOL gameCenterAvailable;

+ (GameKitHelper *)sharedGameKitHelper;
- (void) authenticateLocalUser;
- (void) reportScore: (int64_t) score forCategory: (NSString*) category;
- (void) storeScoreForLater;
- (void) submitAllSavedScores;
- (void) unlockAchievement:(GKAchievement *)achievement percent:(float)percent;
- (void) showLeaderboard;
- (void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;

@end
