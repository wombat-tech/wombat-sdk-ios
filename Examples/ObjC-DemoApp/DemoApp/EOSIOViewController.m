#import "EOSIOViewController.h"
#import <WombatAuth/WombatAuth-Swift.h>

@interface EOSIOViewController ()

@end

@implementation EOSIOViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [WMAuth.shared registerAppWithName: @"Wombat SDK Sample"
                                  icon: [NSURL URLWithString:@"https://assets.website-files.com/5cde8c951beecf3604688a58/5d120b2cba030f78d70c7236_Wombat_logo_transparent-p-500.png"]
                            blockchain: [[WMBlockchain alloc] initWithPlatform: WMBlockchainPlatformEosio
                                                                       chainID:@"f16b1833c747c43682f4386fca9cbb327929334a762755ebec17f6f23c9b8a12"]];
}

- (IBAction)authorize {
    NSError *err;
    [WMAuth.shared requestAuthorizationAndReturnError:&err];
    NSLog(@"Unresolved error %@, %@", err, [err userInfo]);
}

- (IBAction)transfer {
    NSString *sender = @"{SENDER_ACCOUNT_NAME}";
    NSString *receiver = @"{RECEIVER_ACCOUNT_NAME}";
    WMEOSIOTransfer *transfer = [[WMEOSIOTransfer alloc] initFrom: sender
                                                               to: receiver
                                                           amount: 1
                                                        precision: 4
                                                         contract: @"eosio.token"
                                                           symbol: @"EOS"
                                                             memo: @"Some memo"];
    NSError *err;
    [WMAuth.shared requestEOSIOTransfer:transfer :&err];
}

- (IBAction)sign {
    NSError *err;
    [WMAuth.shared requestSignatureWithAccount: @"account" data:@"Hello World!" error: &err];
}

- (IBAction)push {
    NSString *sender = @"{SENDER_ACCOUNT_NAME}";
    NSString *receiver = @"{RECEIVER_ACCOUNT_NAME}";
    WMEOSIOAuth *auth = [[WMEOSIOAuth alloc] initWithActor: sender permission: @"active"];
    NSArray<WMEOSIOAction *> *actions = @[[[WMEOSIOAction alloc] initWithAccount: @"eosio.token" name: @"transfer" auth: @[auth] data: @{
        @"from": sender,
        @"to": receiver,
        @"quantity": @"1 EOS",
        @"memo": @"Here you go"
    }]];
    WMEOSIOTransaction *transaction = [[WMEOSIOTransaction alloc] initFrom: @"aaaabbbbcccc" actions: actions];
    NSError *err;
    [WMAuth.shared pushEOSIOTransaction:transaction :&err];
}

@end
