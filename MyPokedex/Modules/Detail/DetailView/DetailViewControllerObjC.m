//
//  DetailViewControllerObjC.m
//  MyPokedex
//
//  Created by Pedro  Rey Simons on 05/03/2021.
//
#import "MyPokedex-Swift.h"
#import "DetailViewControllerObjC.h"

@interface DetailViewControllerObjC ()

@end

@implementation DetailViewControllerObjC{
    //Crete containers for layout views
    
    UIView  * spriteImgContainer;
    UIImageView  * spriteImgVw;
    
    UIView * nameContainer;
    UIButton * btnLblName;
    
    UIView * typeContainer;
    UIStackView * stVwType;
    
    UIView * statsContainer;
    UIStackView * stVwStats;
    
    UIView * capturedContainer;
    UISwitch * switchCaptured;
    
    NSMutableArray<NSLayoutConstraint*> * landscapeConstraints;
    NSMutableArray<NSLayoutConstraint*> * portraitConstraints;
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    [self setupView];
    [self setupConstraints];
    [self activateConstraints];
    [self.presenter viewDidLoad];
}

//Device rotates
-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange: previousTraitCollection];
    if ((self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass)
        || (self.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass)) {
        [self activateConstraints];
    }
}

-(void)setupNavigationItem{
    //Add delete button
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(rightBarButtonPressed)]];
}

-(void)setupView{
    [self setupImgContainer];
    [self.view addSubview:spriteImgContainer];
    
    [self setupNameContainer];
    [self.view addSubview:nameContainer];
    
    [self setupTypeContainer];
    [self.view addSubview:typeContainer];
    
    [self setupStatsContainer];
    [self.view addSubview:statsContainer];
    
    [self setupCapturedContainer];
    [self.view addSubview:capturedContainer];
    
    [self.view setBackgroundColor:[ThemeManagerObjC quaternaryColor]];
}


//MARK:- imgVw
-(void)setupImgContainer{
    spriteImgVw = [[UIImageView alloc] init];
    [spriteImgVw setTranslatesAutoresizingMaskIntoConstraints:NO];
    [spriteImgVw.layer setCornerRadius:8];
    [spriteImgVw setBackgroundColor:[ThemeManagerObjC.tertiaryColor colorWithAlphaComponent:0.25]];
    [spriteImgVw setContentMode:UIViewContentModeScaleAspectFit];
    
    spriteImgContainer = [self stackViewContainerWithDistribution:UIStackViewDistributionFill
                                                   withInsets:UIEdgeInsetsMake(8,8,0,8)
                                                     withAxis:UILayoutConstraintAxisHorizontal
                                                  withSpacing:0.0
                                                 withSubviews:@[spriteImgVw]
                                          withSubviewCentered:NO];
}


//MARK:- lblName
-(void)setupNameContainer{
    btnLblName = [self buttonLabel:[ThemeManagerObjC secondaryColor] withInsets:UIEdgeInsetsMake(4, 12, 4, 12) withCornerRadius:8];
    [btnLblName.titleLabel setFont:[UIFont boldSystemFontOfSize:40]];
    
    nameContainer = [self stackViewContainerWithDistribution:UIStackViewDistributionFill
                                                     withInsets:UIEdgeInsetsMake(0,0,0,0)
                                                       withAxis:UILayoutConstraintAxisHorizontal
                                                    withSpacing:0.0
                                                   withSubviews:@[btnLblName]
                                            withSubviewCentered:YES];
}


//MARK:- stVwTypes
-(void)setupTypeContainer{
    stVwType = [[UIStackView alloc]init];
    [stVwType setDistribution:UIStackViewDistributionFillEqually];
    [stVwType setSpacing:16];
    
    typeContainer = [self stackViewContainerWithDistribution:UIStackViewDistributionFill
                                                       withInsets:UIEdgeInsetsMake(0,0,0,0)
                                                         withAxis:UILayoutConstraintAxisHorizontal
                                                      withSpacing:0
                                                     withSubviews:@[stVwType]
                                              withSubviewCentered:YES];
}


