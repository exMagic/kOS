global isDryTest is true.
local targetAltitude is 10000.
global stableSeconds is 0.

global ForeAngle is 0.
global StarAngle is 0.
global TopAngle is 0.

global TargetVector is V(100,5,0).

global StarToVelAngle is 0.
global ForeToVelAngle is 0.
global UPToVelAngle is 0.

global StarNorthAngle is 0.
global ForeAngleToVel is 0.

global pichSpeed is 0.

global RollDiff is 0.
global RollSpeed is 0.
global RightOffset is 0.
global LeftOffset is 0.
global RollBreakMultiFactor is 0.
global RollReactionMultiFactor is 0.
global YawDiff is 0.
global YawSpeed is 0.
global YawOffset is 0.

global padLAT is -0.09721.
global PadLNG is -74.55766.
global LATSpeed is 0.
global LATDiff is 0.
global PichNavCorrection is 0.

global LNGSpeed is 0.
global LNGDiff is 0.
global RollNavCorrection is 0.

global previousPitch is 0.
global previousRoll is 0.
global previousYaw is 0.
global previousLat is 0.
global previousLng is 0.

global TLFAngle is 0.
global TRFAngle is 0.
global BLFAngle is 0.
global BRFAngle is 0.


global TopFlapAngle is 0. 
global BottomFlapAngle is 0.

global MaxFlapAngle is 180.
global MinFlapAngle is 90.
global TopFlapAngleDefoult is 135.
global BottomFlapAngleDefoult is 135.
global TargetForAngle is 60.

global StageNo is 0.
global lastCount is 0.
global th is 0.

SET vess to SHIP.
global partlist is vess:PARTSNAMED("hinge.04").

// until isDryTest = false{ // Set to TRUE if you want to run dry test on the ground.


    //LOCK STEERING TO VXCL(SHIP:FACING:UPVECTOR,-SHIP:VELOCITY:orbit).
    // //LOCK STEERING TO VXCL(SHIP:UP:VECTOR,-SHIP:VELOCITY:orbit).
    // local xx is (VANG(SHIP:VELOCITY:orbit, SHIP:up:vector)-70) * -1.
    
    // if ship:altitude>53000{
    //     RCS ON.         
    //     LOCK STEERING TO Up + R(0,xx,VANG(SHIP:VELOCITY:orbit, SHIP:north:vector)-180).
    // }else{
    //     RCS off. 
    //     UNLOCK STEERING.
    // }
    
    // GetTelemetry().
    // DrawVec().

    // SetFlaps(). 

    // printComp(). 

    // set thrusters to vess:PARTSNAMED("radialEngineMini.v2").
    // set topPL to thrusters[0].
    // set topYL to thrusters[1].
    // set topPR to thrusters[2].
    // set topYR to thrusters[3].
    // set bottomYL to thrusters[4].
    // set bottomYR to thrusters[5].
    // set bottomPL to thrusters[6].
    // set bottomPR to thrusters[7].


    // set topPL to thrusters[8].
    // set topYL to thrusters[9].
    // set topPR to thrusters[10].
    // set topYR to thrusters[11].
    // set bottomYL to thrusters[12].
    // set bottomYR to thrusters[13].
    // set bottomPL to thrusters[14].
    // set bottomPR to thrusters[15].


    // set MainEngines to vess:PARTSNAMED("SSME").
    // set E1 to MainEngines[0].
    // set E2 to MainEngines[1].
    // set E3 to MainEngines[2].

    // E1:SHUTDOWN.
    // E2:SHUTDOWN.
    // E3:SHUTDOWN.

    
    // local ws is 10.

    // lock throttle to 1.

    // topYL:activate.
    // wait ws.
    // topYL:SHUTDOWN.


    // topYR:activate.
    // wait ws.
    // topYR:SHUTDOWN.
    // set engine1:thrustlimit to 100.
    // set engine2:thrustlimit to 100.
    // wait ws.
    // topPL:activate.
    // print "1".
    // wait ws.
    // topPL:SHUTDOWN.

    // wait ws.
    // topYL:activate.
    // print "2".
    // wait ws.
    // topYL:SHUTDOWN.
    
    // wait ws.
    // topPR:activate.
    // print "3".
    // wait ws.
    // topPR:SHUTDOWN.

    // wait ws.
    // topYR:activate.
    // print "4".
    // wait ws.
    // topYR:SHUTDOWN.

    // wait ws.
    // bottomYL:activate.
    // print "5".
    // wait ws.
    // bottomYL:SHUTDOWN.

    // wait ws.
    // bottomYR:activate.
    // print "6".
    // wait ws.
    // bottomYR:SHUTDOWN.
    
    // wait ws.
    // bottomPL:activate.
    // print "7".
    // wait ws.
    // bottomPL:SHUTDOWN.

    // wait ws.
    // bottomPR:activate.
    // print "8".
    // wait ws.
    // bottomPR:SHUTDOWN.
    




