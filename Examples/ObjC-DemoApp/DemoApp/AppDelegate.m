#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <WombatAuth/WombatAuth-Swift.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    #pragma mark 1. Register your app
    [WombatAuth.shared registerAppWithName:@"Testing App" icon:[NSURL URLWithString:@"https://assets.website-files.com/5cde8c951beecf3604688a58/5d120b2cba030f78d70c7236_Wombat_logo_transparent-p-500.png"]];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    #pragma mark 2. Handle responses
    return [WombatAuth.shared openURL:url completionHandler:^(WMResultObj *result) {
        switch (result.type) {
            case WMResultTypeSuccess:
                switch (result.action) {
                    case WMActionTypeAuthorize: {
                        NSString *accountName = [result.data valueForKey:@"accountName"];
                        NSString *publicKey = [result.data valueForKey:@"publicKey"];
                        NSString *alertMessage = [NSString stringWithFormat:@"Name: %@\nKey: %@", accountName, publicKey];
                        [self showAlertWithTitle:@"Auth" message:alertMessage];
                        break;
                    }
                    case WMActionTypePushTransaction: {
                            NSString *transactionID = [result.data valueForKey:@"transactionID"];
                            [self showAlertWithTitle:@"Push" message:transactionID];
                            break;
                        }
                    case WMActionTypeSignTransaction: {
                            NSString *signature = [result.data valueForKey:@"signature"];
                            [self showAlertWithTitle:@"Sign" message:signature];
                            break;
                        }
                    case WMActionTypeTransfer: {
                            NSString *transactionID = [result.data valueForKey:@"transactionID"];
                            [self showAlertWithTitle:@"Transfer" message:transactionID];
                            break;
                        };
                    case WMActionTypeUnknown: {
                            [self showAlertWithTitle:@"Unknown" message:result.message];
                            break;
                        };
                }
                break;
            case WMResultTypeError:
                [self showAlertWithTitle:@"WMResultTypeError" message: result.message];
                break;
            case WMResultTypeUserCancelled:
                [self showAlertWithTitle:@"WMResultTypeUserCancelled" message:@"Cancelled by the user"];
                break;
        }
    }];
}

-(void)showAlertWithTitle:(NSString *)title message:(nullable NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction: [UIAlertAction actionWithTitle: @"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
