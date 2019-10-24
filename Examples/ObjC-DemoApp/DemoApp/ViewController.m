#import "ViewController.h"
#import <WombatAuth/WombatAuth-Swift.h>

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)authorize {
    [WombatAuth.shared requestAuthorization];
}

- (IBAction)transfer {
    WMTransfer *transfer = [[WMTransfer alloc] initFrom: @"aaaabbbbcccc" to: @"xxxxyyyyzzzz" amount: 1 precision: 4 contract: @"eosio.token" symbol: @"EOS" memo: @"Some memo"];
    [WombatAuth.shared requestTransfer: transfer];
}

- (IBAction)sign {
    [WombatAuth.shared requestSignatureWithAccount: @"account" data: @"some data to sign"];
}

- (IBAction)push {
    WMAuth *auth = [[WMAuth alloc] initWithActor: @"aaaabbbbcccc" permission: @"active"];
    NSArray<WMAction *> *actions = @[[[WMAction alloc] initWithAccount: @"eosio.token" name: @"transfer" auth: @[auth] data: @{
        @"from": @"aaaabbbbcccc",
        @"to": @"xxxxyyyyzzzz",
        @"quantity": @"1.3000 EOS",
        @"memo": @"Here you go"
    }]];
    WMTransaction *transaction = [[WMTransaction alloc] initFrom: @"aaaabbbbcccc" actions: actions];
    [WombatAuth.shared pushTransaction: transaction];
}

@end
