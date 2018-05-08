local Leaderboard = {};

local gameNetwork = require "gameNetwork";

Leaderboard.init = function()
    gameNetwork.init("google", function(event) 
       gameNetwork.request("login", { userInitiated=true, listener=function()  print("User logged in google game services"); end });
    end);
end

Leaderboard.showLeaderboard = function()
    gameNetwork.show("leaderboards");
end

Leaderboard.addScoreToLeaderboard = function(score)
    gameNetwork.request( "setHighScore",
    {
      localPlayerScore = { category= leaderboardCategoryID, value=tonumber(score) }, 
      listener = function() print("Score was posted"); end
    });
end

return Leaderboard;