
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

<<<<<<< HEAD
        if alt:radar <1450{
=======
        if alt:radar <2750{
>>>>>>> 3a59e188f02236f8b0ced972b63fde070a9fac00
	        SET step TO false. //kill step.
        }
    }
}

function step_Flip_to_up {
    RCS ON.
    DrawVec().
    printComp().    
    GetTelemetry().
    LOCK STEERING TO Up + R(0,0,180).

    Flap_FR_Set(MinFlapAngle).
    Flap_FL_Set(MinFlapAngle).
    Flap_RR_Set(MaxFlapAngle).
    Flap_RL_Set(MaxFlapAngle).



    if ForeAngle<75{
	    SET step TO false. //kill step.
    }
}

function step_Land {
    RCS ON.
    DrawVec().
    printComp().    
    GetTelemetry().

    set xp to 4000.
    // set lt to (LATDiff*xp) * -1.
    // set lg to (LNGDiff*xp) * -1.
    set lt to 0.
    set lg to 0.

    LOCK STEERING TO SRFRETROGRADE+ R(lt,lg,180).
    Flap_FR_Set(MinFlapAngle).
    Flap_FL_Set(MinFlapAngle).
    Flap_RR_Set(MaxFlapAngle).
    Flap_RL_Set(MaxFlapAngle).
    set th to 1 / (  20 /  -ship:VERTICALSPEED).
<<<<<<< HEAD

    if alt:radar < 135{
=======
    if alt:radar < 100{
        GEAR ON.

    }
    if alt:radar < 65{
>>>>>>> 3a59e188f02236f8b0ced972b63fde070a9fac00
        Flap_FR_Set(MaxFlapAngle).
        Flap_FL_Set(MaxFlapAngle).
        Flap_RR_Set(MaxFlapAngle).
        Flap_RL_Set(MaxFlapAngle).
<<<<<<< HEAD
        set th to th + (-ship:VERTICALSPEED/6).
        LOCK STEERING TO Up + R(0,0,180).
    }
    if alt:radar < 85{
        GEAR ON.
=======
        set th to th + (-ship:VERTICALSPEED/5).
        LOCK STEERING TO Up + R(0,0,180).
    }
    if alt:radar < 35{
>>>>>>> 3a59e188f02236f8b0ced972b63fde070a9fac00
        Flap_FR_Set(MaxFlapAngle).
        Flap_FL_Set(MaxFlapAngle).
        Flap_RR_Set(MaxFlapAngle).
        Flap_RL_Set(MaxFlapAngle).
<<<<<<< HEAD
        set th to th + (-ship:VERTICALSPEED/9).
        LOCK STEERING TO Up + R(0,0,180).
    }
    LOCK throttle to th.
    if alt:radar<38{
=======
        set th to th + (-ship:VERTICALSPEED/8).
        LOCK STEERING TO Up + R(0,0,180).
    }
    LOCK throttle to th.
    if alt:radar<22.5{
>>>>>>> 3a59e188f02236f8b0ced972b63fde070a9fac00
        Flap_FR_Set(MaxFlapAngle).
        Flap_FL_Set(MaxFlapAngle).
        Flap_RR_Set(MaxFlapAngle).
        Flap_RL_Set(MaxFlapAngle).
	    SET step TO false. //kill step.
    }
}



 

    
    