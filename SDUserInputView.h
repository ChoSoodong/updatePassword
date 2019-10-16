






#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDUserInputView : UIView

/** input */
@property (nonatomic, strong) UITextField *inputTF;


-(instancetype)initWithPlaceholder:(NSString *)placeholder secureTextEntry:(BOOL)secureTextEntry keyboardType:(UIKeyboardType)keyboardType;

@end

NS_ASSUME_NONNULL_END
