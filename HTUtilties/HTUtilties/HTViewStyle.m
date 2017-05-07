//
//  UIView+HTStyle.m
//  HTUtilties
//
//  Created by John on 2017/5/7.
//  Copyright © 2017年 John. All rights reserved.
//

#import "HTViewStyle.h"
#import <objc/runtime.h>

@implementation UIView (HTStyle)

+ (UIView *(^)())newView
{
	return ^id(){
		if ([self isSubclassOfClass:[UIButton class]]) {
			return [UIButton buttonWithType:UIButtonTypeCustom];
		} else {
			return [self new];
		}
	};
}

- (HTViewStyle *)config
{
	HTViewStyle *style = nil;
	if ([self isMemberOfClass:[UIView class]]) {
		style = [HTViewStyle new];
	} else if ([self isMemberOfClass:[UILabel class]]) {
		style = [HTLabelStyle new];
	} else if ([self isMemberOfClass:[UIImageView class]]) {
		style = [HTImageViewStyle new];
	} else if ([self isMemberOfClass:[UIButton class]]) {
		style = [HTButtonStyle new];
	}
	style.owner = self;
	NSAssert(style, @"not a view or unsupported view");
	return style;
}

@end

@implementation UILabel (HTStyle)

@end

@implementation UIImageView (HTStyle)

@end

@implementation UIButton (HTStyle)

@end


@implementation HTViewStyle

- (HTViewStyle *(^)(UIView *))parent
{
	return ^id(UIView *parentView) {
		[parentView addSubview:self.owner];
		return self;
	};
}

- (HTViewStyle *(^)(UIColor *))bgColor
{
	return ^id(UIColor *bgColor) {
		self.owner.backgroundColor = bgColor;
		return self;
	};
}

- (HTViewStyle *(^)(CGFloat))corner
{
	return ^id(CGFloat radius) {
		self.owner.layer.cornerRadius = radius;
		self.owner.layer.masksToBounds = radius > 0;
		return self;
	};
}

- (HTViewStyle *(^)(UIColor *))bdColor
{
	return ^id(UIColor *color) {
		self.owner.layer.borderColor = color.CGColor;
		return self;
	};
}

- (HTViewStyle *(^)(CGFloat))bdWidth
{
	return ^id(CGFloat width) {
		self.owner.layer.borderWidth = width;
		return self;
	};
}

- (HTViewStyle *(^)(NSInteger))tag
{
	return ^id(NSInteger tag) {
		self.owner.tag = tag;
		return self;
	};
}

- (HTViewStyle *(^)(CGFloat))alpha
{
	return ^id(CGFloat alapha) {
		self.owner.alpha = alapha;
		return self;
	};
}

- (HTViewStyle *(^)(UIColor *))tint
{
	return ^id(UIColor *color) {
		self.owner.tintColor = color;
		return self;
	};
}

- (HTViewStyle *(^)(UIViewContentMode))mode
{
	return ^id(UIViewContentMode mode) {
		self.owner.contentMode = mode;
		return self;
	};
}

@end

@implementation HTLabelStyle

- (HTLabelStyle *(^)(NSString *))text
{
	return ^id(NSString *text) {
		UILabel *label = self.owner;
		label.text = text;
		return self;
	};
}

- (HTLabelStyle *(^)(NSAttributedString *))attrText
{
	return ^id(NSAttributedString *text) {
		UILabel *label = self.owner;
		label.attributedText = text;
		return self;
	};
}

- (HTLabelStyle *(^)(UIFont *))font
{
	return ^id(UIFont *font) {
		UILabel *label = self.owner;
		label.font = font;
		return self;
	};
}

- (HTLabelStyle *(^)(UIColor *))textColor
{
	return ^id(UIColor *color) {
		UILabel *label = self.owner;
		label.textColor = color;
		return self;
	};
}

- (HTLabelStyle *(^)(NSUInteger))lines
{
	return ^id(NSUInteger lines) {
		UILabel *label = self.owner;
		label.numberOfLines = lines;
		return self;
	};
}

- (HTLabelStyle *(^)(NSTextAlignment))align
{
	return ^id(NSTextAlignment align) {
		UILabel *label = self.owner;
		label.textAlignment = align;
		return self;
	};
}

@end


@implementation HTImageViewStyle

- (HTImageViewStyle *(^)(UIImage *))image
{
	return ^id(UIImage *image) {
		UIImageView *imageView = self.owner;
		imageView.image = image;
		return self;
	};
}

@end


@implementation HTButtonStyle

- (HTButtonStyle *(^)(UIImage *, UIControlState))image
{
	return ^id(UIImage *image, UIControlState state) {
		UIButton *button = self.owner;
		[button setImage:image forState:state];
		return self;
	};
}

- (HTButtonStyle *(^)(UIImage *, UIControlState))bgImage
{
	return ^id(UIImage *image, UIControlState state) {
		UIButton *button = self.owner;
		[button setBackgroundImage:image forState:state];
		return self;
	};
}

- (HTButtonStyle *(^)(NSString *, UIControlState))title
{
	return ^id(NSString *title, UIControlState state) {
		UIButton *button = self.owner;
		[button setTitle:title forState:state];
		return self;
	};
}

- (HTButtonStyle *(^)(UIColor *, UIControlState))titleColor
{
	return ^id(UIColor *color, UIControlState state) {
		UIButton *button = self.owner;
		[button setTitleColor:color forState:state];
		return self;
	};
}

- (HTButtonStyle *(^)(UIFont *))font
{
	return ^id(UIFont *font) {
		UIButton *button = self.owner;
		button.titleLabel.font = font;
		return self;
	};
}

- (HTButtonStyle *(^)(id, SEL))onClick
{
	return ^id(id target, SEL action) {
		UIButton *button = self.owner;
		[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
		return self;
	};
}

- (HTButtonStyle *(^)(void (^)(UIButton *)))clickBlock
{
	return ^id(void (^block)(UIButton *)) {
		UIButton *button = self.owner;
		[button addTarget:[self class] action:@selector(onHandler:) forControlEvents:UIControlEventTouchUpInside];
		objc_setAssociatedObject(self.owner, @"HTClickBLockKey", block, OBJC_ASSOCIATION_COPY);
		return self;
	};
}

+ (void)onHandler:(UIButton *)sender
{
	void (^block)(UIButton *) = objc_getAssociatedObject(sender, @"HTClickBLockKey");
	if (block) {
		block(sender);
	}
}

@end







