global isDryTest is false.
local targetAltitude is 10000.
global stableSeconds is 0.

global ForeAngle is 0.
global StarAngle is 0.
global TopAngle is 0.

global Va is V(0,0,0).
global Vb is V(0,0,0).

global StarToVelAngle is 0.
global ForeToVelAngle is 0.
global UPToVelAngle is 0.

global StarNorthAngle is 0.
global ForeAngleToVel is 0.

global pichSpeed is 0.

global RollDiff is 0.
global RollSpeed is 0.
global RollOffset is 0.
// global RightOffset is 0.
// global LeftOffset is 0.
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
global TargetForAngle is 64.

global StageNo is 2.
global lastCount is 0.
global th is 0.

SET vess to SHIP.
global partlist is vess:PARTSNAMED("hinge.04").

until isDryTest = false{ // Set to TRUE if you want to run dry test on the ground.
    RCS ON.
    GetTelemetry().
    DrawVec().
    SetFlapsVac().  
    printComp(). 
}

/////////////////////////////////////////////////////////////////////////////
////////////////////////////////// STAGES ///////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

//stage.
//
// until StageNo=1{
//     // orbit
//     GetTelemetry().
//     printComp().    
//     if (SHIP:GEOPOSITION:LNG<145 and SHIP:GEOPOSITION:LNG>140){
//         set StageNo to StageNo + 1.
//     }    
// }

// until StageNo=2{ 
//     // deorbit burn
//     GetTelemetry().
//     printComp().    
//     RCS ON.    
//     LOCK STEERING TO retrograde.
//     GetTelemetry().  
//     printComp().  
//     //wait 12.  
//     if (ForeToVelAngle>175){
//         if (SHIP:orbit:periapsis>37600){//37637 //37314
//             lock throttle to 0.04.
            
//         }else{
//             lock throttle to 0.
//         } 
//     }
//     if (SHIP:GEOPOSITION:LNG>148){
//         RCS off.
//         set StageNo to StageNo + 1.
//     } 
// }

