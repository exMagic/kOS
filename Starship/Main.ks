global isTest is false.
local targetAltitude is 10000.
global stableSeconds is 0.

global ForeAngle is 0.
global StarAngle is 0.
global TopAngle is 0.
global StarNorthAngle is 0.
global ForeAngleToVel is 0.
// global padLAT is -0.097724.
// global PadLNG is -74.55765.
global padLAT is -0.09721.
global PadLNG is -74.55766.
global latDiff is 0.
global lngDiff is 0.

global myRoll is 0.
global cc is 0.

global RollDiff is 0.
global YawDiff is 0.

global pichSpeed is 0.
global rollSpeed is 0.
global yawSpeed is 0.
global latSpeed is 0.
global lngSpeed is 0.

global rightOffset is 0.
global leftOffset is 0.
global YawOffset is 0.

global previousPitch is 0.
global previousRoll is 0.
global previousYaw is 0.
global previousLat is 0.
global previousLng is 0.

global TLHAngle is 0.
global TRHAngle is 0.
global BLHAngle is 0.
global BRHAngle is 0.


global TopFlapAngle is 0. 
global BottomFlapAngle is 0.

global MaxFlapAngle is 180.
global MinFlapAngle is 90.
global TopFlapAngleDefoult is 135.
global BottomFlapAngleDefoult is 135.
global TargetForAngle is 90.

global myStage is 0.
global lastCount is 0.
global lastCount2 is 0.
global lastCount3 is 0.
global lastCount4 is 0.
global lastCount5 is 0.

global th is 0.
global TouchAltitude is 20.

SET vess to SHIP.
global partlist is vess:PARTSNAMED("hinge.04").

until isTest = false{
    RCS ON.
    SetOrient().
    DrawVec().
    SetFlaps().  
    printComp(). 
}

until false {

    stage.

    until myStage=1{
        //climb
        SetOrient().
        DrawVec().
        printComp().  
        local x is 100.  
        
        LOCK STEERING TO Up + R((-latDiff*500)+15,-lngDiff*500,180).
        set th to 0.
        if (ship:altitude<targetAltitude/4){
            set th to 0.7.
        }else{
            set th to (targetAltitude - ship:altitude)/targetAltitude*0.15.
        }
        
        if ship:VERTICALSPEED<0{
            set th to th * ((ship:VERTICALSPEED * -1)*10).
        }
        
        lock throttle to th.           

        if ship:altitude> targetAltitude/2 and ship:VERTICALSPEED<5 and ship:VERTICALSPEED>-5{
                       
            set stableSeconds to stableSeconds + 1.
            if stableSeconds>5{
                set myStage to myStage + 1.
            }
        }           
    }

    until myStage=2{ 
        //flip to north  
        SetOrient().
        DrawVec().   
        printComp(). 
        SetFlaps().
        
        LOCK STEERING TO Up + R(-45,0,180).
        if (SHIP:FACING:PITCH<320 and SHIP:FACING:PITCH>180){
            lock throttle to 0.
            set myStage to myStage + 1.
        }else{
            lock throttle to 0.2.
        } 
    }

    until myStage=3{
        //desent
        SetOrient().
        
        DrawVec().
        printComp().    
        SetFlaps().
        UNLOCK STEERING.
        if ship:altitude<680{
            set myStage to myStage + 1.
        }
    }

    until myStage=4{
        SetOrient().
        DrawVec().
        printComp().    
        //FLIP to up
        LOCK STEERING TO Up + R(0,0,180).
    
        partlist[2]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle).//bootom right
        partlist[3]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle).//bottom left

        partlist[1]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//top right
        partlist[0]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//top left

        if ForeAngle<20{
            set myStage to myStage + 1.
        }
    }

    until myStage=5{
        SetOrient().
        DrawVec().
        printComp().    
        //LAND
        LOCK STEERING TO SRFRETROGRADE.
        partlist[1]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle).//top right
        partlist[0]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle).//top left
        set th to 1 / (  100 /  -ship:VERTICALSPEED).
        if ship:altitude < 200{
            GEAR ON.
        partlist[2]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle+20).//bootom right
        partlist[3]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle+20).//bottom left
        }
        if ship:altitude < 100{
            set th to th + (-ship:VERTICALSPEED/15).
            LOCK STEERING TO Up + R(0,0,180).
        }

        LOCK throttle to th.
    }
}


/////////////////////////////////////////////////////////////////////////////
///////////////////////////////MY FUNCTIONS//////////////////////////////////
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