//}

/////////////////////////////////////////////////////////////////////////////
////////////////////////////////// STAGES ///////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

//stage.

until StageNo=1{
    // orbit
    GetTelemetry().
    printComp().    
    if (SHIP:GEOPOSITION:LNG<145 and SHIP:GEOPOSITION:LNG>140){
        set StageNo to StageNo + 1.
    }    
}

until StageNo=2{ 
    // deorbit burn
    GetTelemetry().
    printComp().    
    RCS ON.    
    LOCK STEERING TO retrograde.
    GetTelemetry().  
    printComp().  
    //wait 12.  
    if (ForeToVelAngle>175){
        if (SHIP:orbit:periapsis>39000){
            lock throttle to 0.2.
        }else{
            lock throttle to 0.
        } 
    }
    if (SHIP:GEOPOSITION:LNG>145){
        RCS off.
        set StageNo to StageNo + 1.
    } 
}

until StageNo=3{
    // Descent    
    DrawVec().
    printComp().    
    GetTelemetry().
    UNLOCK STEERING.
    if ship:altitude<60000{
        // set StageNo to StageNo + 1.

        local xx is (VANG(SHIP:VELOCITY:orbit, SHIP:up:vector)-70) * -1.
        
        if ship:altitude>53000{
            RCS ON.         
            LOCK STEERING TO Up + R(0,xx,VANG(SHIP:VELOCITY:orbit, SHIP:north:vector)-180).
        }else{
            RCS off. 
            UNLOCK STEERING.
        }

        if ship:altitude >5000{
            SetFlapsVac().
        }else{
            SetFlaps().
        }
        
        if ship:altitude <780{
            set StageNo to StageNo + 1.
        }
    }
}



until StageNo=4{
    // Fip to up
    DrawVec().
    printComp().    
    GetTelemetry().
    LOCK STEERING TO Up + R(0,0,180).

    partlist[2]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle).//bootom right
    partlist[3]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle).//bottom left

    partlist[1]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//top right
    partlist[0]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//top left

    if ForeAngle<50{
        set StageNo to StageNo + 1.
    }
}

until StageNo=5{
    // Land
    DrawVec().
    printComp().    
    GetTelemetry().
    LOCK STEERING TO SRFRETROGRADE.
    partlist[1]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle).//top right
    partlist[0]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle).//top left
    set th to 1 / (  100 /  -ship:VERTICALSPEED).
    if ship:altitude - ship:geoposition:terrainheight < 200{
        GEAR ON.
    partlist[2]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle+20).//bootom right
    partlist[3]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle+20).//bottom left
    }
    if ship:altitude - ship:geoposition:terrainheight < 105{
        set th to th + (-ship:VERTICALSPEED/15).
        LOCK STEERING TO Up + R(0,0,180).
    }
    LOCK throttle to th.
}



/////////////////////////////////////////////////////////////////////////////
/////////////////////////////// MY FUNCTIONS ////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

function GetTopAngleToUP{
    return VANG(ship:facing:TOPVECTOR,ship:up:vector).
}
function GetStarAngleToUP{
    return VANG(ship:facing:STARVECTOR,ship:up:vector).
}
function GetForeAngleToUP{  
    return VANG(ship:facing:forevector,ship:up:vector).
}
function GetStarAngleToNORTH{  
    return VANG(ship:facing:STARVECTOR,ship:north:vector).
}
function GetForeAngleToVel{  
    return VANG(ship:facing:forevector,SHIP:VELOCITY:SURFACE).
}

