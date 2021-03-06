### Description
GTWchat was mainly build for our RPG server, but later on we felt like some of the chats could be useful 
on other GTW servers as well, by that we started to improve it's compatibility with other servers, chat's 
will automatically be usable as long required features are running, central and global settings makes it 
easy to modify as well as customize if needed.

<br>
**Functions available**

`cleanUpChat()`  
_(server) "onPlayerQuit" cleans the antispam data tables to save RAM._

`bindLocalChat()`  
_(server) "onPlayerJoin" Bind the "u" key to local chat._

`isPlayerInRangeOfPoint(player plr, int x, int y, int z, int range)`  
_(server) Check if a player is within the radar disk area._

`initChat()`  
_(server) "onResourceStart" Bind the "u" key to local chat for all players._

`isServerStaff(player plr)`  
_(server) Check if a player is a member of any staff ACL group._

`validateChatInput(player plr, string chatID, string text)`  
_(server) Does all the checks for spam, mutes and other custom requirements to determine if a message should be shown or not._

`IRCMessageReceive(element channel, string message)`  
_(server) "onIRCMessage", this is optional but if you have the irc module installed you will also see messages from the IRC channel._

`useLocalChat(player plr, string cmd, ...)`  
_(server) Local chat is seen to any player within the radar disk._

`useCarChat(player plr, string cmd, ...)`  
_(server) Check if a player is within the radar disk area._

`useEmergencyChat(player plr, string cmd, ...)`  
_(server) Optional, if you have special teams (defined at top) in this case law, multiple teams can share a chat._

`useGroupChat(player plr, string cmd, ...)`  
_(server) Optional, group chat, you need a group system that store the group name as element data: "Group"._

`useStaffChat(player plr, string cmd, ...)`  
_(server) Optional, if your server has staff defined by ACL, this is a private staff chat no matter which team they are in._

`useActionChatDo(player plr, string cmd, ...)`  
_(server) Roleplay action chat /do <action>._

`useGlobalChat(string message, int messageType)`  
_(server) "onPlayerChat" Main, team and /me action chats, triggered by event._

`displayChatBubble(string message, int messagetype, player plr)`  
_(server) Display chatbubbles client side, default applied to main, team and local chats._

<br>
**Exported functions**

None, _This resource doesn't have any exported functions._


<br>
**Requirements**

GTWtopbar<br>
(Optional) GTWgroupsys (private license)<br>
(Optional) irc (available at wiki.mtasa.com)