function SetOrient{
    set latDiff to padLAT - SHIP:GEOPOSITION:LAT.
    set lngDiff to PadLNG - SHIP:GEOPOSITION:LNG.

        if (time:seconds-lastCount4>0.1){
        set lastCount4 to  time:seconds.

        set newLat to SHIP:GEOPOSITION:LAT.
        set latSpeed to (previousLat - newLat).
        set previousLat to newLat.  

        set newLng to SHIP:GEOPOSITION:LNG.
        set lngSpeed to (previousLng - newLng).
        set previousLng to newLng.               
    }

    set ForeAngle to GetForeAngleToUP().
    set StarAngle to GetStarAngleToUP().
    set TopAngle to GetTopAngleToUP().
    set StarNorthAngle to GetStarAngleToNORTH().
    set ForeAngleToVel to GetForeAngleToVel().
}

function SetFlaps{

    
    

    local PitchReactionMultiFactor is 1.
    local PitchBreakMultiFactor is 20.
    local RollBreakMultiFactor is 10.
    
    ////////////////////////////////////////// PICH
    /////// PICH SPEED
    if (time:seconds-lastCount>0.1){
        set lastCount to  time:seconds.
        set newPitch to ForeAngle.
        set pichSpeed to (previousPitch - newPitch) * -1.
        set previousPitch to newPitch.                
    }
    //////////// CALCULATE PICH
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
    




    ///////////////////////////////////////////// ROLL
    local RollReactionMultiFactor is 0.5.
    local RollBreakMultiFactor is 1.2.
    /////////// ROLL SPEED
    if (time:seconds-lastCount2>0.1){
        set lastCount2 to  time:seconds.
        set newRoll to StarAngle.
        set rollSpeed to (previousRoll - newRoll) * -1.
        set previousRoll to newRoll.                
    }
    /////////// CALCULATE ROLL

    if(TopAngle<90){//roof is on top
        set RollDiff to StarAngle - 90 .
    }else{
        if(StarAngle>90){
            set RollDiff to TopAngle .
        }else{
            set RollDiff to TopAngle * -1 .
        }
    }

    set myRoll to lngDiff * 5000 + (lngSpeed/20).
    if (myRoll >10){
        set myRoll to 10.
    }
    set RollDiff to RollDiff + myRoll.

    if (RollDiff<0){//lean to left
        set rightOffset to RollDiff * RollReactionMultiFactor + rollSpeed * RollBreakMultiFactor.
        set leftOffset to 0.
    }else{//lean to right
        set leftOffset to RollDiff * -1 * RollReactionMultiFactor - rollSpeed * RollBreakMultiFactor.
        set rightOffset to 0.
    }





    //////////////////////////////////////////// YAW
    local YawReactionMultiFactor is 0.3.
    local YawBreakMultiFactor is 0.3.
    /////////// YAW SPEED
    if (time:seconds-lastCount3>0.1){
        set lastCount3 to  time:seconds.
        set newYaw to StarNorthAngle.
        set yawSpeed to (previousYaw - newYaw) * -1.
        set previousYaw to newYaw.                
    }
    /////////// CALCULATE YAW

    if(VANG(ship:facing:forevector,NORTH:vector)<90){//star point to east
        set YawDiff to StarNorthAngle - 90.
    }else{//star point to west
        if(StarNorthAngle>90){
            set YawDiff to VANG(ship:facing:forevector,NORTH:vector).
        }else{
            set YawDiff to VANG(ship:facing:forevector,NORTH:vector) * -1.
        }
    }

    set YawOffset to YawDiff * YawReactionMultiFactor + yawSpeed*YawBreakMultiFactor + yawSpeed.


    //////////////////////////////////////////// NAVIGATION
    ////////////////  SPEED

    ////////////////  LNG SPEED



    ///////////////////////////////////////// SET FLAPS
    local max is 7.
    set cc to (latDiff+0.006)*600.
        if (cc>max){
            set cc to max.
        }
        if (cc <-max){
            set cc to -max.
    }

    set TLHAngle to TopFlapAngle+cc + leftOffset + pichSpeed*PitchBreakMultiFactor + YawOffset.
    set TRHAngle to TopFlapAngle+cc + rightOffset + pichSpeed*PitchBreakMultiFactor - YawOffset.
    set BLHAngle to BottomFlapAngle + leftOffset - pichSpeed*PitchBreakMultiFactor - YawOffset.
    set BRHAngle to BottomFlapAngle + rightOffset - pichSpeed*PitchBreakMultiFactor + YawOffset.

    if (TLHAngle>MaxFlapAngle){
        set TLHAngle to MaxFlapAngle.
    }else if (TLHAngle<MinFlapAngle){
        set TLHAngle to MinFlapAngle.
    }

    if (TRHAngle>MaxFlapAngle){
        set TRHAngle to MaxFlapAngle.
    }else if (TRHAngle<MinFlapAngle){
        set TRHAngle to MinFlapAngle.
    }

    if (BLHAngle>MaxFlapAngle){
        set BLHAngle to MaxFlapAngle.
    }else if (BLHAngle<MinFlapAngle){
        set BLHAngle to MinFlapAngle.
    }

    if (BRHAngle>MaxFlapAngle){
        set BRHAngle to MaxFlapAngle.
    }else if (BRHAngle<MinFlapAngle){
        set BRHAngle to MinFlapAngle.
    }

    partlist[1]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", TRHAngle).//top right
    partlist[0]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", TLHAngle).//top left

    partlist[2]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", BRHAngle).//bootom right
    partlist[3]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", BLHAngle).//bottom left

    if (pichSpeed<0.5 and pichSpeed >-0.5 and ForeAngle<TargetForAngle+2 and ForeAngle>TargetForAngle-2){
        if((TRHAngle + TLHAngle)/2>TopFlapAngleDefoult){
            set TopFlapAngleDefoult to TopFlapAngleDefoult +1.
        }else{
            set TopFlapAngleDefoult to TopFlapAngleDefoult -1.
        }
    }

    if (ForeAngleToVel < 90){
        set TargetForAngle to TargetForAngle-0.5.
    }else{
        set TargetForAngle to TargetForAngle+0.5.
    }
    
    // set TargetForAngle to TargetForAngle + cc.
}.



