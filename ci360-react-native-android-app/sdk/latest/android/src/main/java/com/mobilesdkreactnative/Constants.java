//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 React Native Demo Application                                                        #
//# File Name: Constants.java                                                                                   #
//# File Description: Defines shared event names and ad type constants used across native module and view managers. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023       
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
package com.mobilesdkreactnative;

public class Constants {
  public static String AD_LOADED ="onAdLoaded";
  public static String AD_DEFAULT_LOADED = "onAdDefaultLoaded";
  public static String AD_LOAD_FAILED = "onAdLoadFailed";
  public static String AD_WILL_BEGIN_ACTION = "onAdWillBeginAction";
  public static String AD_ACTION_FINISHED = "onAdActionFinished";
  public static String AD_WILL_RESIZE = "onAdWillResize";
  public static String AD_RESIZE_FINISHED = "onAdResizeFinished";
  public static String AD_WILL_EXPAND = "onAdWillExpand";
  public static String AD_EXPAND_FINISHED = "onAdExpandFinished";
  public static String AD_WILL_CLOSE = "onAdWillClose";
  public static String AD_CLOSED = "onAdClosed";
  public static String TYPE_INLINE_AD = "InlineAd";
  public static String TYPE_INTERSTITIAL_AD = "InterstitialAd";

}