function GetTelemetry{
    set LATDiff to padLAT - SHIP:GEOPOSITION:LAT.
    set LNGDiff to PadLNG - 0.001 - SHIP:GEOPOSITION:LNG.
    set TargetVector to SHIP:UP:vector + R(0,(VANG(SHIP:VELOCITY:orbit, SHIP:up:vector)-70) * -1,0).

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
        set newYaw to StarNorthAngle.
        set YawSpeed to (previousYaw - newYaw) * -1.
        set previousYaw to newYaw.                             
    }

    set ForeAngle to GetForeAngleToUP().
    set StarAngle to GetStarAngleToUP().
    set TopAngle to GetTopAngleToUP().

    set StarToVelAngle to VANG(SHIP:VELOCITY:orbit, SHIP:facing:starvector).
    set ForeToVelAngle to VANG(SHIP:VELOCITY:orbit, SHIP:facing:forevector).
    set UpToVelAngle to VANG(SHIP:VELOCITY:orbit, SHIP:facing:upvector).
    
    set StarNorthAngle to GetStarAngleToNORTH().
    set ForeAngleToVel to GetForeAngleToVel().
}
function SetFlapsVac{

    /////////////////////////////////////////////////////
    // -- PICH
    local PitchReactionMultiFactor is 1.
    local PitchBreakMultiFactor is 10.
    
    set TopFlapAngle to TopFlapAngleDefoult - (ForeToVelAngle-TargetForAngle)* PitchReactionMultiFactor.
    set BottomFlapAngle to BottomFlapAngleDefoult + (ForeToVelAngle-TargetForAngle)* PitchReactionMultiFactor.
    
    if (TopFlapAngle>MaxFlapAngle){
        set TopFlapAngle to MaxFlapAngle.
    }
    if (TopFlapAngle<MinFlapAngle){
        set TopFlapAngle to MinFlapAngle.
    }
    if (BottomFlapAngle>MaxFlapAngle){
        set BottomFlapAngle to MaxFlapAngle.
    }
    if (BottomFlapAngle<MinFlapAngle){
        set BottomFlapAngle to MinFlapAngle.
    }
    // // -- PichNavCorrection
    // local max is 11.
    // local LATOffset is 0.00462. // Requaire offset of LAT for flipp from horizontal to vertical
    // set PichNavCorrection to (LATDiff + LATOffset) * 3000.
    //     if (PichNavCorrection>max){
    //         set PichNavCorrection to max.
    //     }
    //     if (PichNavCorrection <-max){
    //         set PichNavCorrection to -max.
    // }
    
    /////////////////////////////////////////////////////
    // -- ROLL
    // set RollReactionMultiFactor to 3-(Ship:DYNAMICPRESSURE*3).
    set RollReactionMultiFactor to 0.2.
    //set RollBreakMultiFactor to 3 +((1-Ship:DYNAMICPRESSURE)*3).    
    // set RollBreakMultiFactor to (-Ship:DYNAMICPRESSURE+0.1)*60.    
    set RollBreakMultiFactor to 1.    

    set RollDiff to StarToVelAngle -90.

    // RollNavCorrection
    // set RollNavCorrection to LNGDiff * 5000 + (LNGSpeed/10).
    // if (RollNavCorrection >11){
    //     set RollNavCorrection to 11.
    // }
    //set RollDiff to RollDiff + RollNavCorrection.

    // if (RollDiff>0){//lean to left
    //     set RightOffset to RollDiff * -1 * RollReactionMultiFactor + RollSpeed * RollBreakMultiFactor.
    //     set LeftOffset to RollDiff * RollReactionMultiFactor - RollSpeed * RollBreakMultiFactor.
    // }else{//lean to right
    //     set LeftOffset to RollDiff * RollReactionMultiFactor - RollSpeed * RollBreakMultiFactor.
    //     set RightOffset to RollDiff * -1 * RollReactionMultiFactor + RollSpeed * RollBreakMultiFactor.
    // }

    set RightOffset to 0.
    set LeftOffset to 0.
    /////////////////////////////////////////////////////
    // -- YAW
    local YawReactionMultiFactor is 0.1.
    local YawBreakMultiFactor is 0.2.

    // if(VANG(ship:facing:forevector,NORTH:vector)<90){//star vector points to east
    // }else{//star vector points to west
    //     if(StarNorthAngle>90){
    //         set YawDiff to VANG(ship:facing:forevector,NORTH:vector).
    //     }else{
    //         set YawDiff to VANG(ship:facing:forevector,NORTH:vector) * -1.
    //     }
    // }
    //set YawDiff to StarAngle - 90.
    set YawDiff to VANG(ship:facing:STARVECTOR,TargetVector)-90.



    set YawOffset to YawDiff * YawReactionMultiFactor + YawSpeed*YawBreakMultiFactor + YawSpeed.
    //set YawOffset to 0.

    

    ///////////////////////////////////////////////////
    ///////////////////////////////////////// SET FLAPS
    ///////////////////////////////////////////////////


    set TLFAngle to TopFlapAngle + PichNavCorrection + LeftOffset/2 + pichSpeed * PitchBreakMultiFactor + YawOffset.
    set TRFAngle to TopFlapAngle + PichNavCorrection + RightOffset/2 + pichSpeed * PitchBreakMultiFactor - YawOffset.

    set BLFAngle to BottomFlapAngle + LeftOffset - pichSpeed * PitchBreakMultiFactor - YawOffset.
    set BRFAngle to BottomFlapAngle + RightOffset - pichSpeed * PitchBreakMultiFactor + YawOffset.

    //Limit flaps angle
    if (TLFAngle>MaxFlapAngle){
        set TLFAngle to MaxFlapAngle.
    }else if (TLFAngle<MinFlapAngle){
        set TLFAngle to MinFlapAngle.
    }
    if (TRFAngle>MaxFlapAngle){
        set TRFAngle to MaxFlapAngle.
    }else if (TRFAngle<MinFlapAngle){
        set TRFAngle to MinFlapAngle.
    }
    if (BLFAngle>MaxFlapAngle){
        set BLFAngle to MaxFlapAngle.
    }else if (BLFAngle<MinFlapAngle){
        set BLFAngle to MinFlapAngle.
    }
    if (BRFAngle>MaxFlapAngle){
        set BRFAngle to MaxFlapAngle.
    }else if (BRFAngle<MinFlapAngle){
        set BRFAngle to MinFlapAngle.
    }

    partlist[1]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", TRFAngle).//top right
    partlist[0]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", TLFAngle).//top left

    partlist[2]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", BRFAngle).//bootom right
    partlist[3]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", BLFAngle).//bottom left

    // Adjust TargetForAngle to keep velocity vector close to vertical as posible.
    if(isDryTest = false){
        if (ForeAngleToVel < 90){
            set TargetForAngle to TargetForAngle-0.5.
        }else{
            set TargetForAngle to TargetForAngle+0.5.
        } 
    }
}.
function SetFlaps{

    /////////////////////////////////////////////////////
    // -- PICH
    local PitchReactionMultiFactor is 1.
    local PitchBreakMultiFactor is 20.
    
    set TopFlapAngle to TopFlapAngleDefoult + (ForeAngle-TargetForAngle)* PitchReactionMultiFactor.
    set BottomFlapAngle to BottomFlapAngleDefoult - (ForeAngle-TargetForAngle)* PitchReactionMultiFactor.
    
    if (TopFlapAngle>MaxFlapAngle){
        set TopFlapAngle to MaxFlapAngle.
    }
    if (TopFlapAngle<MinFlapAngle){
        set TopFlapAngle to MinFlapAngle.
    }
    if (BottomFlapAngle>MaxFlapAngle){
        set BottomFlapAngle to MaxFlapAngle.
    }
    if (BottomFlapAngle<MinFlapAngle){
        set BottomFlapAngle to MinFlapAngle.
    }
    // -- PichNavCorrection
    local max is 11.
    local LATOffset is 0.00462. // Requaire offset of LAT for flipp from horizontal to vertical
    set PichNavCorrection to (LATDiff + LATOffset) * 3000.
        if (PichNavCorrection>max){
            set PichNavCorrection to max.
        }
        if (PichNavCorrection <-max){
            set PichNavCorrection to -max.
    }
    
    /////////////////////////////////////////////////////
    // -- ROLL
    local RollReactionMultiFactor is 0.5.
    local RollBreakMultiFactor is 1.0.    

    if(TopAngle<90){//roof points to up
        set RollDiff to StarAngle - 90 .
    }else{
        if(StarAngle>90){//roof poitns to ground
            set RollDiff to TopAngle.
        }else{
            set RollDiff to TopAngle * -1.
        }
    }
    // RollNavCorrection
    set RollNavCorrection to LNGDiff * 5000 + (LNGSpeed/10).
    if (RollNavCorrection >11){
        set RollNavCorrection to 11.
    }
    set RollDiff to RollDiff + RollNavCorrection.

    if (RollDiff<0){//lean to left
        set RightOffset to RollDiff * RollReactionMultiFactor + RollSpeed * RollBreakMultiFactor.
        set LeftOffset to 0.
    }else{//lean to right
        set LeftOffset to RollDiff * -1 * RollReactionMultiFactor - RollSpeed * RollBreakMultiFactor.
        set RightOffset to 0.
    }

    /////////////////////////////////////////////////////
    // -- YAW
    local YawReactionMultiFactor is 0.3.
    local YawBreakMultiFactor is 0.3.

    if(VANG(ship:facing:forevector,NORTH:vector)<90){//star vector points to east
        set YawDiff to StarNorthAngle - 90.
    }else{//star vector points to west
        if(StarNorthAngle>90){
            set YawDiff to VANG(ship:facing:forevector,NORTH:vector).
        }else{
            set YawDiff to VANG(ship:facing:forevector,NORTH:vector) * -1.
        }
    }
    set YawOffset to YawDiff * YawReactionMultiFactor + YawSpeed*YawBreakMultiFactor + YawSpeed.

    

    ///////////////////////////////////////////////////
    ///////////////////////////////////////// SET FLAPS
    ///////////////////////////////////////////////////


    set TLFAngle to TopFlapAngle + PichNavCorrection + LeftOffset + pichSpeed * PitchBreakMultiFactor + YawOffset.
    set TRFAngle to TopFlapAngle + PichNavCorrection + RightOffset + pichSpeed * PitchBreakMultiFactor - YawOffset.
    set BLFAngle to BottomFlapAngle + LeftOffset - pichSpeed * PitchBreakMultiFactor - YawOffset.
    set BRFAngle to BottomFlapAngle + RightOffset - pichSpeed * PitchBreakMultiFactor + YawOffset.

    //Limit flaps angle
    if (TLFAngle>MaxFlapAngle){
        set TLFAngle to MaxFlapAngle.
    }else if (TLFAngle<MinFlapAngle){
        set TLFAngle to MinFlapAngle.
    }
    if (TRFAngle>MaxFlapAngle){
        set TRFAngle to MaxFlapAngle.
    }else if (TRFAngle<MinFlapAngle){
        set TRFAngle to MinFlapAngle.
    }
    if (BLFAngle>MaxFlapAngle){
        set BLFAngle to MaxFlapAngle.
    }else if (BLFAngle<MinFlapAngle){
        set BLFAngle to MinFlapAngle.
    }
    if (BRFAngle>MaxFlapAngle){
        set BRFAngle to MaxFlapAngle.
    }else if (BRFAngle<MinFlapAngle){
        set BRFAngle to MinFlapAngle.
    }

    partlist[1]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", TRFAngle).//top right
    partlist[0]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", TLFAngle).//top left

    partlist[2]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", BRFAngle).//bootom right
    partlist[3]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", BLFAngle).//bottom left

    // Adjust TargetForAngle to keep velocity vector close to vertical as posible.
    if(isDryTest = false){
        if (ForeAngleToVel < 90){
            set TargetForAngle to TargetForAngle-0.5.
        }else{
            set TargetForAngle to TargetForAngle+0.5.
        } 
    }
}.



