//
//  DetailViewControllerObjC.h
//  MyPokedex
//
//  Created by Pedro  Rey Simons on 05/03/2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PokemonDetail;
@protocol DetailPresenterInterface;
@protocol DetailViewInterface;

@interface DetailViewControllerObjC : UIViewController <DetailViewInterface>

@property(strong,nonatomic) PokemonDetail* pokemonDetail;
@property(strong,nonatomic) id<DetailPresenterInterface>presenter;

@end

NS_ASSUME_NONNULL_END