//MARK:- stVwStats
-(void)setupStatsContainer{
    stVwStats = [[UIStackView alloc]init];
    [stVwStats setDistribution:UIStackViewDistributionFillEqually];
    [stVwStats setAxis:UILayoutConstraintAxisVertical];
    [stVwStats setSpacing:0];
    
    statsContainer = [self stackViewContainerWithDistribution:UIStackViewDistributionFillEqually
                                                   withInsets:UIEdgeInsetsMake(8,8,8,8)
                                                     withAxis:UILayoutConstraintAxisHorizontal
                                                  withSpacing:0
                                                 withSubviews:@[stVwStats]
                                          withSubviewCentered:NO];
    
}


//MARK:- stVwCaptured
-(void)setupCapturedContainer{
    
    UIButton * capturedText = [self buttonLabel:UIColor.clearColor withInsets:UIEdgeInsetsMake(0, 0, 0, 0) withCornerRadius:4];
    [capturedText setTitle:NSLocalizedString(@"Captured:", nil) forState:UIControlStateNormal];
    [capturedText.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [capturedText setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [capturedText setTitleColor:ThemeManagerObjC.primaryColor forState:UIControlStateNormal];
    
    UIImageView* pokeballImageView = [[UIImageView alloc]init];
    [pokeballImageView setContentMode:UIViewContentModeScaleAspectFit];
    [pokeballImageView setImage:[UIImage imageNamed:Constants.objcPokeball]];
    [[pokeballImageView.widthAnchor constraintEqualToAnchor:pokeballImageView.heightAnchor] setActive:YES];

    switchCaptured = [[UISwitch alloc]init];
    [switchCaptured setUserInteractionEnabled:NO];
    [switchCaptured addTarget:self action:@selector(capturedSwitchChange) forControlEvents:UIControlEventValueChanged];

    capturedContainer = [self stackViewContainerWithDistribution:UIStackViewDistributionFill
                                                   withInsets:UIEdgeInsetsMake(8,16,16,16)
                                                     withAxis:UILayoutConstraintAxisHorizontal
                                                  withSpacing:8
                                                 withSubviews:@[pokeballImageView,capturedText,switchCaptured]
                                          withSubviewCentered:NO];
}


//MARK:- CONSTRAINTS
-(void)setupConstraints{
    NSLayoutYAxisAnchor* top = self.view.safeAreaLayoutGuide.topAnchor;
    NSLayoutXAxisAnchor* lead = self.view.safeAreaLayoutGuide.leadingAnchor;
    NSLayoutYAxisAnchor* bottom = self.view.safeAreaLayoutGuide.bottomAnchor;
    NSLayoutXAxisAnchor* trail =  self.view.safeAreaLayoutGuide.trailingAnchor;
    
    NSLayoutDimension* height = self.view.safeAreaLayoutGuide.heightAnchor;
    ///NSLayoutDimension* width =  self.view.safeAreaLayoutGuide.widthAnchor;
    
    portraitConstraints = [[NSMutableArray alloc]init];
    landscapeConstraints = [[NSMutableArray alloc]init];
    
    //REGULAR (Portait)
    [portraitConstraints addObjectsFromArray:@[
        [spriteImgContainer.leadingAnchor constraintEqualToAnchor:lead],
        [nameContainer.leadingAnchor constraintEqualToAnchor:lead],
        [typeContainer.leadingAnchor constraintEqualToAnchor:lead],
        [statsContainer.leadingAnchor constraintEqualToAnchor:lead],
        [capturedContainer.leadingAnchor constraintEqualToAnchor:lead],
        
        [spriteImgContainer.trailingAnchor constraintEqualToAnchor:trail],
        [nameContainer.trailingAnchor constraintEqualToAnchor:trail],
        [typeContainer.trailingAnchor constraintEqualToAnchor:trail],
        [statsContainer.trailingAnchor constraintEqualToAnchor:trail],
        [capturedContainer.trailingAnchor constraintEqualToAnchor:trail],
        
        [spriteImgContainer.topAnchor         constraintEqualToAnchor:top],
        [nameContainer.topAnchor       constraintEqualToAnchor:spriteImgContainer.bottomAnchor],
        [typeContainer.topAnchor     constraintEqualToAnchor:nameContainer.bottomAnchor],
        [statsContainer.topAnchor     constraintEqualToAnchor:typeContainer.bottomAnchor],
        [capturedContainer.topAnchor  constraintEqualToAnchor:statsContainer.bottomAnchor],
        [capturedContainer.bottomAnchor constraintEqualToAnchor:bottom],
        
        //FREE [imgVwContainer.heightAnchor          constraintEqualToConstant:],
        [nameContainer.heightAnchor        constraintEqualToAnchor:height multiplier:0.15],
        [typeContainer.heightAnchor      constraintEqualToAnchor:height multiplier:0.1],
        [statsContainer.heightAnchor      constraintEqualToAnchor:height multiplier:0.35],
        [capturedContainer.heightAnchor   constraintEqualToAnchor:height multiplier:0.1]
    ]];
    
    //COMPACT (Landscape)
    [landscapeConstraints addObjectsFromArray:@[
        [spriteImgContainer.leadingAnchor         constraintEqualToAnchor:lead],
        [nameContainer.leadingAnchor       constraintEqualToAnchor:lead],
        [typeContainer.leadingAnchor     constraintEqualToAnchor:lead],
        [statsContainer.leadingAnchor     constraintEqualToAnchor:spriteImgContainer.trailingAnchor],
        [capturedContainer.leadingAnchor  constraintEqualToAnchor:spriteImgContainer.trailingAnchor],
        
        [spriteImgContainer.trailingAnchor        constraintEqualToAnchor:capturedContainer.leadingAnchor],
        [nameContainer.trailingAnchor      constraintEqualToAnchor:capturedContainer.leadingAnchor],
        [typeContainer.trailingAnchor    constraintEqualToAnchor:capturedContainer.leadingAnchor],
        [statsContainer.trailingAnchor    constraintEqualToAnchor:trail],
        [capturedContainer.trailingAnchor constraintEqualToAnchor:trail],
        
        [spriteImgContainer.topAnchor         constraintEqualToAnchor:top],
        [nameContainer.topAnchor       constraintEqualToAnchor:spriteImgContainer.bottomAnchor],
        [typeContainer.topAnchor     constraintEqualToAnchor:nameContainer.bottomAnchor],
        [statsContainer.topAnchor     constraintEqualToAnchor:top],
        [capturedContainer.topAnchor  constraintEqualToAnchor:statsContainer.bottomAnchor],
        
        [typeContainer.bottomAnchor     constraintEqualToAnchor:bottom],
        [capturedContainer.bottomAnchor constraintEqualToAnchor:bottom],
        
        [spriteImgContainer.widthAnchor           constraintEqualToAnchor:capturedContainer.widthAnchor],
        [nameContainer.widthAnchor         constraintEqualToAnchor:capturedContainer.widthAnchor],
        [typeContainer.widthAnchor       constraintEqualToAnchor:capturedContainer.widthAnchor],
        [statsContainer.widthAnchor       constraintEqualToAnchor:capturedContainer.widthAnchor],
        [capturedContainer.widthAnchor    constraintEqualToAnchor:capturedContainer.widthAnchor],
        
        //FREE [imgVwContainer.heightAnchor       constraintEqualToConstant:],
        [nameContainer.heightAnchor        constraintEqualToAnchor:height multiplier:0.25],
        [typeContainer.heightAnchor      constraintEqualToAnchor:height multiplier:0.2],
        //FREE [stVwStatsContainer.heightAnchor      constraintEqualToAnchor:height multiplier:0.75],
        [capturedContainer.heightAnchor   constraintEqualToAnchor:height multiplier:0.2]
    ]];
    
}

-(void)activateConstraints{
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].windows.firstObject.windowScene.interfaceOrientation)){
        //Is Landscape
        [NSLayoutConstraint deactivateConstraints:portraitConstraints];
        [NSLayoutConstraint activateConstraints:landscapeConstraints];
    }  else  {
        //Is  Portrait
        [NSLayoutConstraint deactivateConstraints:landscapeConstraints];
        [NSLayoutConstraint activateConstraints:portraitConstraints];
    }
}