function printComp{
    clearscreen.
    print "---isTest--          |" +  isTest.
    print "myStage:             |" + myStage.
    print "ship:VERTICALSPEED   |" + ship:VERTICALSPEED.
    print "ForeAngle            |" + ForeAngle.    
    print "TopAngle             |" + TopAngle. 
    print "StarAngle            |" + StarAngle.
    print "StarNorthAngle       |" + StarNorthAngle.
    print "----------------------------------------".
    print "----------------PICH--------------------".
    print "TopFlapAngle         |" + TopFlapAngle.    
    print "BottomFlapAngle      |" + BottomFlapAngle.    
    print "pichSpeed            |" + pichSpeed.
    print "TopFlapAngleDefoult  |" + TopFlapAngleDefoult.
    print "----------------ROLL--------------------".
    print "RollDiff             |" + RollDiff.
    print "rollSpeed            |" + rollSpeed.
    print "rightOffset          |" + rightOffset.
    print "leftOffset           |" + leftOffset.
    print "----------------YAW---------------------".
    print "YawDiff              |" + YawDiff.
    print "yawSpeed             |" + yawSpeed.
    print "YawOffset            |" + YawOffset.
    print "---------------FLAPS--------------------".
    print "TLHAngle             |" + TLHAngle.
    print "TRHAngle             |" + TRHAngle.
    print "BLHAngle             |" + BLHAngle.
    print "BRHAngle             |" + BRHAngle.
    print "-----------------------------------------".
    print "ForeAngleToVel       |" + ForeAngleToVel.
    print "TargetForAngle       |" + TargetForAngle.
    print "th                   |" + th.
    print "-----------------------------------------".
    print "LAT                  |" + SHIP:GEOPOSITION:LAT.
    print "latDiff              |" + latDiff.
    print "latSpeed             |" + latSpeed.
    print "cc                   |" + cc.
    print "-----------------------------------------".
    print "LNG                  |" + SHIP:GEOPOSITION:LNG.
    print "lngDiff              |" + lngDiff.
    print "lngSpeed             |" + lngSpeed.
    print "myRoll               |" + myRoll.


    
    wait 0.05. 
}.

function DrawVec{
        
    SET anArrow TO VECDRAW(
      V(0,0,0),
      SHIP:FACING:vector,
      RGB(1,0,0),
      "See the arrow?",
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
      "See the arrow?",
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
      "VELOCITY",
      1.0,
      TRUE,
      0.5,
      TRUE,
      TRUE
    ).

    SET anArrow4 TO VECDRAW(
      V(0,0,0),
      SHIP:FACING:UPVECTOR,
      RGB(0,0.5,0.5),
      "UP",
      20.0,
      TRUE,
      0.005,
      TRUE,
      TRUE
    ).
    
    SET anArrow5 TO VECDRAW(
      V(0,0,0),
      SHIP:FACING:STARVECTOR,
      RGB(0,1,0.5),
      "UP",
      20.0,
      TRUE,
      0.005,
      TRUE,
      TRUE
    ).
}.

SET SHIP:CONTROL:NEUTRALIZE to TRUE.