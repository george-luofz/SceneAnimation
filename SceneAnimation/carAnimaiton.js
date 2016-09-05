require('UIView,UIImage,UIImageView,UILabel,UIButton,UIFont,STUtils,UIColor,UIScreen,NSTimer,UITapGestureRecognizer,CABasicAnimation,CAAnimationGroup,NSValue,CAKeyframeAnimation,NSNumber,STTimeMeter,NSMutableDictionary,NSDictionary,NSRunLoop');
defineClass('STSceneAdPlayer', ['allowStop','curLeftMove','logoBufferView','logoImgLength','containerView','canGetView','dataDict','closeImg','delayCloseTimeInterval','configDict','innerView','bgView','carView','logoView','wheelViewLeft','wheelViewRight','desLabel','closeBtn','bgImgLength','autoClosetimer','logoTap','containerTap'],{
            start: function() {
            console.log("cos(30)="+Math.cos(30));
            if (self.allowStop()) {
            self.addTapGestureForView_action(self.logoBufferView(), "logoTap");
            self.setCurLeftMove(self.logoImgLength());
            self.startLogoAnimation(self.logoImgLength());
            } else {
            self.addTapGestureForView_action(self.containerView(), "tap");
            self.setCurLeftMove(self.bgImgLength());
            self.startBgAnimation(self.bgImgLength());
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
            self.setCanGetView(YES);
            
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
            self.setCloseImg(closeImg);
            if (!(bgImg && carImg && logoImg && wheelImg1 && closeImg)) {
            self.setCanGetView(NO);
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
            self.setDataDict(NSDictionary.dictionaryWithDictionary(tempDataDict));
            var dict = self.callback().getExtra();
            self.setDelayCloseTimeInterval(dict.objectForKey("sceneDelayCloseTimeout"));
            self.setConfigDict(self.callback().getSceneConfig());
            var allowStop = self.configDict().objectForKey("clickPopup");
            self.setAllowStop(!allowStop);
            },
            _getResizeValue: function(origineValue) {
            var screenWidth = UIScreen.mainScreen().bounds().width;
            return origineValue * screenWidth / 414.0;
            },
            getView: function() {
            if(!self.canGetView()) return null;
            var view = UIView.alloc().init();
            self.setInnerView(view);
            
            var dataDict = self.dataDict();
            var contentDict = dataDict.objectForKey('content');
            var carImgDict = contentDict.objectForKey('carImg');
            var wheelImgDict = contentDict.objectForKey('wheelImg');
            var logoImgDict = contentDict.objectForKey('logoImg');
            var bgImgDict = contentDict.objectForKey('backImg');
            var carImgSize = CGSizeMake(self._getResizeValue(carImgDict.objectForKey('width') / 3),
                                        self._getResizeValue(carImgDict.objectForKey('height') / 3));
            var wheelImgSize = CGSizeMake(self._getResizeValue(wheelImgDict.objectForKey('width') / 3),
                                          self._getResizeValue(wheelImgDict.objectForKey('height') / 3));
            var logoImgSize = CGSizeMake(self._getResizeValue(logoImgDict.objectForKey('width') / 3),
                                         self._getResizeValue(logoImgDict.objectForKey('height') / 3));
            var bgImgSize = CGSizeMake(self._getResizeValue(bgImgDict.objectForKey('width') / 3),
                                       self._getResizeValue(bgImgDict.objectForKey('height') / 3));
            
            var text = contentDict.objectForKey('textWriter');
            var textColor = contentDict.objectForKey('textColor');
            var xAxis1 = self._getResizeValue(contentDict.objectForKey('xAxis1') / 3);
            var yAxis1 = self._getResizeValue(contentDict.objectForKey('yAxis1') / 3);
            var xAxis2 = self._getResizeValue(contentDict.objectForKey('xAxis2') / 3);
            
            var bgImg = bgImgDict.objectForKey("url");
            var carImg = carImgDict.objectForKey("url");
            var logoImg = logoImgDict.objectForKey("url");
            var wheelImg1 = wheelImgDict.objectForKey("url");
            
            self.setBgView(UIImageView.alloc().initWithImage(bgImg));
            self.setCarView(UIImageView.alloc().initWithImage(carImg));
            self.setLogoView(UIImageView.alloc().initWithImage(logoImg));
            self.setWheelViewLeft(UIImageView.alloc().initWithImage(wheelImg1));
            self.setWheelViewRight(UIImageView.alloc().initWithImage(wheelImg1));
            self.setDesLabel(UILabel.alloc().init());
            
            self.setCloseBtn(UIButton.buttonWithType(0));
            self.closeBtn().setImage_forState(self.closeImg(), 0);
            self.closeBtn().addTarget_action_forControlEvents(self, "closeBtnClicked", 1<<6);
            self.innerView().addSubview(self.bgView());
            self.innerView().addSubview(self.carView());
            self.innerView().addSubview(self.logoView());
            self.innerView().addSubview(self.wheelViewLeft());
            self.innerView().addSubview(self.wheelViewRight());
            self.innerView().addSubview(self.desLabel());
            var fontSize = 14;
            if(UIScreen.mainScreen().bounds().width == 375) fontSize = 13.0;
            if (UIScreen.mainScreen().bounds().width == 320) fontSize = 11.0;
            self.desLabel().setFont(UIFont.systemFontOfSize(fontSize));
            self.desLabel().setText(text);
            self.desLabel().setTextColor(STUtils.colorWithHexString(textColor));
            
            var wheelByCarY =
            yAxis1 + wheelImgSize.height - carImgSize.height;
            var wheelByCarLeftX = xAxis1;
            var wheelByCarRightX = xAxis2;
            var yOffSet = self.configDict().objectForKey("yOffset") / 100.0;
            var containerViewY =
            UIScreen.mainScreen().bounds().height * yOffSet;
            var viewHeight =
            bgImgSize.height + carImgSize.height + wheelByCarY + self._getResizeValue(26);
            var viewWidth = bgImgSize.width + carImgSize.width;
            
            view.setBounds(CGRectMake(0, 0, viewWidth, viewHeight));
            self.bgView().setFrame(CGRectMake(0, viewHeight - bgImgSize.height,
                                              bgImgSize.width, bgImgSize.height));
            self.logoView().setBounds(
                                      CGRectMake(0, 0, logoImgSize.width, logoImgSize.height));
            
            self.logoView().setCenter(CGPointMake(self._getResizeValue(logoImgSize.width/2+6), self.bgView().center().y));
            self.desLabel().setFrame(CGRectMake(
                                                CGRectGetMaxX(self.logoView().frame()) + self._getResizeValue(3), self.logoView().frame().y,
                                                bgImgSize.width - logoImgSize.width - self._getResizeValue(3), logoImgSize.height));
            
            self.carView().setFrame(CGRectMake(
                                               CGRectGetMaxX(self.bgView().frame()),
                                               CGRectGetMinY(self.bgView().frame()) - wheelByCarY - carImgSize.height,
                                               carImgSize.width, carImgSize.height));
            self.wheelViewLeft().setFrame(
                                          CGRectMake(CGRectGetMinX(self.carView().frame()) + wheelByCarLeftX,
                                                     CGRectGetMinY(self.bgView().frame()) - wheelImgSize.height,
                                                     wheelImgSize.width, wheelImgSize.height));
            self.wheelViewRight().setFrame(
                                           CGRectMake(CGRectGetMinX(self.carView().frame()) + wheelByCarRightX,
                                                      self.wheelViewLeft().frame().y, wheelImgSize.width,
                                                      wheelImgSize.height));
            
            self.closeBtn().setHidden(YES);
            self.setBgImgLength(bgImgSize.width);
            self.setLogoImgLength(CGRectGetMinX(self.desLabel().frame()));
            
            self.bgView().setUserInteractionEnabled(YES);
            self.carView().setUserInteractionEnabled(YES);
            self.logoView().setUserInteractionEnabled(YES);
            self.wheelViewLeft().setUserInteractionEnabled(YES);
            self.wheelViewRight().setUserInteractionEnabled(YES);
            
            var containerView = UIView.alloc().init();
            var screenWidth = UIScreen.mainScreen().bounds().width;
            containerView.setFrame(CGRectMake(
                                              screenWidth - bgImgSize.width, containerViewY,
                                              view.frame().width + bgImgSize.width, view.frame().height));
            containerView.addSubview(view);
            view.setFrame(CGRectMake(bgImgSize.width, 0, view.bounds().width,
                                     view.bounds().height));
            containerView.addSubview(self.closeBtn());
            self.closeBtn().setFrame(CGRectMake(bgImgSize.width - self._getResizeValue(26)-self._getResizeValue(5), 0, self._getResizeValue(26), self._getResizeValue(26)));
            self.setContainerView(containerView);
            self.setLogoBufferView(UIView.alloc().initWithFrame(CGRectMake(self.logoView().frame().x, self.logoView().frame().y - self.logoView().frame().height, self.logoView().frame().width, self.logoView().frame().height * 2)));
            view.addSubview(self.logoBufferView());
            return containerView;
            
            },
            autoClose: function() {
            self.timer().start();
            self.setAutoClosetimer(NSTimer.timerWithTimeInterval_target_selector_userInfo_repeats(1.0, self, "timerFunc", null, YES));
            self.autoClosetimer().fire();
            NSRunLoop.currentRunLoop().addTimer_forMode(self.autoClosetimer(),"kCFRunLoopCommonModes");
            },
            timerFunc: function() {
            if (self.timer().getTotal() >= self.delayCloseTimeInterval()) {
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
            if (view.isEqual(self.logoBufferView())) {
            self.setLogoTap(tap);
            }
            if (view.isEqual(self.containerView())) {
            self.setContainerTap(tap);
            }
            },
            logoTap: function() {
            self.stopTimer();
            self.logoView().layer().removeAnimationForKey("logoShake");
            self.bgView().layer().removeAnimationForKey("bgShake");
            self.logoBufferView().removeGestureRecognizer(self.logoTap());
            self.addTapGestureForView_action(self.containerView(), "tap");
            self.startBgAnimation(self.bgImgLength() - self.logoImgLength());
            self.callback().onShow();
            },
            stopTimer: function() {
            //    if(typeof self.autoClosetimer() == "undefined") return;
            if (self.autoClosetimer()) {
            self.autoClosetimer().invalidate();
            self.autoClosetimer() = null;
            }
            },
            tap: function() {
            self.callback().onClick();
            },
            closeBtnAction: function(closeType) {
            self.callback().onClose();
            self.callback().postCloseLogWithType(closeType);
            if(self.allowStop())
            self.stopTimer();
            },
            closeBtnClicked: function() {
            self.closeBtnAction(2);
            //    if(typeof self.containerTap() != "undefined")
            self.containerView().removeGestureRecognizer(self.containerTap());
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
            animation.setFillMode("forwards");
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
            group.setFillMode("forwards");
            }
            group.setDelegate(delegate);
            group.setValue_forKey(key, key);
            return group;
            },
            animationDidStart: function(anim) {
            },
            animationDidStop_finished: function(anim, flag) {
            if (anim.valueForKey("bgView")) {
            if (self.curLeftMove() == self.logoImgLength()) {
            self.changeMoveFrame_length(self.innerView(), self.bgImgLength() - self.logoImgLength());
            } else {
            self.changeMoveFrame_length(self.innerView(), self.bgImgLength());
            }
            self.setCurLeftMove(self.bgImgLength());
            self.startCarAnimation(self.bgImgLength() + self._getResizeValue(12));
            } else if (anim.valueForKey("car")) {
            self.changeMoveFrame_length(self.carView(), self.bgImgLength() + self._getResizeValue(12));
            self.startCarStopAnimation();
            } else if (anim.valueForKey("wheelLeft")) {
            self.changeMoveFrame_length(self.wheelViewLeft(), self.bgImgLength() + self._getResizeValue(12));
            } else if (anim.valueForKey("wheelRight")) {
            self.changeMoveFrame_length(self.wheelViewRight(), self.bgImgLength() + self._getResizeValue(12));
            } else if (anim.valueForKey("logoView")) {
            self.changeMoveFrame_length(self.innerView(), self.logoImgLength());
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
                                  NSValue.valueWithCGPoint(CGPointMake(self.carView().layer().position().x - 2,
                                                                       self.carView().layer().position().y)));
            var group = self.getGroupAnimation_duration_key_removedOnCompletion_delegate([animation, animation2], 0.2, "carRotation", YES, self);
            self.carView().layer().addAnimation_forKey(group, "carRotation");
            },
            applyCarAnimation: function(leftLength) {
            var animation =
            CAKeyframeAnimation.animationWithKeyPath("position");
            var originX = self.carView().layer().position().x;
            var originY = self.carView().layer().position().y;
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
            animation.setFillMode("forwards");
            animation.setDuration(1.5);
            animation.setValue_forKey("car", "car");
            self.carView().layer().addAnimation_forKey(animation, "car");
            },
            startBgAnimation: function(leftLength) {
            self.closeBtn().setHidden(NO);
            self.applyMoveAnimation_moveLength_duration_key(self.innerView(), leftLength, 1.0, "bgView");
            },
            startCarAnimation: function(leftLength) {
            self.applyCarAnimation(leftLength);
            self.applyMoveAndRotateAnimation_moveLength_durations_key(self.wheelViewLeft(), leftLength, 1.5, "wheelLeft");
            self.applyMoveAndRotateAnimation_moveLength_durations_key(self.wheelViewRight(), leftLength, 1.5, "wheelRight");
            },
            startLogoAnimation: function(leftLength) {
            self.applyMoveAnimation_moveLength_duration_key(self.innerView(), leftLength, 1.0, "logoView");
            },
            getValusForLogoShake: function(view) {
            var originX = view.layer().position().x;
            var originY = view.layer().position().y;
            var value1 = NSValue.valueWithCGPoint(CGPointMake(originX, originY));
            var value2 = NSValue.valueWithCGPoint(CGPointMake(originX, originY + self._getResizeValue(2.5)));
            var value3 = NSValue.valueWithCGPoint(CGPointMake(originX, originY - self._getResizeValue(2.5)));
            var value4 = NSValue.valueWithCGPoint(CGPointMake(originX, originY));
            var values = [value1, value2, value3, value4];
            return values;
            },
            startLogoShakeAnimation: function() {
            var logoShakeValues =
            self.getValusForLogoShake(self.logoView());
            var logoShakeAnimation =
            self.getKeyFrameAnimationWithKeyPath_key_values_keyTimes_duration_repeatCount_autoreverse_removedOnCompletion_delegate("position", "logoShake", logoShakeValues, [(0), (0.33), (0.66), (1.0)], 0.2, 1, YES, YES, self);
            var bgShakeValues = self.getValusForLogoShake(self.bgView());
            var bgShakeAnimation =
            self.getKeyFrameAnimationWithKeyPath_key_values_keyTimes_duration_repeatCount_autoreverse_removedOnCompletion_delegate("position", "bgShake", bgShakeValues, [(0), (0.33), (0.66), (1.0)], 0.2, 1, YES, YES, self);
            self.bgView().layer().addAnimation_forKey(bgShakeAnimation, "bgShake");
            self.logoView().layer().addAnimation_forKey(logoShakeAnimation, "logoShake");
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
            animation.setFillMode("forwards");
            }
            animation.setDelegate(delegate);
            animation.setValue_forKey(key, key);
            return animation;
            }
            });