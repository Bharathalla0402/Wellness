//
//  MultipartViewController.m
//  Wellness
//
//  Created by think360 on 05/06/18.
//  Copyright © 2018 bharat. All rights reserved.
//

#import "MultipartViewController.h"
#import "Wellness.pch"
#import "DejalActivityView.h"

@interface MultipartViewController ()

@end

@implementation MultipartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)CheckLoginStatus
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSObject * object = [prefs objectForKey:@"UserId"];
    if(object != nil)
    {
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [currentDefaults objectForKey:@"UserId"];
        NSDictionary * token = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSString *strUserID = [NSString stringWithFormat:@"%@",[token valueForKey:@"user_id"]];
        
        NSString *strtoken;
        strtoken=[[NSUserDefaults standardUserDefaults]objectForKey:@"DeviceToken"];
        
        if (strtoken == (id)[NSNull null] || strtoken.length == 0 )
        {
            strtoken = @"1452645231";
        }
        
        NSString *strurl=[NSString stringWithFormat:@"%@%@?user_id=%@&device_id=%@",BaseUrl,@"user_login_check",strUserID,strtoken];
        NSLog(@"%@",strurl);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:strurl]];
        [request setHTTPMethod:@"GET"];
        [request addValue:@"json" forHTTPHeaderField:@"Accept"];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async (dispatch_get_main_queue(), ^{
                
                if (error)
                {
                     [DejalBezelActivityView removeView];
                } else
                {
                    if(data != nil) {
                        NSError *err;
                        NSMutableDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                        NSLog(@"%@",responseJSON);
                        NSString *strstatus=[NSString stringWithFormat:@"%@",[responseJSON valueForKey:@"status"]];
                        
                        if ([strstatus isEqualToString:@"1"])
                        {
                             [DejalBezelActivityView removeView];
                             [_delegate responsewithToken3];
                        }
                        else
                        {
                             [DejalBezelActivityView removeView];
                            [_delegate responsewithToken2];
                        }
                    }
                }
            });
        }] resume];
    }
}




- (void)next: (UIImage *)currentSelectedImage;
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //Set Params
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:120];
    [request setHTTPMethod:@"POST"];
    
    //Create boundary, it can be anything
    NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setValue:@"json" forHTTPHeaderField: @"Accept"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    
    
    NSString *FileParamConstant = @"file";
    
    
    
    NSData *imageData = UIImageJPEGRepresentation(currentSelectedImage, 0.5);
    
    
    //Assuming data is not nil we add this to the multipart form
    if (imageData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type:image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //Close off the request with the boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the request
    [request setHTTPBody:body];
    
    NSString *strRegurl=[NSString stringWithFormat:@"%@%@",BaseUrl,@"upload_profile"];
    NSLog(@"%@",strRegurl);
    // set URL
    [request setURL:[NSURL URLWithString:strRegurl]];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async (dispatch_get_main_queue(), ^{
            
            if (error)
            {
                
            } else
            {
                if(data != nil) {
                    //  [self parseJSONResponse:data];
                    
                    NSError *err;
                    
                    NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                    [_delegate responsewithToken:responseDict];
                    NSLog(@"%@",responseDict);
                    
                }
            }
        });
    }] resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
