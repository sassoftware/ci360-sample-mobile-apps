//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 React Native Demo Application                                                        #
//# File Name: JsonCreative.ts                                                                                   #
//# File Description: Defines the JSON creative model and parsing logic used to map CI360 spot payloads for rendering. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023       
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
class JsonCreative {
  title: string;
  subTitle: string;
  bullets: string[];
  buttonText: string;
  spot: string;

  constructor(json: string | null) {
    try {
      const data = JSON.parse(json);
      if (!data) {
        this.title = '';
        this.subTitle = '';
        this.bullets = [];
        this.buttonText = '';
        this.spot = '';
      } else {
        this.title = data.title;
        this.subTitle = data.subTitle;
        this.bullets = data.bullets || [];
        this.buttonText = data.buttonText;
        this.spot = data.spot;
      }
    } catch (error) {
      console.log('JSON parse error: ', error);
      this.title = '';
      this.subTitle = '';
      this.bullets = [];
      this.buttonText = '';
      this.spot = '';
    }
  }
}

export default JsonCreative;
