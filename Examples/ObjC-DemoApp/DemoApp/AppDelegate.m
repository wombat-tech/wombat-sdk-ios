#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <WombatAuth/WombatAuth-Swift.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    #pragma mark 1. Register your app
    // You can optionally also specify `chainID`. If omitted, the wallet will use the EOS blockchain as default
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    #pragma mark 2. Handle responses
    return [WMAuth.shared openURL:url completionHandler:^(WMResultObj *result) {
        switch (result.type) {
            case WMResultTypeSuccess:
                switch (result.action) {
                    case WMActionTypeAuthorize: {
                        if (result.blockchain.isEvm) {
                            NSString *address = [result.data valueForKey:@"address"];
                            [self showAlertWithTitle:@"Auth" message:address];
                        } else {
                            NSString *accountName = [result.data valueForKey:@"accountName"];
                            NSString *publicKey = [result.data valueForKey:@"publicKey"];
                            NSString *alertMessage = [NSString stringWithFormat:@"Name: %@\nKey: %@", accountName, publicKey];
                            [self showAlertWithTitle:@"Auth" message:alertMessage];
                        }
                        break;
                    }
                    case WMActionTypePushTransactionEVM: {
                        NSString *transactionID = [result.data valueForKey:@"transactionID"];
                        [self showAlertWithTitle:@"Push" message:transactionID];
                        break;
                    }
                    case WMActionTypePersonalSignEVM: {
                        NSString *transactionID = [result.data valueForKey:@"signedMessage"];
                        [self showAlertWithTitle:@"Personal Sign" message:transactionID];
                        break;
                    }
                    case WMActionTypeSignTypedDataEVM: {
                        NSString *transactionID = [result.data valueForKey:@"signedMessage"];
                        [self showAlertWithTitle:@"Sign Typed Data" message:transactionID];
                        break;
                    }
                    case WMActionTypePushTransactionEOSIO: {
                        NSString *transactionID = [result.data valueForKey:@"transactionID"];
                        [self showAlertWithTitle:@"Push" message:transactionID];
                        break;
                    }
                    case WMActionTypeSignEOSIO: {
                        NSString *signature = [result.data valueForKey:@"signature"];
                        [self showAlertWithTitle:@"Sign" message:signature];
                        break;
                    }
                    case WMActionTypeTransferEOSIO: {
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
