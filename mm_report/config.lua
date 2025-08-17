Config = {}

Config.AllowedGroups = {
    "admin",
    "owner"
}
Config.PlayerCommand = 'report' -- command to create report
Config.AdminCommand = 'reports' -- command to open reports menu
Config.AdminBind = 'I'          -- keybind to open reports menu
Config.Duty = 1                 -- duty system - OX-LIB NOTIFY - if 0 wont appear, if 1 will automatically appear, if 2 its disabled
Config.DutyCommand = 'duty'     -- change duty 
Config.Locale = 'sk'            -- now avaible only en, sk, you can create your own
Config.CreationTimeout = 5000   -- timeout, so players cant spam report creation (1000 = 1second)
-- there is database too, so owners can see activity of admins

-- This is created for ESX and Ox lib
-- This is my 1st script, so there high chance that there will be some bugs. If you find some, 
--please contact me on forum, or on my discord "matus5099". Feel Free to edit