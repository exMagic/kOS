
function step_Orbit {
    GetTelemetry().
    printComp().    
    if (SHIP:GEOPOSITION:LNG<145 and SHIP:GEOPOSITION:LNG>140){
        SET step TO false. //kill step.
    }    
	
}

function step_Deorbit_burn {
    local targetPer is 37700.
    GetTelemetry().
    printComp().  
    RCS ON.    
      
    if (SHIP:GEOPOSITION:LNG>140){
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
        local xx is (VANG(SHIP:VELOCITY:SURFACE, SHIP:up:vector)-TargetForAngle) * -1.
        
        if ship:altitude>53000{
            RCS ON.         
            LOCK STEERING TO Up + R(0,xx,VANG(SHIP:VELOCITY:surface, SHIP:north:vector)-180).
        }else{
            RCS off. 

            UNLOCK STEERING.
        }
        SetFlapsVac().

        if ship:altitude <1200{
	        SET step TO false. //kill step.
        }
    }
}

    
    