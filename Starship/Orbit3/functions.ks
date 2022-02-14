

function GetTelemetry{

    set GroundALT to ship:altitude-SHIP:GEOPOSITION:TERRAINHEIGHT.

    set LATDiff to padLAT - SHIP:GEOPOSITION:LAT.
    set LNGDiff to PadLNG - 0.001 - SHIP:GEOPOSITION:LNG.
    set TargetVector to SHIP:UP:vector + R(0,(VANG(SHIP:VELOCITY:surface, SHIP:up:vector)-70) * -1,0).


    if (ship:GROUNDSPEED<1000){
<<<<<<< HEAD
        if (TargetForAngle < 84){
=======
        if (TargetForAngle < 90){
>>>>>>> 3a59e188f02236f8b0ced972b63fde070a9fac00
            
            set TargetForAngle to TargetForAngle+0.1.
            
        }
    }


    if (time:seconds-lastCount>0.1){
        set lastCount to  time:seconds.

        // LATSpeed
        set newLat to SHIP:GEOPOSITION:LAT.
        set LATSpeed to (previousLat - newLat).
        set previousLat to newLat.  
        
        // LNGSpeed
        set newLng to SHIP:GEOPOSITION:LNG.
        set LNGSpeed to (previousLng - newLng).
        set previousLng to newLng.  

        // PICH SPEED
        set newPitch to ForeAngle.
        set pichSpeed to (previousPitch - newPitch) * -1.
        set previousPitch to newPitch.  
        // ROLL SPEED
        set newRoll to StarAngle.
        set RollSpeed to (previousRoll - newRoll) * -1.
        set previousRoll to newRoll.  
        // YAW SPEED        
        set newYaw to YawDiff.
        set YawSpeed to (previousYaw - newYaw) * -1.
        set previousYaw to newYaw.  
                            
    }

    set ForeAngle to GetForeAngleToUP().
    set StarAngle to GetStarAngleToUP().
    set TopAngle to GetTopAngleToUP().

    set StarToVelAngle to VANG(SHIP:VELOCITY:surface, SHIP:facing:starvector).
    set ForeToVelAngle to VANG(SHIP:VELOCITY:surface, SHIP:facing:forevector).
    set UpToVelAngle to VANG(SHIP:VELOCITY:orbit, SHIP:facing:upvector).
    
    set StarNorthAngle to GetStarAngleToNORTH().
    set ForeAngleToVel to GetForeAngleToVel().


    if (ship:altitude<70000){
        // if (time:seconds-lastCount2>1){
        //     set lastCount2 to  time:seconds.
        //     LOG SHIP:GEOPOSITION:LNG + ", " + ship:altitude + ", " to logfile.
        // }
        SetTRError().
    }


    set AngVelToNorth to VANG(SHIP:VELOCITY:surface,ship:north:vector).

    if (LATDiff<0){
        set AngPadToNorth to 90 + (45 * (abs(LATDiff+0)/abs(LNGDiff))).
    }else{
        set AngPadToNorth to 90 - (45 * (abs(LATDiff+0)/abs(LNGDiff))).
    }

    set AngVelToUp to VANG(SHIP:VELOCITY:surface, SHIP:up:vector).
    set frt0 to 3769911/360 * abs(LNGDiff).
    set frt to  ARCTAN2(ship:altitude,frt0).
    set AngPadToUp to 90 + frt.
    set _Pich to AngPadToUp - AngVelToUp.

}





function SetTRError{
    if(ship:altitude>30000){
        if (_is<mylist:length){

            set _lng to mylist[_is].
            set _alt to mylist[_is+1].            
            
            if(SHIP:GEOPOSITION:LNG>_lng-0.132){
                set _is to _is+2.
                set TRError to  SHIP:ALTITUDE - _alt.
                set newTRError to TRError.
                set TRErrorSpeed to (previousTRError - newTRError) * -1.
                set previousTRError to newTRError.
            }
        }
    }
    else{
        if(Xs<mylist:length){

            set _alt2 to mylist[Xs].
            set _lng2 to mylist[Xs-1].
            
            if(ship:altitude<_alt2){
                set Xs to Xs+2.
                set TRError to  ((SHIP:GEOPOSITION:LNG - _lng2+0.132) * 6000).
                set newTRError to TRError.
                set TRErrorSpeed to (previousTRError - newTRError) * -1.
                set previousTRError to newTRError.
            }
        }            
    }    
                 
}


function printComp{
    clearscreen.
    print "step:                |" + step.
    print "ship:VERTICALSPEED   |" + ship:VERTICALSPEED.
    print "ship:altitude        |" + ship:altitude.
    print "DYNAMICPRESSURE      |" + Ship:DYNAMICPRESSURE.
    print "----------------PICH--------------------".
    print "PichDiff             |" + PichDiff.
    print "pichSpeed            |" + pichSpeed.
    print "PichX1               |" + PichX1.
    print "FrontFlapAngle       |" + FrontFlapAngle.    
    print "BackFlapAngle        |" + BackFlapAngle. 
    print "ForeAngleToVel       |" + ForeAngleToVel.
    print "TargetForAngle       |" + TargetForAngle.
    print "----------------ROLL--------------------".
    print "RollDiff             |" + RollDiff.
    print "RollSpeed            |" + RollSpeed.
    print "RollOffset           |" + RollOffset.    
    print "RollReactionMultiF.  |" + RollReactionMultiFactor.
    print "RollBreakMultiFactor |" + RollBreakMultiFactor.
    print "----------------YAW---------------------".
    print "YawDiff              |" + YawDiff.
    print "YawSpeed             |" + YawSpeed.
    print "yError               |" + yError.
    print "ySpeed               |" + ySpeed.
    print "YawOffset            |" + YawOffset.
    print "YawOffset2           |" + YawOffset2.
    print "-----------------LAT--------------------".
    print "LAT                  |" + SHIP:GEOPOSITION:LAT.
    print "LATDiff              |" + LATDiff.
    print "-----------------LNG--------------------".
    print "LNG                  |" + SHIP:GEOPOSITION:LNG.
    print "LNGDiff              |" + LNGDiff.
    print "lt                   |" + lt.
    print "lg                   |" + lg.
    print "-------------FLAPS----------------------".
    print "FRAngle              |" + FRAngle.
    print "FLAngle              |" + FLAngle.
    print "BRAngle              |" + BRAngle.
    print "BLAngle              |" + BLAngle. 
    print "----------------------------------------".
    print "periapsis            |" +     SHIP:orbit:periapsis.
    print "alt:radar            |" +     alt:radar.
    //print "GroundALT            |" +     GroundALT.
    print "TRError              |" +     TRError.
    print "TRError2             |" +     TRError2.
    print "TRErrorSpeed         |" +     TRErrorSpeed.
    print "TRF                  |" +     TRF.
    print "TRErrorBreakMultiFa. |" +     TRErrorBreakMultiFactor.
    print "----------------------------------------".
<<<<<<< HEAD
    print "fr                         |" +     fr.
    print "PitchReactionMultiFactor   |" +     PitchReactionMultiFactor.
    print "yml                        |" +     yml.
    print "BackFlapMultiFactor        |" +     BackFlapMultiFactor.
    print "BackFlapAngleDefoult       |" +     BackFlapAngleDefoult.
    print "----------------------------------------".
    // print "_lng                 |" +     _lng.
    // print "_alt                 |" +     _alt.
    // print "_lng2                |" +     _lng2.
    // print "_alt2                |" +     _alt2.
    //print "myYAW                |" +     myYAW.
    // print "AngVelToNorth        |" +     AngVelToNorth.
    // print "AngPadToNorth        |" +     AngPadToNorth.
    //print "_Pich................|" +     _Pich.
=======
    print "_is                  |" +     _is.
    print "Xs                   |" +     Xs.
    print "mylist:length        |" +     mylist:length.
    print "_lng                 |" +     _lng.
    print "_alt                 |" +     _alt.
    print "_lng2                |" +     _lng2.
    print "_alt2                |" +     _alt2.
    print "yml                  |" +     yml.
    print "myYAW                |" +     myYAW.
    // print "AngVelToNorth        |" +     AngVelToNorth.
    // print "AngPadToNorth        |" +     AngPadToNorth.
    print "_Pich................|" +     _Pich.
>>>>>>> 3a59e188f02236f8b0ced972b63fde070a9fac00
    // print "AngPadToUp___________|" +     AngPadToUp.
    // print "AngVelToUp___________|" +     AngVelToUp.
    // print "frt .................|" +     frt.
    // print "frt0 ................|" +     frt0.

     set _Pich to AngPadToUp - AngVelToUp.




    //wait 0.05. 
}.

function runstep {
	parameter stepName.
	parameter stepFunction.
	if(step=false){
		SET step TO stepName.
	}
	if(step=stepName){
		UNTIL step = false {			
			stepFunction:call(). //call main step function
		}
	}
}

function DrawVec{

    // SET cros TO VECDRAW(
    //   V(0,0,0),
    //   VCRS(SHIP:VELOCITY:surface, SHIP:up:vector),
    //   RGB(1,0.5,0.2),
    //   "anArrow44",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).

    // SET anArrow44 TO VECDRAW(
    //   V(0,0,0),
    //   VCRS(SHIP:VELOCITY:surface, SHIP:up:vector),
    //   //SHIP:UP:vector + R(0,(VANG(SHIP:VELOCITY:orbit, SHIP:up:vector)-70) * -1,0),
    //   RGB(0,0.7,1),
    //   "anArrow44",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).
    //     SET anArrow44 TO VECDRAW(
    //   V(0,0,0),
    //   Vb,
    //   //SHIP:UP:vector + R(0,(VANG(SHIP:VELOCITY:orbit, SHIP:up:vector)-70) * -1,0),
    //   RGB(1,0.7,0),
    //   "anArrow44",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).

    // SET anArrow TO VECDRAW(
    //   V(0,0,0),
    //   SHIP:FACING:vector,
    //   RGB(1,0,0),
    //   "",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).

    SET anArrow2 TO VECDRAW(
      V(0,0,0),
      SHIP:UP:vector,
      RGB(0,1,0),
      "UP",
      20.0,
      TRUE,
      0.005,
      TRUE,
      TRUE
    ).

    SET anArrow3 TO VECDRAW(
      V(0,0,0),
      SHIP:VELOCITY:SURFACE,
      RGB(0,0,1),
      "",
      1.0,
      TRUE,
      0.5,
      TRUE,
      TRUE
    ).
    // SET anArrow6 TO VECDRAW(
    //   V(0,0,0),
    //   SHIP:VELOCITY:orbit,
    //   RGB(1,0,1),
    //   "",
    //   1.0,
    //   TRUE,
    //   0.5,
    //   TRUE,
    //   TRUE
    // ).

    // SET anArrow4 TO VECDRAW(
    //   V(0,0,0),
    //   SHIP:FACING:UPVECTOR,
    //   RGB(1,0.5,0.5),
    //   "",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).
    
    // SET anArrow5 TO VECDRAW(
    //   V(0,0,0),
    //   SHIP:FACING:STARVECTOR,
    //   RGB(0,1,1),
    //   "",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).
    // //Create a vector to center of kerbin
    // set geo to kerbin:position.
    // set geo:mag to (ship:altitude/2).
    // //Draw global axes for frame of reference
    // //                      /startPos/ /vector/  //color//        /label/  /size/
    // set xAxis to VECDRAWARGS( geo, V(200000,0,0), RGB(1.0,0.5,0.5), "X axis", 5, TRUE ).
    // set yAxis to VECDRAWARGS( geo, V(0,200000,0), RGB(0.5,1.0,0.5), "Y axis", 5, TRUE ).
    // set zAxis to VECDRAWARGS( geo, V(0,0,200000), RGB(0.5,0.5,1.0), "Z axis", 5, TRUE ).
}

function Flap_FR_Set {
    parameter num.
    SHIP:PARTSNAMED("SS.21.FF.R")[0]:GETMODULE("ModuleTundraControlSurface"):SETFIELD("Deploy Angle",num).
    //SHIP:PARTSNAMED("TE2.19.SS.FF.R")[0]:GETMODULE("ModuleTundraControlSurface"):SETFIELD("Deploy Angle",num).
}

function Flap_FL_Set {
    parameter num.
    SHIP:PARTSNAMED("SS.21.FF.L")[0]:GETMODULE("ModuleTundraControlSurface"):SETFIELD("Deploy Angle",num).
    //SHIP:PARTSNAMED("TE2.19.SS.FF.L")[0]:GETMODULE("ModuleTundraControlSurface"):SETFIELD("Deploy Angle",num).
}

function Flap_RR_Set {
    parameter num.
    SHIP:PARTSNAMED("SS.21.RF.R")[0]:GETMODULE("ModuleTundraControlSurface"):SETFIELD("Deploy Angle",num).
    //SHIP:PARTSNAMED("TE2.19.SS.RF.R")[0]:GETMODULE("ModuleTundraControlSurface"):SETFIELD("Deploy Angle",num).
}

function Flap_RL_Set {
    parameter num.
    SHIP:PARTSNAMED("SS.21.RF.L")[0]:GETMODULE("ModuleTundraControlSurface"):SETFIELD("Deploy Angle",num).
    //SHIP:PARTSNAMED("TE2.19.SS.RF.L")[0]:GETMODULE("ModuleTundraControlSurface"):SETFIELD("Deploy Angle",num).
}