//MARK:- Factory stackViewContainer
//Container View with stackView inside for layout
-(UIView*)stackViewContainerWithDistribution:(UIStackViewDistribution)distribution
                                  withInsets:(UIEdgeInsets)insets
                                    withAxis:(UILayoutConstraintAxis)axis
                                 withSpacing:(CGFloat)spacing
                                withSubviews:(NSArray*)subviews
                         withSubviewCentered:(BOOL)centered{
    UIView * container = [[UIView alloc] init];
    [container setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIStackView * stackView = [[UIStackView alloc]init];
    [stackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [stackView setDistribution:distribution];
    [stackView setSpacing:spacing];
    [stackView setAxis:axis];
    
    [container addSubview:stackView];
    if (centered){
        [stackView anchorWithTop:nil leading:nil bottom:nil trailing:nil centerX:container.centerXAnchor centerY:container.centerYAnchor padding:UIEdgeInsetsZero size:CGSizeZero];
    }else{
        [stackView anchorWithTop:container.topAnchor leading:container.leadingAnchor bottom:container.bottomAnchor trailing:container.trailingAnchor centerX:nil centerY:nil padding:insets size:CGSizeZero];
    }
    
    for (UIView* subview in subviews) {
        [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
        [stackView addArrangedSubview:subview];
    }
    
    return container;
}


//MARK:- Factory buttonLabel
//UIButton to be used as Label for UI Convenience
-(UIButton*)buttonLabel:(UIColor*)color
             withInsets:(UIEdgeInsets)insets
       withCornerRadius:(CGFloat)radius{
    
    UIButton* labelButton = [[UIButton alloc]init];
    [labelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [labelButton.layer setCornerRadius:radius];
    [labelButton setTitle:@"Text" forState:UIControlStateNormal];
    [labelButton setTitleColor:[ThemeManagerObjC titleTextColor] forState:UIControlStateNormal];
    [labelButton setContentEdgeInsets:insets];
    [labelButton setUserInteractionEnabled:NO];
    
    [labelButton setBackgroundColor: color];
    [labelButton.titleLabel setAdjustsFontSizeToFitWidth:YES];

    
    return  labelButton;
}


//MARK:- DetailViewInterface -
-(void)showWithPokemonDetail:(PokemonDetail * _Nonnull)pokemonDetail {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->spriteImgVw setImage:[UIImage imageWithData:pokemonDetail.defaultImage]];
        [self->btnLblName setTitle:pokemonDetail.name forState:UIControlStateNormal];
        [self fillStVwTypesWith:pokemonDetail.types];
        [self fillStVwStatsWith:pokemonDetail.stats];
        [self activateSwitchWithCapturedStatus:[pokemonDetail isThisPokemonCaptured]];
        [self.navigationItem setTitle:pokemonDetail.name.capitalizedString];

    });
}

-(void)undoCapturedSwitchChange{
    [switchCaptured setOn:!switchCaptured.isOn];
}

-(void)fillStVwTypesWith:(NSArray<Types*>*)tipos{
    for (Types* tipo in tipos) {
        NSString* typeName = [tipo.type valueForKey:@"name"];
        UIButton * btnLblType = [self buttonLabel:[self colorForType:typeName] withInsets:UIEdgeInsetsMake(4, 24, 4, 24) withCornerRadius:8];
        [btnLblType setTitle:typeName.capitalizedString forState:UIControlStateNormal];
        [btnLblType.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [stVwType addArrangedSubview:btnLblType];
    }
}

-(void)fillStVwStatsWith:(NSArray<Stat*>*)stats{
    for (Stat* stat in stats) {
        NSString* statName  = [stat.stat valueForKey:@"name"];
        NSString* statText  = [NSString stringWithFormat:@"%@:",statName];
        NSString* statValue = [NSString stringWithFormat:@"%ld", (long)stat.base_stat];
        
        
        UIStackView * stVwStat = [[UIStackView alloc]init];
        [stVwStat setAxis:UILayoutConstraintAxisHorizontal];
        [stVwStat setDistribution:UIStackViewDistributionEqualSpacing];
        [stVwStat.layer setBorderColor:[ThemeManagerObjC.tertiaryColor colorWithAlphaComponent:0.15].CGColor];
        [stVwStat.layer setBorderWidth:1];
        [stVwStat.layer setCornerRadius:2.0];

        
        UIButton * btnLblStatText = [self buttonLabel:UIColor.clearColor withInsets:UIEdgeInsetsMake(0, 8, 0, 8) withCornerRadius:4];
        [btnLblStatText setTitle:statText.capitalizedString forState:UIControlStateNormal];
        [btnLblStatText.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [btnLblStatText.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [btnLblStatText setTitleColor:[self colorForStat:statName] forState:UIControlStateNormal];

        
        UIButton * btnLblStatValue = [self buttonLabel:UIColor.clearColor withInsets:UIEdgeInsetsMake(0, 8, 0, 8) withCornerRadius:4];
        [btnLblStatValue setTitle: statValue forState:UIControlStateNormal];
        [btnLblStatValue.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [btnLblStatValue setTitleColor:ThemeManagerObjC.primaryColor forState:UIControlStateNormal];

        
        [stVwStat addArrangedSubview:btnLblStatText];
        [stVwStat addArrangedSubview:btnLblStatValue];

        [stVwStats addArrangedSubview:stVwStat];

    }
}

-(void)activateSwitchWithCapturedStatus:(NSNumber*)status{
    BOOL isCaptured = status.boolValue;
    [switchCaptured setUserInteractionEnabled:YES];
    [switchCaptured setOn:isCaptured];
    
}

//MARK:- UserActions -
-(void)rightBarButtonPressed{
    [self.presenter rightBarButtonPressed];
}

-(void)capturedSwitchChange{
    [self.presenter switchControlChangedWithIsCaptured:switchCaptured.isOn];
}

//MARK:- Colors -
-(UIColor*)colorForType:(NSString*)typeName{
    //With a Viper Architecture it would be better to obtain the UIcolor directly from the interactor, but this is a nice piece of code to use for an Obj-C enviroment.
    //Convenience Objective-C function for replacing C intenger based switch, allowing to work as a Switch for String values.
    typedef UIColor*(^CaseBlock)(void);
    NSDictionary *typeColorDict = @{
        @"normal"   : ^{ return [[UIColor alloc]initWithHex:@"#A8A77A"];},
        @"fire"     : ^{ return [[UIColor alloc]initWithHex:@"#EE8130"];},
        @"water"    : ^{ return [[UIColor alloc]initWithHex:@"#6390F0"];},
        @"electric" : ^{ return [[UIColor alloc]initWithHex:@"#F7D02C"];},
        @"grass"    : ^{ return [[UIColor alloc]initWithHex:@"#7AC74C"];},
        @"ice"      : ^{ return [[UIColor alloc]initWithHex:@"#96D9D6"];},
        @"fighting" : ^{ return [[UIColor alloc]initWithHex:@"#C22E28"];},
        @"poison"   : ^{ return [[UIColor alloc]initWithHex:@"#A33EA1"];},
        @"ground"   : ^{ return [[UIColor alloc]initWithHex:@"#E2BF65"];},
        @"flying"   : ^{ return [[UIColor alloc]initWithHex:@"#A98FF3"];},
        @"psychic"  : ^{ return [[UIColor alloc]initWithHex:@"#F95587"];},
        @"bug"      : ^{ return [[UIColor alloc]initWithHex:@"#A6B91A"];},
        @"rock"     : ^{ return [[UIColor alloc]initWithHex:@"#B6A136"];},
        @"ghost"    : ^{ return [[UIColor alloc]initWithHex:@"#735797"];},
        @"dragon"   : ^{ return [[UIColor alloc]initWithHex:@"#6F35FC"];},
        @"dark"     : ^{ return [[UIColor alloc]initWithHex:@"#705746"];},
        @"steel"    : ^{ return [[UIColor alloc]initWithHex:@"#B7B7CE"];},
        @"fairy"    : ^{ return [[UIColor alloc]initWithHex:@"#D685AD"];},
    };
    CaseBlock caseBlockColor = typeColorDict[typeName];
    if (caseBlockColor != nil){
        return caseBlockColor();
    } else {
        return UIColor.grayColor; //Default
    }
}

-(UIColor*)colorForStat:(NSString*)statName{
    //With a Viper Architecture it would be better to obtain the UIcolor directly from the interactor, but this is a nice piece of code to use for an Obj-C enviroment.
    //Convenience Objective-C function for replacing C intenger based switch, allowing to work as a Switch for String values.
    typedef UIColor*(^CaseBlock)(void);
    NSDictionary *statColorDict = @{
        @"hp" :             ^{ return [[UIColor alloc]initWithHex:@"#7AC74C"];},
        @"attack" :         ^{ return [[UIColor alloc]initWithHex:@"#fc4b4b"];},
        @"special-attack":  ^{ return [[UIColor alloc]initWithHex:@"#fc3232"];},
        @"defense":         ^{ return [[UIColor alloc]initWithHex:@"#6390F0"];},
        @"special-defense": ^{ return [[UIColor alloc]initWithHex:@"#5082ed"];},
        @"speed":           ^{ return [[UIColor alloc]initWithHex:@"#f7c600"];},
    };
    CaseBlock caseBlockColor = statColorDict[statName];
    if (caseBlockColor != nil){
        return caseBlockColor();
    } else {
        return UIColor.grayColor; //Default
    }
}

@end
