# busdrivermike v1.1
[![Developer](https://img.shields.io/badge/Developer-WiPAFiveM-BADA55)](https://whatisprojectawesome.com)  
[![Developer](https://img.shields.io/github/repo-size/mikethemadkiwi/busdrivermike)](https://github.com/mikethemadkiwi/busdrivermike/releases/latest)  
Cfx/FiveM Mod : AI Bus Transportation.   
This mod makes buses spawn, carry your player to the specified location dump the, then delete themselves.   
nothing flashy atm cos i havent played with ai yet or timings etc. next version will be much smoother and prettier but for now, here's something at least.   
  
### Updates :  
 V1.1  
    - Map Blips added for moving buses that contain netId. "i'm on bus 54 ralph"  
    - Lowered bus AI updates to require less overhead. ( removes SOME reactiveness, but kills 2/3 of the resource requirements )    
    - added console notifications for AI updates.  
    - server side sync for map blips finally added. ( all players see the same bus blips. )  

### Dependancies  
1. [PolyZone](https://github.com/mkafrin/PolyZone) - https://github.com/mkafrin/PolyZone   
^^^^ Mad props.... this script is awesome...   

### Usage  
1. install and run. no setup needed!   
2. add new stops to the server config! => handy command included ( /GIFW )   

### Things planned to fix.   
1. The god awful AI. it's not TERRIBLE. but it's not great either.  
 ( AI is still godawful... but it's better in some cases, if that makes sense. )   
2. the bus stops. departures arent bad, but the stops are janky.   
3. the way locations are handled. i'd LIKE to tie them to actual bus stops. but again... Dat AI y'all.
4. Bus Spawns moved to server side handled spawn, not client-host handled.

### Thanks to:   
1. 19firefox84 - endless bus rider. on and off on and off.... buses in our dreams.
2. MrJDucky Esq. III - bug testing and endless bus rider.
2. Zvinqq - bug testing and endless bus rider.
3. Plagaᴳᴿᴰ - additional locations and bug reporting.

### [Video Showcase](https://youtu.be/J1AlGcMldQI)
