//
//  EVMViewController.m
//  DemoApp
//
//  Created by Marsel Tzatzos on 2/2/23.
//

#import "EVMViewController.h"
#import <WombatAuth/WombatAuth-Swift.h>
#import "NSString+Hex.h"

@interface EVMViewController ()

@end

@implementation EVMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WMAuth.shared registerAppWithName: @"Wombat SDK Sample"
                                  icon: [NSURL URLWithString:@"https://assets.website-files.com/5cde8c951beecf3604688a58/5d120b2cba030f78d70c7236_Wombat_logo_transparent-p-500.png"]
                            blockchain: [[WMBlockchain alloc] initWithPlatform: WMBlockchainPlatformEvm
                                                                       chainID:@"80001"]];
}

- (IBAction)authorize:(id)button {
    NSError *err;
    [WMAuth.shared requestAuthorizationAndReturnError:&err];
}

- (IBAction)personalSign:(id)button {
    NSError *err;
    [WMAuth.shared personalSignWithMessage:@"Hello World!" error:&err];
}

- (IBAction)signTypedData:(id)button {
    NSData *data = [@"{\"types\":{\"EIP712Domain\":[{\"name\":\"name\",\"type\":\"string\"},{\"name\":\"version\",\"type\":\"string\"},{\"name\":\"chainId\",\"type\":\"uint256\"},{\"name\":\"verifyingContract\",\"type\":\"address\"}],\"Person\":[{\"name\":\"name\",\"type\":\"string\"},{\"name\":\"wallet\",\"type\":\"bytes32\"},{\"name\":\"age\",\"type\":\"int256\"},{\"name\":\"paid\",\"type\":\"bool\"}]},\"primaryType\":\"Person\",\"domain\":{\"name\":\"Person\",\"version\":\"1\",\"chainId\":1,\"verifyingContract\":\"0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC\"},\"message\":{\"name\":\"alice\",\"wallet\":\"0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB\",\"age\":40,\"paid\":true}}"  dataUsingEncoding: NSUTF8StringEncoding];
    NSError *err;
    [WMAuth.shared signTypedDataWithData:data error:&err];
}

- (IBAction)transfer:(id)button {
    NSError *err;
    NSString *value = [NSString stringWithFormat: @"%lx", 100000000000000000];
    NSString *sender = @"0xc60Fa6D34C8A926E22791D7178F883Bd4cf2B312";
    NSString *receiver = @"0x7F4Ff6c65fB4a1211931b80d05062daDfB5480bD";
    [WMAuth.shared pushEVMTransaction:[[WMEVMTransaction alloc] initFrom:sender
                                                                      to:receiver
                                                                   value:value
                                                                    data:nil]
                                     :&err];
}

- (IBAction)transaction:(id)button {
    NSString *sender = @"0xc60Fa6D34C8A926E22791D7178F883Bd4cf2B312";
    NSString *contract = @"0x2d7882beDcbfDDce29Ba99965dd3cdF7fcB10A1e";
    NSData *data = [@"a9059cbb0000000000000000000000007f4ff6c65fb4a1211931b80d05062dadfb5480bd000000000000000000000000000000000000000000000000016345785d8a0000" stringToHexData];
    NSError *err;
    [WMAuth.shared pushEVMTransaction:[[WMEVMTransaction alloc] initFrom:sender
                                                                      to:contract
                                                                   value:nil
                                                                    data:data]
                                     :&err];
}


@end
