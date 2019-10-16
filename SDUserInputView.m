





#import "SDUserInputView.h"

@interface SDUserInputView()


/** line */
@property (nonatomic, strong) UIView *inputLine;

@end

@implementation SDUserInputView

-(instancetype)initWithPlaceholder:(NSString *)placeholder secureTextEntry:(BOOL)secureTextEntry keyboardType:(UIKeyboardType)keyboardType{
    if (self = [super init]) {
        
        _inputTF = [UITextField textFieldWithTextColor:KRGB_51 font:AdjustFont(16) secureTextEntry:secureTextEntry placeholder:placeholder placeholderColor:RGB(215, 215, 215) keyboardType:keyboardType clearButtonImageName:@"cancel_btn" leftImageName:nil];
        [_inputTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_inputTF];
        [_inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(0);
            make.top.offset(0);
            make.bottom.offset(-1);
            
        }];
        
        _inputLine = [UIView viewWithBackgroundColor:KRGB_240];
        [self addSubview:_inputLine];
        [_inputLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(KScaleW(15));
            make.right.offset(0);
            make.height.offset(1);
            make.bottom.offset(0);
        }];
        
        
        
    }
    return self;
}

-(void)textFieldDidChange:(UITextField *)textField{
    
    if (!IsEmptyString(textField.text)) {
        self.inputLine.backgroundColor = KThemeBlue;
    }else{
        self.inputLine.backgroundColor = KRGB_240;
    }
    
}


@end
