local  ads=require "ads";

local adsLib = {};

adsLib.init = function()
 if ads and showAds == true then
    ads.init("admob", admobBannerID);
  end
end

adsLib.showInterstitial = function()
 if ads and showAds == true then
    ads.show("interstitial", {appId = admobInterstitialID});
  end
end


adsLib.showBannerAd = function(position)
 if ads and showAds == true then
    local xPos, yPos, width, height;
    if position == "top" then
      xPos, yPos = display.screenOriginX, display.screenOriginY;
      if totalHeight == 568 then
        yPos = 0;
      end
    elseif position == "bottom" then
      xPos, yPos = display.screenOriginX, _G.bottomSide-40;
    end
    ads.show("banner", {interval = 50, x = xPos, y = yPos, appId = admobBannerID});
  end
end

adsLib.removeBannerAd = function()
    if ads and showAds == true then
      ads.hide();
    end
end

return adsLib;