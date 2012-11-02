//
//  SettingsViewController.m
//  Furry Bunny
//
//  Created by Martin Knoll on 11.08.12.
//  Copyright (c) 2012 Otto-von-Guericke-Universität Magdeburg. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
  [self setShells:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)setZebra:(id)sender {
  [self.sender setZebra];
}

- (IBAction)setLeopard:(id)sender {
  [self.sender setLeopard];
}

- (IBAction)setTiger:(id)sender {
  [self.sender setTiger];
}

- (IBAction)changeShells:(UISlider *)sender {
  self.shells.text = [NSString stringWithFormat:@"%d Shells", (NSInteger)sender.value];
  [self.sender changeShellsTo:(NSInteger)sender.value];
}

- (IBAction)changeFurLength:(UISlider *)sender {
  [self.sender changeFurLengthTo:sender.value];
}
@end