until StageNo=3{
    // Descent    
    DrawVec().
    printComp().    
    GetTelemetry().
    UNLOCK STEERING.
    if ship:altitude<60000{
        // set StageNo to StageNo + 1.

        //local xx is (VANG(SHIP:VELOCITY:orbit, SHIP:up:vector)-70) * -1.
        local xx is (VANG(SHIP:VELOCITY:SURFACE, SHIP:up:vector)-70) * -1.
        
        if ship:altitude>53000{
            RCS ON.         
            LOCK STEERING TO Up + R(0,xx,VANG(SHIP:VELOCITY:surface, SHIP:north:vector)-180).
        }else{
            RCS off. 
            UNLOCK STEERING.
        }
        SetFlapsVac().

        // if ship:altitude >23000{
        //     SetFlapsVac().
        // }else{
        //     SetFlaps().
        // }
        
        if ship:altitude <680{
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
    if ship:altitude < 200{
        GEAR ON.
    partlist[2]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle+20).//bootom right
    partlist[3]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle+20).//bottom left
    }
    if ship:altitude < 105{
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
    set TargetVector to SHIP:UP:vector + R(0,(VANG(SHIP:VELOCITY:surface, SHIP:up:vector)-70) * -1,0).

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
}
function SetFlapsVac{

    /////////////////////////////////////////////////////
    // -- PICH
    local PitchReactionMultiFactor is 0.5.
    local PitchBreakMultiFactor is 4.
    
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
    set RollReactionMultiFactor to 0.2.
    set RollBreakMultiFactor to 0.1.   

    set RollDiff to StarToVelAngle -90.
    
    // RollNavCorrection
    // set RollNavCorrection to LNGDiff * 5000 + (LNGSpeed/10).
    // if (RollNavCorrection >11){
    //     set RollNavCorrection to 11.
    // }
    //set RollDiff to RollDiff + RollNavCorrection.
    // if (ship:GROUNDSPEED<300){
    //     set RollOffset to RollDiff * RollReactionMultiFactor + RollSpeed * RollBreakMultiFactor.
    //     // if (RollDiff>0){//lean to left
    //     //     set RightOffset to RollDiff * -1 * RollReactionMultiFactor + RollSpeed * RollBreakMultiFactor.
    //     //     set LeftOffset to RollDiff * RollReactionMultiFactor - RollSpeed * RollBreakMultiFactor.
    //     // }else{//lean to right
    //     //     set LeftOffset to RollDiff * RollReactionMultiFactor - RollSpeed * RollBreakMultiFactor.
    //     //     set RightOffset to RollDiff * -1 * RollReactionMultiFactor + RollSpeed * RollBreakMultiFactor.
    //     // }
    // }else{
    //     set RollOffset to 0.
    // }
    set RollOffset to 0.
    

    /////////////////////////////////////////////////////
    // -- YAW
    local YawReactionMultiFactor is 2.
    local YawBreakMultiFactor is 2.


    if (SHIP:altitude>15000){
        set Va to VCRS(SHIP:VELOCITY:surface, SHIP:up:vector).
    }else{
        set Va to ship:north:vector.
    }
    
    set Vb to VCRS(SHIP:up:vector,Va).





    if (VANG(ship:facing:starvector,Va)>90){
        set YawDiff to VANG(ship:facing:forevector,Va)-90.            
    }else{
        if (VANG(ship:facing:forevector,Va)<90){
            set YawDiff to (90 + VANG(ship:facing:forevector,Va)) *-1.            
        }else{
            set YawDiff to 180 - (VANG(ship:facing:forevector,Va)-90).            
        }
    }


    set YawOffset to YawDiff * YawReactionMultiFactor + YawSpeed * YawBreakMultiFactor.// + (LATDiff*10).

    if (YawOffset>30){
        set YawOffset to 30.
    }
    if (YawOffset<-30){
        set YawOffset to -30.
    }



    ///////////////////////////////////////////////////
    ///////////////////////////////////////// SET FLAPS
    ///////////////////////////////////////////////////


    set TLFAngle to TopFlapAngle + PichNavCorrection + RollOffset/2 + pichSpeed * PitchBreakMultiFactor + YawOffset.
    set TRFAngle to TopFlapAngle + PichNavCorrection - RollOffset/2 + pichSpeed * PitchBreakMultiFactor - YawOffset.

    set BLFAngle to BottomFlapAngle + RollOffset - pichSpeed * PitchBreakMultiFactor - YawOffset/15.
    set BRFAngle to BottomFlapAngle - RollOffset - pichSpeed * PitchBreakMultiFactor + YawOffset/15.

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

    // //Adjust TargetForAngle to keep velocity vector close to vertical as posible.
    // if(isDryTest = false){
    //     if (ForeAngleToVel < 90){
    //         set TargetForAngle to TargetForAngle-0.5.
    //     }else{
    //         set TargetForAngle to TargetForAngle+0.5.
    //     } 
    // }
    if (ship:GROUNDSPEED<1000){
        if (ForeAngleToVel > 90){
            set TargetForAngle to TargetForAngle-0.2.
        }else{
            set TargetForAngle to TargetForAngle+0.2.
        } 
    }

    if (ship:GROUNDSPEED<800 and TopFlapAngleDefoult>125){       
            set TopFlapAngleDefoult to TopFlapAngleDefoult - 0.2.
            set BottomFlapAngleDefoult to BottomFlapAngleDefoult - 0.2.
    }
    
}.


function printComp{
    clearscreen.
    print "isDryTest            |" + isDryTest.
    print "StageNo:             |" + StageNo.
    print "ship:VERTICALSPEED   |" + ship:VERTICALSPEED.
    print "x                    |" + VANG(ship:facing:starvector,Vb).    
    print "x2                   |" + VANG(ship:facing:forevector,Va). 
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
    print "RollOffset           |" + RollOffset.    
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
    print "ship:obt:LAN         |" + ship:obt:LAN.
    print "ship:obt:LAN2        |" + ship:obt:longitudeofascendingnode.
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
    //print "2                    |" +     SHIP:ALTITUDE - SHIP:GEOPOSITION:terrainheight.
    print "3                    |" +     alt:radar.


   


    //wait 0.05. 
}.

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
}.

