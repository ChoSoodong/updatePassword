




//修改密码
#import "SDMineChangePsdController.h"
#import "SDUserInputView.h"


@interface SDMineChangePsdController ()

/** 原密码 */
@property (nonatomic, strong) SDUserInputView *oldPassView;
/** 新密码 */
@property (nonatomic, strong) SDUserInputView *newpassView;
/** 新密码 */
@property (nonatomic, strong) SDUserInputView *againPassView;
/** 确认 */
@property (nonatomic, strong) UIButton *sureBtn;


@end

@implementation SDMineChangePsdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackButtonAndMiddleTitle:@"修改密码" addBackBtn:YES isWhite:NO];
    
    [self setupUI];
}

-(void)setupUI{
    
    
    _oldPassView = [[SDUserInputView alloc] initWithPlaceholder:@"输入原密码" secureTextEntry:YES keyboardType:UIKeyboardTypeDefault];
    [self.view addSubview:_oldPassView];
    [_oldPassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KScaleW(23));
        make.right.offset(-KScaleW(38));
        make.height.offset(KScaleW(45));
        make.top.offset(KScaleW(12)+NAVIGATION_HEIGHT);
        
    }];
    
    
    _newpassView = [[SDUserInputView alloc] initWithPlaceholder:@"输入新密码(由6-8位字母和数字组成)" secureTextEntry:YES keyboardType:UIKeyboardTypeDefault];
    [self.view addSubview:_newpassView];
    [_newpassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KScaleW(23));
        make.right.offset(-KScaleW(38));
        make.height.offset(KScaleW(45));
        make.top.equalTo(self.oldPassView.mas_bottom).offset(KScaleW(26));
        
    }];
    
    
    _againPassView = [[SDUserInputView alloc] initWithPlaceholder:@"再次输入" secureTextEntry:YES keyboardType:UIKeyboardTypeDefault];
    [self.view addSubview:_againPassView];
    [_againPassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KScaleW(23));
        make.right.offset(-KScaleW(38));
        make.height.offset(KScaleW(45));
        make.top.equalTo(self.newpassView.mas_bottom).offset(KScaleW(26));
        
    }];
    
    
    _sureBtn = [UIButton buttonWithHighlightedTitle:@"提交" highlightColor:white_color highlightImageName:nil highlightBackgroundImageName:@"login_btn_blue_bg" normalTitle:@"提交" normalColor:white_color normalImageName:nil normalBackgroundImageName:@"login_btn_blue_bg" font:AdjustFont(16)];
    [_sureBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sureBtn];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(KScaleW(300));
        make.height.offset(KScaleW(44));
        make.top.equalTo(self.againPassView.mas_bottom).offset(KScaleW(32));
        make.centerX.offset(0);
    }];
    
}
/**
 提交
 */
-(void)loginBtnClick:(UIButton *)sender{
    NSLog(@"提交");
    
    //判断是否登录
    if ([SDFileTool checkLoginStatus]) {
        
        if (IsEmptyString(self.oldPassView.inputTF.text)) {
            [EasyHUD showInfoText:@"请输入原密码"];
        }else if(IsEmptyString(self.newpassView.inputTF.text)){
            [EasyHUD showInfoText:@"请输入新密码"];
            
        }else if(IsEmptyString(self.againPassView.inputTF.text)){
            [EasyHUD showInfoText:@"请再次输入新密码"];
        }else{
            
            if (![self.newpassView.inputTF.text checkPasswordWithMinLenth:KPsdMinLength maxLenth:KPsdMaxLength]) {
                [EasyHUD showInfoText:@"密码由6-8位字母和数字组成"];
            }else if([self.newpassView.inputTF.text isEqualToString:self.againPassView.inputTF.text]){
                
                //修改密码
                [self updatePasswordData];
                
            }else{
                [EasyHUD showInfoText:@"两次的密码不一致"];
            }
            
        }
        
        
    }else{
        //没有登录
        SDNavigationController *nav = [[SDNavigationController alloc] initWithRootViewController:[SDLoginController new]];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}


/**
 修改密码
 */
-(void)updatePasswordData{
    
    SDLoginModel *loginModel = [SDFileTool getObjectByFileName:LOGIN_MODEL];
    if (IsEmptyObject(loginModel)) {
        return;
    }
    
    NSDictionary *params = @{
                             @"userId"      : loginModel.id,
                             @"oldPsd"      : self.oldPassView.inputTF.text,
                             @"userNewPsd"  : self.newpassView.inputTF.text
                             };
    
    WeakSelf;
    [NetWorkTool POSTWithURL:API_UpdateUserPsd parameters:params cachePolicy:CachePolicyIgnoreCache callback:^(id responseObject, NSError *error) {
        
        if (error == nil) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            if ([dict[@"result"] boolValue]) {
                
                [EasyHUD showSuccessText:dict[@"msg"]];
                
                //更新用户数据
                [SDGetUserInfoRequest getUserInfoDataByUserId:loginModel.id completion:^(SDLoginModel * _Nonnull loginModel) {
                    
                }];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
                
            }else{
                
                [EasyHUD showErrorText:dict[@"msg"]];
                
            }

        }else{
            
            [EasyHUD showText:@"网络异常,请重试"];
        }
        
        
    }];
}

@end
