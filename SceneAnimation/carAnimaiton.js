require('UIView,UIImage,UIImageView,UILabel,UIButton,UIFont,STUtils,UIColor,UIScreen,NSTimer,UITapGestureRecognizer,CABasicAnimation,CAAnimationGroup,NSValue,CAKeyframeAnimation,NSNumber,STTimeMeter,NSMutableDictionary,NSDictionary,NSRunLoop');
defineClass('STSceneAdPlayer', {
            start: function() {
                if (_allowStop) {
                self.addTapGestureForView_action(_logoBufferView, "logoTap");
                _curLeftMove = _logoImgLength;
                self.startLogoAnimation(_logoImgLength);
                } else {
                self.addTapGestureForView_action(_containerView, "tap");
                _curLeftMove = _bgImgLength;
                self.startBgAnimation(_bgImgLength);
                self.callback().onShow();
                }
            },
            destroy: function() {
                self.stopTimer();
            },
            stop: function() {
                self.closeBtnClicked();
            },
            resume:function(){
                self.timer().start();
            },
            pause:function() {
                self.timer().stop();
            },
            prepareInSubthread: function() {
                var dataDict = self.callback().getSceneAdData();
                _canGetView = YES;
            
                var contentDict = dataDict.valueForKey("content");
                var carImgDict = contentDict.valueForKey("carImg");
                var wheelImgDict = contentDict.valueForKey("wheelImg");
                var logoImgDict = contentDict.valueForKey("logoImg");
                var bgImgDict = contentDict.valueForKey("backImg");
                
                var carImgUrl = carImgDict.valueForKey("url");
                var wheelImgUrl = wheelImgDict.valueForKey("url");
                var logoImgUrl = logoImgDict.valueForKey("url");
                var bgImgUrl = bgImgDict.valueForKey("url");
                
                var bgImgData = self.callback().getDataFromUrl_enableCache(bgImgUrl, YES);
                var carImgData = self.callback().getDataFromUrl_enableCache(carImgUrl, YES);
                var logoImgData =
                self.callback().getDataFromUrl_enableCache(logoImgUrl, YES);
                var wheelImgData =
                self.callback().getDataFromUrl_enableCache(wheelImgUrl, YES);
                
                var bgImg = UIImage.imageWithData(bgImgData);
                var carImg = UIImage.imageWithData(carImgData);
                var logoImg = UIImage.imageWithData(logoImgData);
                var wheelImg1 = UIImage.imageWithData(wheelImgData);
            
                var closeImgUrl = "http://img.ma.social-touch.com/sdk-res/img/close.png";
                var closeImgData = self.callback().getDataFromUrl_enableCache(closeImgUrl, YES);
                var closeImg = UIImage.imageWithData(closeImgData);
                _closeImg = closeImg;
                if (!(bgImg && carImg && logoImg && wheelImg1 && closeImg)) {
                    _canGetView = NO;
                    return;
                }
                var tempDataDict =
                NSMutableDictionary.dictionaryWithDictionary(dataDict);
                var tempContentDict =
                NSMutableDictionary.dictionaryWithDictionary(contentDict);
                var tempWheelImgDict =
                NSMutableDictionary.dictionaryWithDictionary(wheelImgDict);
                tempWheelImgDict.setValue_forKey(wheelImg1, "url");
                var tempCarDict =
                NSMutableDictionary.dictionaryWithDictionary(carImgDict);
                tempCarDict.setValue_forKey(carImg, "url");
                var tempLogoImgDict =
                NSMutableDictionary.dictionaryWithDictionary(logoImgDict);
                tempLogoImgDict.setValue_forKey(logoImg, "url");
                var tempBgImgDict =
                NSMutableDictionary.dictionaryWithDictionary(bgImgDict);
                tempBgImgDict.setValue_forKey(bgImg, "url");
                
                tempContentDict.setValue_forKey(tempCarDict, "carImg");
                tempContentDict.setValue_forKey(tempWheelImgDict, "wheelImg");
                tempContentDict.setValue_forKey(tempLogoImgDict, "logoImg");
                tempContentDict.setValue_forKey(tempBgImgDict, "backImg");
                tempDataDict.setValue_forKey(tempContentDict, "content");
                _dataDict = NSDictionary.dictionaryWithDictionary(tempDataDict);
                var dict = self.callback().getExtra();
                _delayCloseTimeInterval = dict.objectForKey("sceneDelayCloseTimeout");
                _configDict = self.callback().getSceneConfig();
                var allowStop = _configDict.objectForKey("clickPopup");
                _allowStop = !allowStop;
            },
            getResizeValue: function(origineValue) {
                var screenWidth = UIScreen.mainScreen().bounds().width;
                return origineValue * screenWidth / 414.0;
            },
            getView: function() {
                if(!_canGetView) return null;
                var view = UIView.alloc().init();
                _innerView = view;
            
                var dataDict = _dataDict;
                var contentDict = dataDict.objectForKey('content');
                var carImgDict = contentDict.objectForKey('carImg');
                var wheelImgDict = contentDict.objectForKey('wheelImg');
                var logoImgDict = contentDict.objectForKey('logoImg');
                var bgImgDict = contentDict.objectForKey('backImg');
                var carImgSize = CGSizeMake(self.getResizeValue(carImgDict.objectForKey('width') / 3),
                self.getResizeValue(carImgDict.objectForKey('height') / 3));
                var wheelImgSize = CGSizeMake(self.getResizeValue(wheelImgDict.objectForKey('width') / 3),
                self.getResizeValue(wheelImgDict.objectForKey('height') / 3));
                var logoImgSize = CGSizeMake(self.getResizeValue(logoImgDict.objectForKey('width') / 3),
                self.getResizeValue(logoImgDict.objectForKey('height') / 3));
                var bgImgSize = CGSizeMake(self.getResizeValue(bgImgDict.objectForKey('width') / 3),
                self.getResizeValue(bgImgDict.objectForKey('height') / 3));
                
                var text = contentDict.objectForKey('textWriter');
                var textColor = contentDict.objectForKey('textColor');
                var xAxis1 = self.getResizeValue(contentDict.objectForKey('xAxis1') / 3);
                var yAxis1 = self.getResizeValue(contentDict.objectForKey('yAxis1') / 3);
                var xAxis2 = self.getResizeValue(contentDict.objectForKey('xAxis2') / 3);
            
                var bgImg = bgImgDict.objectForKey("url");
                var carImg = carImgDict.objectForKey("url");
                var logoImg = logoImgDict.objectForKey("url");
                var wheelImg1 = wheelImgDict.objectForKey("url");
            
                _bgView = UIImageView.alloc().initWithImage(bgImg);
                _carView = UIImageView.alloc().initWithImage(carImg);
                _logoView = UIImageView.alloc().initWithImage(logoImg);
                _wheelViewLeft = UIImageView.alloc().initWithImage(wheelImg1);
                _wheelViewRight = UIImageView.alloc().initWithImage(wheelImg1);
                _desLabel = UILabel.alloc().init();
                
                _closeBtn = UIButton.buttonWithType(0);
                _closeBtn.setImage_forState(_closeImg, 0);
                _closeBtn.addTarget_action_forControlEvents(self, "closeBtnClicked", 1<<6);
                _innerView.addSubview(_bgView);
                _innerView.addSubview(_carView);
                _innerView.addSubview(_logoView);
                _innerView.addSubview(_wheelViewLeft);
                _innerView.addSubview(_wheelViewRight);
                _innerView.addSubview(_desLabel);
                var fontSize = 14;
                if(UIScreen.mainScreen().bounds().width == 375) fontSize = 13.0;
                if (UIScreen.mainScreen().bounds().width == 320) fontSize = 11.0;
                _desLabel.setFont(UIFont.systemFontOfSize(fontSize));
                _desLabel.setText(text);
                _desLabel.setTextColor(STUtils.colorWithHexString(textColor));
            
                var wheelByCarY =
                yAxis1 + wheelImgSize.height - carImgSize.height;
                var wheelByCarLeftX = xAxis1;
                var wheelByCarRightX = xAxis2;
                var yOffSet = _configDict.objectForKey("yOffset") / 100.0;
                var containerViewY =
                UIScreen.mainScreen().bounds().height * yOffSet;
                var viewHeight =
                bgImgSize.height + carImgSize.height + wheelByCarY + self.getResizeValue(26);
                var viewWidth = bgImgSize.width + carImgSize.width;
            
                view.setBounds(CGRectMake(0, 0, viewWidth, viewHeight));
                _bgView.setFrame(CGRectMake(0, viewHeight - bgImgSize.height,
                                            bgImgSize.width, bgImgSize.height));
                _logoView.setBounds(
                                    CGRectMake(0, 0, logoImgSize.width, logoImgSize.height));

                _logoView.setCenter(CGPointMake(self.getResizeValue(logoImgSize.width/2+6), _bgView.center().y));
                _desLabel.setFrame(CGRectMake(
                                              CGRectGetMaxX(_logoView.frame()) + self.getResizeValue(3), _logoView.frame().y,
                                              bgImgSize.width - logoImgSize.width - self.getResizeValue(3), logoImgSize.height));

                _carView.setFrame(CGRectMake(
                                             CGRectGetMaxX(_bgView.frame()),
                                             CGRectGetMinY(_bgView.frame()) - wheelByCarY - carImgSize.height,
                                             carImgSize.width, carImgSize.height));
                _wheelViewLeft.setFrame(
                                        CGRectMake(CGRectGetMinX(_carView.frame()) + wheelByCarLeftX,
                                                   CGRectGetMinY(_bgView.frame()) - wheelImgSize.height,
                                                   wheelImgSize.width, wheelImgSize.height));
                _wheelViewRight.setFrame(
                                         CGRectMake(CGRectGetMinX(_carView.frame()) + wheelByCarRightX,
                                                    _wheelViewLeft.frame().y, wheelImgSize.width,
                                                    wheelImgSize.height));
                
                _closeBtn.setHidden(YES);
                _bgImgLength = bgImgSize.width;
                _logoImgLength = CGRectGetMinX(_desLabel.frame());
                
                _bgView.setUserInteractionEnabled(YES);
                _carView.setUserInteractionEnabled(YES);
                _logoView.setUserInteractionEnabled(YES);
                _wheelViewLeft.setUserInteractionEnabled(YES);
                _wheelViewRight.setUserInteractionEnabled(YES);
                
                var containerView = UIView.alloc().init();
                var screenWidth = UIScreen.mainScreen().bounds().width;
                containerView.setFrame(CGRectMake(
                                                  screenWidth - bgImgSize.width, containerViewY,
                                                  view.frame().width + bgImgSize.width, view.frame().height));
                containerView.addSubview(view);
                view.setFrame(CGRectMake(bgImgSize.width, 0, view.bounds().width,
                                         view.bounds().height));
                containerView.addSubview(_closeBtn);
                _closeBtn.setFrame(CGRectMake(bgImgSize.width - self.getResizeValue(26)-self.getResizeValue(5), 0, self.getResizeValue(26), self.getResizeValue(26)));
                _containerView = containerView;
                _isAnimationing = NO;
                _logoBufferView = UIView.alloc().initWithFrame(CGRectMake(_logoView.frame().x, _logoView.frame().y - _logoView.frame().height, _logoView.frame().width, _logoView.frame().height * 2));
                view.addSubview(_logoBufferView);
                return containerView;

        },
autoClose: function() {
            self.timer().start();
            _autoClosetimer = NSTimer.timerWithTimeInterval_target_selector_userInfo_repeats(1.0, self, "timerFunc", null, YES);
            _autoClosetimer.fire();
            NSRunLoop.currentRunLoop().addTimer_forMode(_autoClosetimer, self.NSRunLoopCommonModes());
},
timerFunc: function() {
            if (self.timer().getTotal() >= _delayCloseTimeInterval) {
                self.closeBtnAction(1);
                self.stopTimer();
                self.timer().stop();
            }else{
            if (Math.floor((self.timer().getTotal()/1000)) %5 == 0) {
                self.startLogoShakeAnimation();
                }
            }
},
addTapGestureForView_action: function(view, action) {
    var tap =
    UITapGestureRecognizer.alloc().initWithTarget_action(self, action);
    tap.setNumberOfTapsRequired(1);
    view.addGestureRecognizer(tap);
    if (view.isEqual(_logoBufferView)) {
        _logoTap = tap;
    }
    if (view.isEqual(_containerView)) {
        _containerTap = tap;
    }
},
logoTap: function() {
    self.stopTimer();
    _logoView.layer().removeAnimationForKey("logoShake");
    _bgView.layer().removeAnimationForKey("bgShake");
    _logoBufferView.removeGestureRecognizer(_logoTap);
    self.addTapGestureForView_action(_containerView, "tap");
    self.startBgAnimation(_bgImgLength - _logoImgLength);
    self.callback().onShow();
},
stopTimer: function() {
    if(typeof _autoClosetimer == "undefined") return;
    if (_autoClosetimer ) {
        _autoClosetimer.invalidate();
        _autoClosetimer = null;
    }
},
tap: function() {
    self.callback().onClick();
},
closeBtnAction: function(closeType) {
    self.callback().onClose();
    self.callback().postCloseLogWithType(closeType);
    if(_allowStop)
        self.stopTimer();
},
closeBtnClicked: function() {
    self.closeBtnAction(2);
    if(typeof _containerTap != "undefined")
        _containerView.removeGestureRecognizer(_containerTap);
},
getBasicAnimationWithkeyPath_duration_repeatCount_key_autoreverse_removedOnCompletion_fromValue_toValue_byValue_delegate: function(keyPath, duration, count, key, reverse, removed, fromValue, toValue, byValue, delegate) {
    var animation = CABasicAnimation.animation();
    animation.setKeyPath(keyPath);
    animation.setDuration(duration);
    animation.setFromValue(fromValue);
    animation.setToValue(toValue);
    animation.setByValue(byValue);
    animation.setAutoreverses(reverse);
    animation.setRepeatCount(count);
    animation.setDelegate(delegate);
    if (!removed) {
        animation.setRemovedOnCompletion(NO);
        animation.setFillMode(self.kCAFillModeForwards());
    }
    animation.setValue_forKey(key, key);
    return animation;
},
getBasicAnimationWithkeyPath_duration_key_toValue_autoreverse_removedOnCompletion_delegate: function(keyPath, duration, key, toValue, reverse, removed, delegate) {
    return self.getBasicAnimationWithkeyPath_duration_repeatCount_key_autoreverse_removedOnCompletion_fromValue_toValue_byValue_delegate(keyPath, duration, 0, key, reverse, removed, null, toValue, null, delegate);
},
getGroupAnimation_duration_key_removedOnCompletion_delegate: function(animations, duration, key, removed, delegate) {
    var group = CAAnimationGroup.animation();
    group.setAnimations(animations);
    group.setDuration(duration);
    if (!removed) {
        group.setRemovedOnCompletion(NO);
        group.setFillMode(self.kCAFillModeForwards());
    }
    group.setDelegate(delegate);
    group.setValue_forKey(key, key);
    return group;
},
jsAnimationDidStart: function(anim) {
},
jsAnimationDidStop_finished: function(anim, flag) {
    if (anim.valueForKey("bgView")) {
        if (_curLeftMove == _logoImgLength) {
            self.changeMoveFrame_length(_innerView, _bgImgLength - _logoImgLength);
        } else {
            self.changeMoveFrame_length(_innerView, _bgImgLength);
        }
        _curLeftMove = _bgImgLength;
        self.startCarAnimation(_bgImgLength + self.getResizeValue(12));
    } else if (anim.valueForKey("car")) {
        self.changeMoveFrame_length(_carView, _bgImgLength + self.getResizeValue(12));
        self.startCarStopAnimation();
    } else if (anim.valueForKey("wheelLeft")) {
        self.changeMoveFrame_length(_wheelViewLeft, _bgImgLength + self.getResizeValue(12));
    } else if (anim.valueForKey("wheelRight")) {
        self.changeMoveFrame_length(_wheelViewRight, _bgImgLength + self.getResizeValue(12));
    } else if (anim.valueForKey("logoView")) {
        self.changeMoveFrame_length(_innerView, _logoImgLength);
        self.autoClose();
    } else if (anim.valueForKey("carRotation")) {
    }
},
changeMoveFrame_length: function(view, moveLength) {
    view.setFrame({x:view.frame().x - moveLength, y:view.frame().y,
                  width:view.frame().width, height:view.frame().height});
},
applyMoveAnimation_moveLength_duration_key: function(view, length, duration, key) {
    var fromValue =
    NSValue.valueWithCGPoint(CGPointMake(view.center().x, view.center().y));
    var toValue = NSValue.valueWithCGPoint(CGPointMake(view.center().x - length, view.center().y));
    
    var animation = self.getBasicAnimationWithkeyPath_duration_repeatCount_key_autoreverse_removedOnCompletion_fromValue_toValue_byValue_delegate("position", duration, 0, key, NO, NO, fromValue, toValue, null, self);
    view.layer().addAnimation_forKey(animation, key);
},
applyMoveAndRotateAnimation_moveLength_durations_key: function(view, length, duration, key) {
    var originX = view.layer().position().x;
    var originY = view.layer().position().y;
    var value1 = NSValue.valueWithCGPoint(CGPointMake(originX, originY));
    var value2 =
    NSValue.valueWithCGPoint(CGPointMake(originX - length * 0.3, originY));
    var value3 =
    NSValue.valueWithCGPoint(CGPointMake(originX - length, originY));
    var values = [value1, value2, value3];
    
    var animation = self.getKeyFrameAnimationWithKeyPath_key_values_keyTimes_duration_repeatCount_autoreverse_removedOnCompletion_delegate("position", null, values, [(0), (0.5), (1.0)], 0, 0, NO, NO, null);
    var rotationAnimation =
    CABasicAnimation.animationWithKeyPath("transform.rotation.z");
    rotationAnimation.setByValue(
                                 NSNumber.numberWithFloat(self.PI() * 2.0 )); // byValue
    var group =
    self.getGroupAnimation_duration_key_removedOnCompletion_delegate([animation, rotationAnimation], duration, key, NO, self);
    view.layer().addAnimation_forKey(group, key);
},
startCarStopAnimation: function() {
    var animation =
    CABasicAnimation.animationWithKeyPath("transform.rotation.z");
    animation.setToValue(NSNumber.numberWithFloat(-self.PI() * 0.01));
    
    var animation2 =
    CABasicAnimation.animationWithKeyPath("position");
    animation2.setToValue(
                          NSValue.valueWithCGPoint(CGPointMake(_carView.layer().position().x - 2,
                                                               _carView.layer().position().y)));
    var group = self.getGroupAnimation_duration_key_removedOnCompletion_delegate([animation, animation2], 0.2, "carRotation", YES, self);
    _carView.layer().addAnimation_forKey(group, "carRotation");
},
applyCarAnimation: function(leftLength) {
    var animation =
    CAKeyframeAnimation.animationWithKeyPath("position");
    var originX = _carView.layer().position().x;
    var originY = _carView.layer().position().y;
    var value1 = NSValue.valueWithCGPoint(CGPointMake(originX, originY));
    var value2 = NSValue.valueWithCGPoint(CGPointMake(originX - leftLength * 0.3, originY));
    var value3 =
    NSValue.valueWithCGPoint(CGPointMake(originX - leftLength, originY));
    var values = [value1, value2, value3];
    animation.setValues(values);
    animation.setKeyTimes([(0), (0.5), (1.0)]);
    animation.setAutoreverses(NO);
    animation.setDelegate(self);
    animation.setRemovedOnCompletion(NO);
    animation.setFillMode(self.kCAFillModeForwards());
    animation.setDuration(1.5);
    animation.setValue_forKey("car", "car");
    _carView.layer().addAnimation_forKey(animation, "car");
},
startBgAnimation: function(leftLength) {
    _closeBtn.setHidden(NO);
    self.applyMoveAnimation_moveLength_duration_key(_innerView, leftLength, 1.0, "bgView");
},
startCarAnimation: function(leftLength) {
    self.applyCarAnimation(leftLength);
    self.applyMoveAndRotateAnimation_moveLength_durations_key(_wheelViewLeft, leftLength, 1.5, "wheelLeft");
    self.applyMoveAndRotateAnimation_moveLength_durations_key(_wheelViewRight, leftLength, 1.5, "wheelRight");
},
startLogoAnimation: function(leftLength) {
    self.applyMoveAnimation_moveLength_duration_key(_innerView, leftLength, 1.0, "logoView");
},
            getValusForLogoShake: function(view) {
            var originX = view.layer().position().x;
            var originY = view.layer().position().y;
            var value1 = NSValue.valueWithCGPoint(CGPointMake(originX, originY));
            var value2 = NSValue.valueWithCGPoint(CGPointMake(originX, originY + self.getResizeValue(2.5)));
            var value3 = NSValue.valueWithCGPoint(CGPointMake(originX, originY - self.getResizeValue(2.5)));
            var value4 = NSValue.valueWithCGPoint(CGPointMake(originX, originY));
            var values = [value1, value2, value3, value4];
            return values;
            },
            startLogoShakeAnimation: function() {
            var logoShakeValues =
            self.getValusForLogoShake(_logoView);
            var logoShakeAnimation =
            self.getKeyFrameAnimationWithKeyPath_key_values_keyTimes_duration_repeatCount_autoreverse_removedOnCompletion_delegate("position", "logoShake", logoShakeValues, [(0), (0.33), (0.66), (1.0)], 0.2, 1, YES, YES, self);
            var bgShakeValues = self.getValusForLogoShake(_bgView);
            var bgShakeAnimation =
            self.getKeyFrameAnimationWithKeyPath_key_values_keyTimes_duration_repeatCount_autoreverse_removedOnCompletion_delegate("position", "bgShake", bgShakeValues, [(0), (0.33), (0.66), (1.0)], 0.2, 1, YES, YES, self);
            _bgView.layer().addAnimation_forKey(bgShakeAnimation, "bgShake");
            _logoView.layer().addAnimation_forKey(logoShakeAnimation, "logoShake");
        },getKeyFrameAnimationWithKeyPath_key_values_keyTimes_duration_repeatCount_autoreverse_removedOnCompletion_delegate: function(keypath, key, values, keyTimes, duration, count, reverse, removed, delegate) {
            var animation =
            CAKeyframeAnimation.animationWithKeyPath(keypath);
            animation.setValues(values);
            animation.setKeyTimes(keyTimes);
            animation.setDuration(duration);
            animation.setRepeatCount(count);
            animation.setAutoreverses(reverse);
            if (!removed) {
            animation.setRemovedOnCompletion(NO);
            animation.setFillMode(self.kCAFillModeForwards());
            }
            animation.setDelegate(delegate);
            animation.setValue_forKey(key, key);
            return animation;
            }
});