function printComp{
    clearscreen.
    print "isDryTest            |" + isDryTest.
    print "StageNo:             |" + StageNo.
    print "ship:VERTICALSPEED   |" + ship:VERTICALSPEED.
    print "ForeAngle            |" + ForeAngle.    
    print "TopAngle             |" + TopAngle. 
    print "StarAngle            |" + StarAngle.
    print "StarNorthAngle       |" + StarNorthAngle.Vessel.
    print "DYNAMICPRESSURE      |" + Ship:DYNAMICPRESSURE.
    print "----------------PICH--------------------".
    print "TopFlapAngle         |" + TopFlapAngle.    
    print "BottomFlapAngle      |" + BottomFlapAngle.    
    print "pichSpeed            |" + pichSpeed.
    print "ForeAngleToVel       |" + ForeAngleToVel.
    print "TargetForAngle       |" + TargetForAngle.
    print "----------------ROLL--------------------".
    print "RollDiff             |" + RollDiff.
    print "RollSpeed            |" + RollSpeed.
    print "RightOffset          |" + RightOffset.
    print "LeftOffset           |" + LeftOffset.
    print "RollReactionMultiF.  |" + RollReactionMultiFactor.
    print "RollBreakMultiFactor |" + RollBreakMultiFactor.
    print "----------------YAW---------------------".
    print "YawDiff              |" + YawDiff.
    print "YawSpeed             |" + YawSpeed.
    print "YawOffset            |" + YawOffset.
    print "---------NAVIGATION---------------------".
    print "-----------------LAT--------------------".
    print "LAT                  |" + SHIP:GEOPOSITION:LAT.
    print "LATDiff              |" + LATDiff.
    print "LATSpeed             |" + LATSpeed.
    print "PichNavCorrection    |" + PichNavCorrection.
    print "-----------------LNG--------------------".
    print "LNG                  |" + SHIP:GEOPOSITION:LNG.
    print "LNGDiff              |" + LNGDiff.
    print "LNGSpeed             |" + LNGSpeed.
    print "RollNavCorrection    |" + RollNavCorrection.
    print "----------------------------------------".
    print "-------------FLAPS----------------------".
    print "TLFAngle             |" + TLFAngle.
    print "TRFAngle             |" + TRFAngle.
    print "BLFAngle             |" + BLFAngle.
    print "BRFAngle             |" + BRFAngle. 
    print "SHIP:VELOCITY:SURFACE" +     SHIP:VELOCITY:SURFACE:direction:ROLL.
    print "SHIP:bearing         |" +     SHIP:bearing.
    print "SHIP:heading         |" +     SHIP:heading.
    print "----------------------------------------".
    print "StarToVelAngle       |" +     StarToVelAngle.
    print "ForeToVelAngle       |" +     ForeToVelAngle.
    print "UpToVelAngle         |" +     UpToVelAngle.
    print "----------------------------------------".
    print "periapsis            |" +     SHIP:orbit:periapsis.


   


    //wait 0.05. 
}.

