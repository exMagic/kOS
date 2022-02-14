
function step_Orbit {
    GetTelemetry().
    printComp().    
    if (SHIP:GEOPOSITION:LNG<140 and SHIP:GEOPOSITION:LNG>138){
        SET step TO false. //kill step.
    }    
	
}

function step_Deorbit_burn {
    local targetPer is 38500.
    GetTelemetry().
    printComp().  
    RCS ON.    
<<<<<<< HEAD
      
=======
    
>>>>>>> 3a59e188f02236f8b0ced972b63fde070a9fac00
    if (SHIP:GEOPOSITION:LNG>138){
        LOCK STEERING TO retrograde.
    } 
    if (SHIP:GEOPOSITION:LNG>144){
        LOCK STEERING TO retrograde.
        if (SHIP:orbit:periapsis>47600){
            lock throttle to 0.2.
            
        }else{
            lock throttle to 0.
        }
    } 
    if (SHIP:GEOPOSITION:LNG>149){        
        if (SHIP:orbit:periapsis>targetPer){
            local _th is (SHIP:orbit:periapsis/10000)-(targetPer/10000).
            lock throttle to _th.
            
        }else{
            lock throttle to 0.
            RCS off.
	        SET step TO false. //kill step.
        }
    }    
}

function step_Descent {
    DrawVec().
    printComp().    
    GetTelemetry().
    UNLOCK STEERING.
    if ship:altitude<70000{
        local xx is (VANG(SHIP:VELOCITY:SURFACE, SHIP:up:vector)-TargetForAngle - TRError2) * -1.
        
        if ship:altitude>53000{
            RCS ON.         
            LOCK STEERING TO Up + R(myYAW,xx,VANG(SHIP:VELOCITY:surface, SHIP:north:vector)-180).
        }else{
            RCS off. 

            UNLOCK STEERING.
        }
        SetFlapsVac().

        if ship:altitude <750{
	        SET step TO false. //kill step.
        }
    }
}

function step_Flip_to_up {
    DrawVec().
    printComp().    
    GetTelemetry().
    LOCK STEERING TO Up + R(0,0,180).

    partlist[BRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle).//bootom right
    partlist[BLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle).//bottom left

    partlist[TRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//top right
    partlist[TLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//top left

    if ForeAngle<60{
	    SET step TO false. //kill step.
    }
}

function step_Land {
    DrawVec().
    printComp().    
    GetTelemetry().

    set xp to 4000.
    set lt to (LATDiff*xp) * -1.
    set lg to (LNGDiff*xp) * -1.
    set lt to 0.
    set lg to 0.

    LOCK STEERING TO SRFRETROGRADE+ R(lt,lg,180).
    partlist[TRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle).//top right
    partlist[TLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle).//top left
    set th to 1 / (  50 /  -ship:VERTICALSPEED).
    if alt:radar < 100{
        GEAR ON.
    partlist[BRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle+20).//bootom right
    partlist[BLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle+20).//bottom left
    }
    if alt:radar < 65{
        set th to th + (-ship:VERTICALSPEED/5).
        LOCK STEERING TO Up + R(0,0,180).
    }
    if alt:radar < 35{
        set th to th + (-ship:VERTICALSPEED/8).
        LOCK STEERING TO Up + R(0,0,180).
    }
    LOCK throttle to th.
    if alt:radar<22.5{
	    SET step TO false. //kill step.
    }
}



 

    
    