//
//  SettingsViewController.h
//  Furry Bunny
//
//  Created by Martin Knoll on 11.08.12.
//  Copyright (c) 2012 Otto-von-Guericke-Universität Magdeburg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *shells;
@property (weak, nonatomic) ViewController * sender;
- (IBAction)setZebra:(id)sender;
- (IBAction)setLeopard:(id)sender;
- (IBAction)setTiger:(id)sender;
- (IBAction)changeShells:(UISlider *)sender;
- (IBAction)changeFurLength:(UISlider *)sender;

@end