function DrawVec{

    SET anArrow44 TO VECDRAW(
      V(0,0,0),
      SHIP:UP:vector + R(0,(VANG(SHIP:VELOCITY:orbit, SHIP:up:vector)-70) * -1,0),
      RGB(1,0.7,0),
      "anArrow44",
      20.0,
      TRUE,
      0.005,
      TRUE,
      TRUE
    ).

    SET anArrow TO VECDRAW(
      V(0,0,0),
      SHIP:FACING:vector,
      RGB(1,0,0),
      "",
      20.0,
      TRUE,
      0.005,
      TRUE,
      TRUE
    ).

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
    SET anArrow6 TO VECDRAW(
      V(0,0,0),
      SHIP:VELOCITY:orbit,
      RGB(1,0,1),
      "",
      1.0,
      TRUE,
      0.5,
      TRUE,
      TRUE
    ).

    SET anArrow4 TO VECDRAW(
      V(0,0,0),
      SHIP:FACING:UPVECTOR,
      RGB(1,0.5,0.5),
      "",
      20.0,
      TRUE,
      0.005,
      TRUE,
      TRUE
    ).
    
    SET anArrow5 TO VECDRAW(
      V(0,0,0),
      SHIP:FACING:STARVECTOR,
      RGB(0,1,1),
      "",
      20.0,
      TRUE,
      0.005,
      TRUE,
      TRUE
    ).
}.

