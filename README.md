```
******************************************
*                                        *
*   AIBACKUP REMASTERED by MajorFivePD   *
*                                        *
******************************************
```
Credits to him: [Mooreiche](https://github.com/Mooreiche/AIBackup) 
(**His code did not received any update since 3 years ago, so I thought that maybe someone needs this resource but with the fixes and new possibilities.**)


# **[PATROL UNIT PREVIEW](https://www.youtube.com/watch?v=gXKo5G4lU_4)**
# **[AIR UNIT (NEW) - PREVIEW](https://www.youtube.com/watch?v=PcPQ2wpQlq0)**




# Installation: drag "AIBackupRemaster" to your server resources folder and add to your server.cfg "ensure AIBackupRemaster" 
**[Do not rename the folder and copy the exactly name into the server.cfg]**

> # To call Patrol Unit Backup: /aib or "+" in your NUMPAD 
> # To call Air Unit: /aib2 
> **[Only able to call Air Unit via chat command]**
> **[Controller Support in this resource disabled to avoid issues while using controller]**

# CHANGES | BUG FIXES | NEW FUNCTION:

*  **KNOWN BUGS FIXED:**

      * **Fixed Relationship issue where nearby random npcs starts following you endless after you call or end the backup.**

     *  **Fixed Relationship issue where the backup cop would try to enter your vehicle constantly, following you forever and never going away when they were cancelled.**

   *  **Added new function so when you cancel the backup, the cop will get in their vehicle and drive away in the traffic.**

   * **Changed the backup so instead of going to your coords, the cop will follow you with lights/sirens on in a safe distance allowing pursuits to take place, and he will only leave the vehicle if you or him is being threatened/shot by enemies.**


* **ADDED NEW BACKUP -> AIR UNIT (POLMAV)**
    
   **Air Unit will follow you realistically at safe height (always will overcome and pilot safe to follow professionally) and it's able to pilot between skyscrapers/tall buildings and will use spotlight at night being fully immersive**

# **[AIR UNIT (NEW) - PREVIEW](https://www.youtube.com/watch?v=gXKo5G4lU_4)**


# CONFIGURATION:
   * **In the "variables" section, you ONLY can change these values:**


```
-- variables --
police        = GetHashKey('police3') -- You can add any vehicle here, replace or addon.
policeman     = GetHashKey("s_m_y_cop_01") -- You can add any ped here.

            local mode = -1  -- 0 for ahead, -1 = behind , 1 = left, 2 = right, 3 = back left, 4 = back right  
            local speed = 50.0 -- Modify the backup maximum speed when following you.
            local minDistance = 4.0 -- Default safe distance set by me, you can change it here.
            local p7 = 0 -- Do not touch here
            local noRoadsDistance = 0.0 -- Do not touch here

```


Credits: https://github.com/Mooreiche/AIBackup
  My Github: https://github.com/dsvipeer
  My Profile: https://forum.cfx.re/u/MajorFivePD/summary
