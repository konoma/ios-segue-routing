# Segue Routing

A category on `UIViewController` that automatically routes your `-prepareForSegue:sender:` calls to explicit methods based on the segue identifier.

So, instead of this:

    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        if ([segue.identifier isEqualToString:@"Show Settings"]) {
            // prepare for 'Show Settings' segue
        } else if ([segue.identifier isEqualToString:@"Show User Info"]) {
            // prepare for 'Show User Info' segue
        } else if ([segue.identifier isEqualToString:@"Show About"]) {
            // prepare for 'Show About' segue
        }
    }

You can write this:

    - (void)prepareForShowSettingsSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        // prepare for 'Show Settings' segue
    }
    
    - (void)prepareForShowUserInfoSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        // prepare for 'Show User Info' segue
    }
    
    - (void)prepareForShowAboutSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        // prepare for 'Show About' segue
    }

Also it allows you to provide a configuration block when performing a segue.

    - (IBAction)showSettings:(id)sender {
        [self performSegueWithIdentifier:@"Show Settings" sender:sender configureUsingBlock:(UIStoryboardSegue *segue) {
            // prepare for 'Show Settings' segue
        }];
    }


## Installation

When using [Cocoapods](http://cocoapods.org) add the following to your `Podfile`:

    pod 'KNMSegueRouting', '~> 0.1'

Then in your application targets build settings under `Additional Linker Flags` add `-ObjC` so the category is recognized.


## Usage


### Segue Routing

In your view controller simply add methods for your segues using the following pattern:

    - (void)prepareFor<SymbolifiedSegueIdentifier>Segue:(UIStoryboardSegue *)segue sender:(id)sender {
        // handle your segue here
    }

The rules to symbolify the segue name are as follows:

1. Split the string on any character not allowed in a symbol. Allowed characters are `A-Z`, `a-z`, `0-9` and `_` (in any order and combination)
2. Capitalize the first character of all resulting parts
3. Concatenate the parts

So a segue with identifier `some overly-complicated identifier_name 2` becomes `SomeOverlyComplicatedIdentifier_name2` and would get routed to `-prepareForSomeOverlyComplicatedIdentifier_name2Segue:sender:`


### Examples

Handle a segue with identifier `Present Login`:

    - (void)prepareForPresentLoginSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        // prepare for 'Present Login'
    }

Handle a segue with identifier `push-user-page`:

    - (void)prepareForPushUserPageSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        // prepare for 'push-user-page'
    }


### Segue Block Configuration

To configure a segue where you perform it, use `-knm_performSegueWithIdentifier:sender:configureUsingBlock:`

    - (IBAction)showSettings:(id)sender {
        [self performSegueWithIdentifier:@"Show Settings" sender:sender configureUsingBlock:(UIStoryboardSegue *segue) {
            // prepare for 'Show Settings' segue
        }];
    }

The configuration block is executed before any `-perform<MyIdentifier>Segue:sender:` methods are called.


### Custom logic in `-prepareForSegue:sender:`

This category overrides `-prepareForSegue:sender:` to implement the routing. If you need to override this method in your view controller for some reason and still need the routing behavior, you need to make sure you call `[super prepareForSegue:segue sender:sender]`.