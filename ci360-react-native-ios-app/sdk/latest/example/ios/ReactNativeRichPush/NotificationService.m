//
//  NotificationService.m
//  ReactNativeRichPush
//
//  Created by Wei Wen on 9/9/22.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    NSDictionary *notificationData = (NSDictionary*)request.content.userInfo[@"data"];
    if (notificationData == nil) {
        return;
    }
    NSString *urlStr = (NSString*)[notificationData objectForKey:@"attachment-url"];
    if (urlStr == nil) {
        return;
    }
    NSURL *fileUrl = [NSURL URLWithString:urlStr];
    if (fileUrl == nil) {
        return;
    }
    NSURLSessionDownloadTask *downloadTask = [NSURLSession.sharedSession downloadTaskWithURL:fileUrl completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (location != nil && error == nil) {
            NSString *tempDir = NSTemporaryDirectory();
            NSString *suggestedName = [response suggestedFilename];
            if (suggestedName != nil) {
                NSString *fileName = [NSString stringWithFormat:@"file://%@%@", tempDir, suggestedName];
                NSString *tempFileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
                NSURL *tempUrl = [NSURL URLWithString:tempFileName];
                NSError *removeFileError;
                
                if ([NSFileManager.defaultManager fileExistsAtPath:tempUrl.path] && [NSFileManager.defaultManager isDeletableFileAtPath:tempUrl.path]) {
                    [NSFileManager.defaultManager removeItemAtPath:tempUrl.path error:&removeFileError];
                }
                if (removeFileError != nil) return;
                
                NSError *moveFileError;
                [NSFileManager.defaultManager moveItemAtURL:location toURL:tempUrl error:&moveFileError];
                if (moveFileError != nil) return;
                
                
                NSError *attachmentError;
                UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"ci360content" URL:tempUrl options:nil error:&attachmentError];
                self.bestAttemptContent.attachments = @[attachment];
                if (attachmentError != nil) return;
            }
        }
        self.contentHandler(self.bestAttemptContent);
    }];
    [downloadTask resume];
//    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
//
//    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
